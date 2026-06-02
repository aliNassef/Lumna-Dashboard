# Quickstart: Order Notifications Feature

## Prerequisites

- Flutter admin app running on device/emulator
- Supabase project with existing `notifications`, `user_fcm_tokens`, `orders`, `profiles` tables
- `notification_handler` edge function deployed
- FCM credentials configured (already done)

## Implementation Steps

### Step 1: Database Trigger

Deploy the SQL trigger contract from [contracts/order-webhook-trigger.sql](contracts/order-webhook-trigger.sql) via Supabase SQL Editor:
1. Create `fn_notify_admin_new_order()` function
2. Create `trg_order_insert_notify_admin` trigger
3. Update `notification_type_check` constraint to include `'order'`

### Step 2: Update `_handleNotificationTap()`

In `lib/core/services/notification/remote_notification_service.dart`:

Replace the stub:
```dart
void _handleNotificationTap(Map<String, dynamic> data) {
  Logger.info('Notification data: $data');
}
```

With navigation logic:
```dart
void _handleNotificationTap(Map<String, dynamic> data) {
  if (data['type'] == 'new_order' && data['order_id'] != null) {
    final cubit = GetIt.instance<OrdersCubit>();
    navigatorKey.currentContext?.pushNamed(
      'order-details',
      arguments: NavArgs(data: {
        'orderId': data['order_id'],
        'orderCubit': cubit,
      }),
    );
  }
}
```

### Step 3: Add FCM Token Registration on Login

In the auth cubit (`lib/features/auth/presentation/controller/auth_cubit/auth_cubit.dart`), after successful `signin()`:

```dart
await RemoteNotificationService.instance.init();
```

This ensures admin FCM token is registered even if login happens after app startup.

### Step 4: Create Notification History View

Create `lib/features/notification/presentation/views/notification_history_view.dart`:

- Route name: `'notification-history'`
- Reuse `RemoteNotificationService.instance.notifications` ValueNotifier (streams `notifications` table)
- Display list with message, timestamp, read/unread indicator
- Support tap → navigate to order details (if `type == 'order'`)
- Support mark-as-read (individual + batch) via `_supabase.from('notifications').update({'is_read': true}).eq('id', id)`
- Register route in `AppRouter`

### Step 5: Register Route

In `lib/core/navigation/app_routes.dart`, add:
```dart
case 'notification-history':
  return MaterialPageRoute(builder: (_) => const NotificationHistoryView());
```

### Step 6: Wire Notification Tap to Dashboard

Add a notification bell/icon in the `LayoutView` app bar or home screen that:
1. Shows unread notification count badge
2. Taps navigate to `notification-history`

### Step 7: Verify

1. Place a test order (from user app or via SQL INSERT)
2. Verify admin receives notification in:
   - Foreground (in-app banner + system notification)
   - Background (system notification)
   - Terminated (system notification on app open)
3. Tap notification → verify navigation to Order Details
4. Check notification history in dashboard
5. Mark as read → verify persistence after app restart
