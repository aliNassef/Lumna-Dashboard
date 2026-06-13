# Research: Order Notifications

## R1: Existing FCM Message Reception

**File**: `lib/core/services/notification/remote_notification_service.dart`

The app already has a fully functional FCM service (`RemoteNotificationService`):

| Handler | Status | Behavior |
|---------|--------|----------|
| `onMessage` (foreground) | ✅ Implemented | Calls `_showLocalNotification()` — displays system notification via `flutter_local_notifications`. Does NOT show an in-app banner |
| `onBackgroundMessage` | ✅ Implemented | Only logs `Logger.info(...)`. Does NOT display local notification |
| `onMessageOpenedApp` (background → tap) | ✅ Implemented | Calls `_handleNotificationTap()` which is a **stub** — only logs |
| `getInitialMessage` (terminated → tap) | ✅ Implemented | Calls `_handleNotificationTap()` — same stub |

**Key finding**: `_handleNotificationTap(Map<String, dynamic> data)` at line 187 only logs `Logger.info('Notification data: $data')`. Navigation to Order Details needs to be wired here.

**Token registration**: `_saveFcmToken()` runs at `init()` (app startup). Upserts into `user_fcm_tokens` with `onConflict: 'user_id'`. Token refresh via `onTokenRefresh` listener.

**In-app notification listener**: `_listenToInAppNotifications()` streams `notifications` table where `user_id == currentUserId`. This is the real-time feed the notification history view will use.

**`sendToAllUsers()`**: Invokes `notification_handler` edge function. Currently broadcasts to all users.

---

## R2: Order Creation Triggers

**Orders are created by the user app** via the `place_order` RPC (Supabase function). The admin dashboard only reads orders, it does not create them.

**Existing database triggers** (from `001-notification-management`):
- `offers` INSERT → broadcast notification to all users
- `orders` UPDATE (status → `shipped`) → targeted notification to order owner

**No existing trigger** on `orders` INSERT. This is the gap — a new webhook or DB trigger is needed.

**Admin order data access**: `OrdersRemoteDataSource` uses REST GET for recent orders and Supabase Realtime streams for the orders list view.

---

## R3: Admin FCM Token Registration

Admin FCM tokens are registered at app startup via `RemoteNotificationService.init()`:
1. Called from `AppConfig.init()` (line 56 of `lib/core/config/app_config.dart`)
2. `_saveFcmToken()` checks `Supabase.instance.client.auth.currentUser?.id`
3. If authenticated → gets FCM token via `FirebaseMessaging.instance.getToken()`
4. Upserts into `user_fcm_tokens` table

**Gap**: Token registration is NOT triggered on login. If admin logs in after app startup, no token is registered until next restart. The login flow (`auth_cubit.dart` → `signin()`) does not call `_saveFcmToken()`.

---

## R4: Navigation & Deep Links

**Route system**: `AppRouter` in `lib/core/navigation/app_routes.dart` uses `onGenerateRoute`. Routes defined by switch on `settings.name`.

**`order-details` route**: Already registered → `OrderDetailsView(orderId: args['orderId'], ordersCubit: args['orderCubit'])`.

**Navigation pattern**: `context.pushNamed('order-details', arguments: NavArgs(data: {'orderId': id, 'orderCubit': cubit}))`.

**Deep link service**: `lib/core/services/auth/deep_link_service.dart` — handles Supabase auth deep links only. No notification deep link handling.

**Gap**: `_handleNotificationTap()` needs to parse `order_id` from notification data and navigate to `order-details`.

---

## R5: Order Details Screen

| Property | Value |
|----------|-------|
| **File** | `lib/features/orders/presentation/views/order_details_view.dart` |
| **Route name** | `'order-details'` |
| **Constructor params** | `orderId` (String), `ordersCubit` (OrdersCubit) |
| **Loading state** | `Skeletonizer` |
| **Error state** | `CustomFailureWidget` |
| **Content** | `OrderDetailsViewBody` with `CustomScrollView` |
| **Sub-widgets** | `OrderDetailHeader`, `CustomerDetailCard`, `ShippingAddressCard`, `PaymentInfoCard` |

The screen already exists and is fully functional for displaying order details from an `orderId`.
