# Feature Specification: Notification Management

**Feature Branch**: `001-notification-management`

**Created**: 2026-05-24

**Status**: Draft

**Input**: User description: "Implement notification management in the dashboard and backend with manual admin notifications, automatic notifications when creating an offer, and automatic notifications when order status becomes shipped"

## Clarifications

### Session 2026-05-24

- Q: Who can access the notification dashboard page? → A: Any authenticated admin can send notifications — no additional role/permission restriction beyond existing admin authentication.
- Q: What should happen when the push notification service is unreachable? → A: Notifications should be queued for retry with automatic retry logic.
- Q: Should scheduled/delayed notifications be supported? → A: Out of scope — all notifications send immediately upon trigger or admin action.
- Q: Should delivery status tracking be visible in the dashboard? → A: Out of scope — no delivery status UI needed.
- Q: What is the expected notification volume? → A: Standard web app expectations — no special volume handling required.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Admin Sends Manual Notification (Priority: P1)

An admin navigates to the notification management page in the dashboard, fills out a form with title, body, type (general/offer), and optional image URL, then clicks "Send Notification". The system broadcasts the notification to all users.

**Why this priority**: This is the core manual notification feature that gives the admin direct control over push notifications to all users.

**Independent Test**: Can be fully tested by opening the dashboard notification page, filling the form, sending a notification, and verifying all users receive the push notification with correct content.

**Acceptance Scenarios**:

1. **Given** the admin is on the notification page, **When** they fill all required fields (title, body, type) and click "Send Notification", **Then** the notification is sent to all users and a success confirmation is shown
2. **Given** the admin fills the form with an optional image_url, **When** they click "Send Notification", **Then** the notification includes the image in the push notification payload
3. **Given** the admin submits the form with empty required fields (title or body), **When** they click "Send Notification", **Then** validation errors are shown and no notification is sent
4. **Given** the admin provides an image_url that is not a valid URL, **When** they click "Send Notification", **Then** a validation error is shown

---

### User Story 2 - Automatic Offer Notification (Priority: P2)

When an admin creates an offer (discount/promotion), the system automatically generates and broadcasts a notification to all users without requiring a manual second step.

**Why this priority**: Automating offer notifications ensures users are promptly informed about new promotions without extra admin effort.

**Independent Test**: Can be tested by creating a new offer through the admin panel and verifying that a notification with the offer details is automatically sent to all users.

**Acceptance Scenarios**:

1. **Given** a new offer is created in the system, **When** the offer is saved, **Then** a notification is automatically generated with the offer title, related product info, and image, then broadcast to all users
2. **Given** a new offer is created, **When** the notification is sent, **Then** the notification payload includes offer_id, product_id, and type "offer"

---

### User Story 3 - Order Shipped Notification (Priority: P2)

When an admin updates an order status to "shipped", the system automatically sends a notification to the order owner (not broadcast) informing them their order is on the way.

**Why this priority**: Order fulfillment notifications are critical for customer experience but affect individual users rather than all users.

**Independent Test**: Can be tested by changing an existing order's status to "shipped" and verifying that only the order owner receives a notification with order details.

**Acceptance Scenarios**:

1. **Given** an order exists with status "pending", **When** an admin changes the status to "shipped", **Then** a notification is sent only to the order owner (not broadcast to all users)
2. **Given** an order status is changed to "shipped", **When** the notification is generated, **Then** the payload includes order_id and type "order"
3. **Given** an order status is changed to a non-"shipped" status (e.g., "delivered", "cancelled"), **When** the change is saved, **Then** no automatic notification is triggered

---

### Edge Cases

- What happens when a push notification send fails for some device tokens? System should continue sending to remaining tokens and clean up invalid/unregistered tokens.
- What happens when an offer creation fails mid-process? No notification should be sent if the offer insert does not complete.
- What happens when a user has multiple device tokens? All tokens should receive the notification.
- What happens when no device tokens exist for any user? The notification should be saved to the database but no push send attempted.
- What happens when the image URL is invalid or broken? The notification should still send without the image component.
- What happens when an order owner has no device tokens? The notification row should still be saved but no push send attempted for that user.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide a dashboard page with a form for sending manual push notifications, with fields for title (required), body (required), type (required), and image_url (optional)
- **FR-002**: System MUST validate that title and body are not empty before sending a manual notification
- **FR-003**: System MUST validate that image_url, if provided, is a valid URL format
- **FR-004**: System MUST support notification types: "general" and "offer" for manual notifications
- **FR-005**: System MUST automatically generate a broadcast notification when a new offer is inserted into the offers table
- **FR-006**: System MUST automatically generate a targeted notification to the order owner when an order status changes to "shipped"
- **FR-007**: System MUST fetch the appropriate device push tokens before sending — broadcast to all users for manual and offer notifications, targeted to the order owner for order-shipped notifications
- **FR-008**: System MUST save each notification as a database record containing user_id, title, body, type, image_url, and data payload (offer_id, product_id, order_id as applicable)
- **FR-009**: System MUST send push notifications with both a visible notification component (title, body, image) and a data component (type, notification_id, offer_id, product_id, order_id, image_url)
- **FR-010**: System MUST clean up invalid device tokens after send failures (e.g., unregistered, invalid, not found)
- **FR-011**: System MUST add an `image_url` column to the notifications table
- **FR-012**: System MUST add a CHECK constraint on notifications.type to restrict values to 'general', 'offer', and 'order'
- **FR-013**: System MUST enforce unique device tokens to prevent duplicates

### Key Entities *(include if feature involves data)*

- **Notification**: A record of a push notification sent to a user. Contains user_id, title, body, type, image_url, and a data payload with offer_id/product_id/order_id references.
- **User Device Token**: A push notification registration token associated with a user's device, used to deliver push notifications.
- **Offer**: A promotional discount/offer created by the admin. Creating one triggers an automatic broadcast notification.
- **Order**: A customer purchase order. Updating its status to "shipped" triggers an automatic targeted notification to the order owner.
- **Profile**: User profile containing contact information, linked via user_id for determining notification recipients.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Admin can complete a manual notification send from form submission to confirmation in under 10 seconds
- **SC-002**: Automatic offer notifications are triggered within 30 seconds of offer creation
- **SC-003**: Automatic order-shipped notifications reach the order owner within 30 seconds of status change
- **SC-004**: 100% of opted-in users with valid device tokens receive broadcast notifications
- **SC-005**: Invalid device tokens are cleaned up automatically after each send batch with zero manual intervention
- **SC-006**: Zero duplicate notifications are sent for a single offer creation or order status change event
- **SC-007**: Notification history is preserved in the database for auditing and user reference

## Assumptions

- Existing Firebase Cloud Messaging (FCM) credentials are already configured in the project environment
- The dashboard already has an existing admin authentication system that will be reused
- Supabase Edge Functions will be used for backend notification processing
- Manual notifications are always broadcast to all users (no user targeting in manual form)
- The notifications table already exists and only needs the image_url column and type constraint added
- The user_fcm_tokens table already exists and only needs the unique token constraint added
- Users have granted notification permission on their devices (FCM token validity is managed by FCM)
- Image URLs will be publicly accessible URLs, not uploaded files
- Database triggers or webhooks will be used to detect offer inserts and order status changes
