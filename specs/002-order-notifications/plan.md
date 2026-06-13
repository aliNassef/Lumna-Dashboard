# Implementation Plan: Order Notifications

**Branch**: `002-order-notifications` | **Date**: 2026-06-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/002-order-notifications/spec.md`

## Summary

Implement admin-side order notifications — when a user places a new order, the admin receives a push notification (in all app states) and an in-app notification in the dashboard. Tapping navigates to the Order Details screen. Leverages existing FCM infrastructure (RemoteNotificationService, user_fcm_tokens, notifications table) and adds a database trigger on `orders` INSERT to invoke the notification_handler edge function with admin targeting.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.27+

**Primary Dependencies**: firebase_messaging, flutter_local_notifications, supabase_flutter, dartz, flutter_bloc, equatable

**Storage**: Supabase (Postgres) — tables: `notifications`, `user_fcm_tokens`, `orders`

**Push Notification Service**: Firebase Cloud Messaging (FCM) via Supabase Edge Functions

**Testing**: Manual testing via dashboard + physical device push

**Target Platform**: Android / iOS (admin mobile app)

**Project Type**: Flutter mobile app + Supabase Edge Functions

**Performance Goals**: Notification delivery within 5 seconds of order creation

**Constraints**: Order creation must not block on notification; push service unreachable → drop & log (no retry); notification history auto-purged after 30 days

**Scale/Scope**: <5 admin users, <100 orders/day, <5k notification records

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Notes |
|-----------|-------|-------|
| I. Feature-First Architecture | ✅ PASS | Leverages existing `lib/features/orders/`, `lib/core/services/notification/` |
| II. Cubit + Either State Management | ✅ PASS | OrdersCubit already uses correct Cubit+Either pattern |
| III. Supabase Backend Abstraction | ✅ PASS | RemoteNotificationService uses Database interface; Endpoints constants |
| IV. Code Quality & Widget Hygiene | ✅ PASS | Follow existing widget patterns; one widget per file; <120 lines |
| V. Localization & Internationalization | ⚠️ Partial | Notification history UI text must use LocaleKeys; minimal new strings |
| Technology Stack & Constraints | ✅ PASS | All deps (firebase_messaging, flutter_local_notifications) already used |
| File size < 120 lines | ✅ PASS | Augment existing RemoteNotificationService; keep splits as needed |
| Logger not print/debugPrint | ✅ PASS | RemoteNotificationService already uses Logger |
| Routes through AppRouter | ✅ PASS | `order-details` route already registered |
| Navigation via context.pushNamed() | ✅ PASS | Existing pattern |

No violations. Post-design re-check: ✅ All clear. The design leverages existing services and patterns — no new abstractions or architecture deviations introduced.

## Project Structure

### Documentation (this feature)

```text
specs/002-order-notifications/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── checklists/          # Quality checklists
└── contracts/           # Phase 1 output
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/
│   │   └── endpoints.dart          # Add order webhook endpoint constant
│   └── services/
│       └── notification/
│           └── remote_notification_service.dart  # Augment _handleNotificationTap, _showInAppBanner
├── features/
│   ├── notification/
│   │   └── presentation/
│   │       └── views/
│   │           └── notification_history_view.dart  # New: dashboard notification list
│   └── orders/
│       └── presentation/
│           ├── controller/
│           │   └── orders_cubit/   # Augment with notification-aware state (optional)
│           └── views/
│               └── order_details_view.dart  # Already exists — route: 'order-details'
└── main.dart

supabase/functions/notification_handler/  # Already deployed; update logic for admin targeting
```

**Structure Decision**: Augment existing `RemoteNotificationService` rather than creating a new feature module. The notification reception, FCM handling, and in-app display all live in `core/services/notification/`. A new `notification_history_view.dart` goes under the existing `notification` feature. The database trigger for `orders` INSERT is a Supabase-side change.

## Complexity Tracking

No violations found. No complexity justification needed.

## Phase 0: Research

### Unknowns Resolved

All unknowns were researched against the live codebase. See [research.md](research.md) for full findings.

| Unknown | Resolution |
|---------|------------|
| R1: Existing FCM message reception | RemoteNotificationService handles onMessage, onBackgroundMessage, onMessageOpenedApp, getInitialMessage; `_handleNotificationTap` is a stub |
| R2: Order creation triggers | Orders created via `place_order` RPC (user app). No existing INSERT trigger on `orders` table |
| R3: Admin FCM token registration | `_saveFcmToken()` runs at app startup in `init()`. Registers to `user_fcm_tokens` table. Token registration not triggered on login |
| R4: Navigation/deep links | `order-details` route exists; navigation via `context.pushNamed()`; no notification deep link handling |
| R5: Order Details screen | `OrderDetailsView` at route `order-details`; accepts `orderId` and `ordersCubit` |

## Phase 1: Design

### Data Model

Admin notification record stored in existing `notifications` table. See [data-model.md](data-model.md) for full schema.

### Contracts

**Database trigger**: `trg_order_insert_notify_admin`
- **Event**: `AFTER INSERT` on `orders` table
- **Action**: Invoke `notification_handler` edge function via `supabase_functions.request()`
- **Payload**: `{ type: "new_order", order_id: NEW.id, title: "New Order", body: "..." }`

**Edge Function: `notification_handler` augmentation**
- Accept `type: "new_order"` payload
- Admin targeting: fetch admin FCM tokens from `user_fcm_tokens` where `user_id` in admin list
- Insert `notifications` rows for each admin with `type = 'order'`, `order_id` in data payload
- Send FCM push with data payload for navigation

See [contracts/](contracts/) for full contract details.

### Quickstart

See [quickstart.md](quickstart.md) for step-by-step implementation guide.

## Artifacts Generated

| Phase | Artifact | Path |
|-------|----------|------|
| Phase 0 | Research findings | [research.md](research.md) |
| Phase 1 | Data model | [data-model.md](data-model.md) |
| Phase 1 | Database trigger contract | [contracts/order-webhook-trigger.sql](contracts/order-webhook-trigger.sql) |
| Phase 1 | Edge function contract | [contracts/edge-function-payload.md](contracts/edge-function-payload.md) |
| Phase 1 | Implementation quickstart | [quickstart.md](quickstart.md) |
| Phase 1 | Agent context updated | [AGENTS.md](../../AGENTS.md) |

**Next step**: Run `/speckit.tasks` to generate task breakdown from this plan.
