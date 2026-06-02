# Tasks: Order Notifications

**Input**: Design documents from `/specs/002-order-notifications/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Manual verification tasks included (no automated test framework configured).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter project**: `lib/` at repository root
- **Supabase**: Deployed via SQL Editor or Edge Function dashboard

---

## Phase 1: Setup

**Purpose**: Ensure branch is ready and all prerequisites are in place

No project initialization needed — the Flutter admin app already exists with all required dependencies (firebase_messaging, flutter_local_notifications, dartz, flutter_bloc, equatable, supabase_flutter).

- [ ] T001 Verify current branch is `002-order-notifications` by running `git branch --show-current`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core changes that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T002 Deploy `fn_notify_admin_new_order()` function and `trg_order_insert_notify_admin` trigger via Supabase SQL Editor using `specs/002-order-notifications/contracts/order-webhook-trigger.sql`
- [ ] T003 [P] Update `notification_type_check` constraint on `notifications` table to include `'order'` via Supabase SQL Editor
- [ ] T004 Replace `_handleNotificationTap()` stub in `lib/core/services/notification/remote_notification_service.dart` with navigation to `order-details` route, parsing `order_id` and `type` from notification data
- [ ] T005 [P] Add FCM token registration call `RemoteNotificationService.instance.init()` after successful login in `lib/features/auth/presentation/controller/auth_cubit/auth_cubit.dart` `signin()` method

**Checkpoint**: Foundation ready — user story implementation can now begin in parallel

---

## Phase 3: User Story 1 — Admin Receives New Order Notification (Priority: P1) 🎯 MVP

**Goal**: Admin receives a push notification in all app states (foreground, background, terminated) when a user places a new order. Tapping navigates to Order Details.

**Independent Test**: Place a test order (via SQL INSERT into `orders` table) and verify:
- Foreground: notification appears
- Background: system notification appears
- Terminated: system notification appears on app open
- Tap notification navigates to correct Order Details screen

### Implementation for User Story 1

- [ ] T006 [P] [US1] Update `notification_handler` Edge Function on Supabase to handle `type: "new_order"` payload: fetch admin FCM tokens from `user_fcm_tokens`, send push with data payload `{ order_id, type: "new_order" }`, insert `notifications` rows for each admin, clean up invalid tokens
- [ ] T007 [P] [US1] Wire end-to-end: confirm DB trigger invokes edge function on `orders` INSERT, push is delivered, and `_handleNotificationTap()` navigates correctly

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 — Notification History (Priority: P2)

**Goal**: Admin can view previous notifications inside the dashboard with message, order reference, timestamp, and read/unread status.

**Independent Test**: Open the notification history view in the dashboard and verify past notifications are displayed with correct details. Tap an order notification → navigates to Order Details.

### Implementation for User Story 2

- [ ] T008 [P] [US2] Create `NotificationHistoryView` in `lib/features/notification/presentation/views/notification_history_view.dart` — list view using `RemoteNotificationService.instance.notifications` ValueNotifier (streams `notifications` table for current admin user)
- [ ] T009 [P] [US2] Register `'notification-history'` route in `lib/core/navigation/app_routes.dart` pointing to `NotificationHistoryView`
- [ ] T010 [US2] Add navigation entry point (bell icon with unread badge count) in `lib/features/layout/presentation/views/layout_view.dart` or home screen that pushes `'notification-history'`
- [ ] T011 [US2] Wire notification list item tap in `NotificationHistoryView` to navigate to `'order-details'` when `type == 'order'`

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 — Mark Notifications as Read (Priority: P3)

**Goal**: Admin can mark individual or multiple notifications as read. Read state persists after app restart.

**Independent Test**: Mark a notification as read, restart the app, verify it still shows as read. Select multiple notifications, mark all as read, verify batch update.

### Implementation for User Story 3

- [ ] T012 [US3] Implement single notification mark-as-read in `NotificationHistoryView` — call `_supabase.from('notifications').update({'is_read': true, 'read_at': now()}).eq('id', id)` on tap
- [ ] T013 [US3] Implement batch selection mode in `NotificationHistoryView` with select-all and mark-selected-as-read using Supabase `in` filter on notification IDs
- [ ] T014 [US3] Add visual read/unread indicator styling in `NotificationHistoryView` and verify read state persists after app restart

**Checkpoint**: All user stories should now be independently functional

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T015 [P] Add localization keys for all new UI text (notification history labels, empty state, mark-as-read button) in `assets/translations/en.json` and `assets/translations/ar.json`, then regenerate `LocaleKeys`
- [ ] T016 Review error handling: add try-catch around Supabase notification updates, edge function calls, and FCM delivery failures; ensure failures never block order creation or app navigation
- [ ] T017 Run quickstart.md validation: walk through each step in `specs/002-order-notifications/quickstart.md` and verify all instructions are accurate

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - US1 (Phase 3) → US2 (Phase 4) → US3 (Phase 5) recommended sequential order
  - US2 and US3 could in theory proceed in parallel but US3 depends on US2 UI existing
- **Polish (Phase 6)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2). No dependencies on other stories.
- **User Story 2 (P2)**: Depends on Foundational. Integrates with US1 for `type == 'order'` navigation but is independently testable.
- **User Story 3 (P3)**: Depends on US2 (NotificationHistoryView). Builds on the same UI.

### Within Each User Story

- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- T003 and T005 are marked [P] — can run in parallel with T002
- T006 and T007 are marked [P] in US1 — edge function update and verification
- T008 and T009 are marked [P] in US2 — view creation and route registration
- Polish tasks T015 and T017 are [P] — can run in parallel

---

## Parallel Example: User Story 1

```bash
# Launch edge function update and e2e wiring together:
Task: T006 "Update notification_handler Edge Function for admin FCM targeting"
Task: T007 "Wire end-to-end: trigger → push → navigation"
```

## Parallel Example: User Story 2

```bash
# Launch view creation and route registration together:
Task: T008 "Create NotificationHistoryView in lib/features/notification/presentation/views/"
Task: T009 "Register notification-history route in lib/core/navigation/app_routes.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test US1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (edge function, e2e wiring)
   - Wait for US1 completion before starting US2/US3 (UI depends on foundation)

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Supabase changes (trigger, edge function) cannot be version-controlled locally; apply via Supabase SQL Editor
