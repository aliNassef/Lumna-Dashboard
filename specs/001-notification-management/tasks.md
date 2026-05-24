---
description: "Task list for notification management feature implementation"
---

# Tasks: Notification Management

**Input**: Design documents from `/specs/001-notification-management/`

**Prerequisites**: plan.md (required), spec.md (required for user stories)

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter**: `lib/features/notification/`, `lib/core/services/notification/`
- **Edge Function**: `supabase/functions/notification_handler/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create project scaffolding for the edge function and pre-requisites

- [ ] T001 Create supabase/functions/notification_handler/ directory structure with index.ts, deno.json, import_map.json

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**CRITICAL**: No user story work can begin until this phase is complete

- [ ] T002 [P] Apply DB migration: ADD COLUMN image_url to notifications table in supabase/migrations/
- [ ] T003 [P] Apply DB migration: ADD CONSTRAINT notification_type_check on notifications.type in supabase/migrations/
- [ ] T004 [P] Apply DB migration: ADD CONSTRAINT unique_token on user_fcm_tokens.token in supabase/migrations/
- [ ] T005 Implement notification_handler Edge Function core logic in supabase/functions/notification_handler/index.ts — validate payload, fetch FCM tokens (broadcast or targeted), save notification rows to DB, send FCM via Firebase Admin SDK, cleanup invalid tokens

**Checkpoint**: Foundation ready — Edge Function deployed, DB migrations applied, user story implementation can begin

---

## Phase 3: User Story 1 - Admin Sends Manual Notification (Priority: P1) 🎯 MVP

**Goal**: Admin can send manual push notifications from the dashboard form to all users

**Independent Test**: Open dashboard notification page, fill form with title/body/type/image, submit, and verify all users receive notification with correct content

### Implementation for User Story 1

- [ ] T006 [P] [US1] Add `type` and `imageUrl` fields to SendNotificationRequest model in lib/features/notification/data/models/send_notification_request.dart — include in toMap() as per new edge function payload format
- [ ] T007 [P] [US1] Add type dropdown field (general/offer) to send notification form in lib/features/notification/presentation/widgets/send_notification_view_body.dart
- [ ] T008 [P] [US1] Wire image upload: upload picked image to Supabase Storage, set returned URL as imageUrl in SendNotificationRequest in lib/features/notification/presentation/controller/notification_cubit/notification_cubit.dart
- [ ] T009 [US1] Update NotificationCubit.sendNotification() to pass type and imageUrl to the repo in lib/features/notification/presentation/controller/notification_cubit/notification_cubit.dart
- [ ] T010 [US1] Add "Send Notification" quick action tile on home page in lib/features/home/presentation/widgets/quick_actions_section.dart
- [ ] T011 [US1] Simplify or remove targeting_card/targeting_section widgets since manual form is broadcast-only per spec clarification in lib/features/notification/presentation/widgets/
- [ ] T012 [US1] Add translation keys for new form fields (type label, type options) in assets/translations/en.json and assets/translations/ar.json

**Checkpoint**: At this point, User Story 1 should be fully functional — admin can send manual notifications from dashboard

---

## Phase 4: User Story 2 - Automatic Offer Notification (Priority: P2)

**Goal**: Creating a new offer automatically broadcasts a notification to all users without manual intervention

**Independent Test**: Create a new offer via admin panel and verify all users receive a push notification with offer details within 30 seconds

### Implementation for User Story 2

- [ ] T013 [P] [US2] Create Supabase Database Webhook on offers table (INSERT event) that invokes notification_handler edge function in Supabase dashboard
- [ ] T014 [P] [US2] Create DB function `handle_offer_notification()` that builds notification payload from offer data and returns it for webhook delivery in supabase/migrations/

**Checkpoint**: Creating an offer automatically triggers a notification broadcast to all users

---

## Phase 5: User Story 3 - Order Shipped Notification (Priority: P2)

**Goal**: Changing order status to "shipped" automatically sends a notification to the order owner only

**Independent Test**: Change an existing order's status from "pending" to "shipped" and verify only the order owner receives a notification with order details

### Implementation for User Story 3

- [ ] T015 [P] [US3] Create Supabase Database Webhook on orders table (UPDATE event) that invokes notification_handler edge function when status changes to 'shipped' in Supabase dashboard
- [ ] T016 [P] [US3] Create DB function `handle_order_shipped_notification()` that builds notification payload with order owner's user_id and triggers targeted send in supabase/migrations/

**Checkpoint**: Changing order status to "shipped" sends a targeted notification to the order owner only

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T017 [P] Update RemoteNotificationService.sendToAllUsers() in lib/core/services/notification/remote_notification_service.dart to use new payload format with type field
- [ ] T018 Regenerate LocaleKeys after translation updates: dart run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart -O lib/core/translation
- [ ] T019 Run flutter analyze and fix any warnings/errors
- [ ] T020 Run dart format on all changed files
- [ ] T021 End-to-end validation: test all 3 notification sources and verify edge cases

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS all user stories
- **US1 - Manual Notification (Phase 3)**: Depends on Phase 2 — no dependencies on other stories
- **US2 - Auto Offer (Phase 4)**: Depends on Phase 2 — no dependencies on US1 or US3
- **US3 - Auto Order Shipped (Phase 5)**: Depends on Phase 2 — no dependencies on US1 or US2
- **Polish (Phase 6)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) — fully independent
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) — fully independent
- **User Story 3 (P2)**: Can start after Foundational (Phase 2) — fully independent

### Within Each User Story

- Models before UI
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- T002, T003, T004 (migrations) can run in parallel
- T006, T007, T008 (US1) can run in parallel — they touch different files
- T013, T014 (US2) can run in parallel
- T015, T016 (US3) can run in parallel
- US1, US2, US3 can be worked on in parallel once Phase 2 completes

---

## Parallel Example: User Story 1

```bash
# Launch all US1 tasks together (no file conflicts):
Task: "Add type and imageUrl fields to SendNotificationRequest model"
Task: "Add type dropdown to form UI"
Task: "Wire image upload to return URL"
Task: "Add quick action tile on home page"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (Edge Function + Migrations)
3. Complete Phase 3: User Story 1 (Manual Notification)
4. **STOP and VALIDATE**: Test manual notification independently
5. Deploy/demo if ready

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- The notification_handler Edge Function serves ALL 3 user stories — it must be implemented in Phase 2 (Foundational)
- DB Webhooks for US2 and US3 point to the same Edge Function with different payloads
