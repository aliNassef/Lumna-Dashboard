# Data Model: Order Notifications

## Overview

Admin order notifications reuse the existing `notifications` table in Supabase. The `RemoteNotificationService` already streams this table for in-app display. A new `type = 'order'` is used to distinguish order notifications from general/offer notifications.

## Existing Tables (no changes needed)

### `notifications`

| Column | Type | Description |
|--------|------|-------------|
| `id` | `uuid` PK | Auto-generated |
| `user_id` | `uuid` FK → `profiles.id` | Recipient (admin user) |
| `title` | `text` | Notification title |
| `body` | `text` | Notification body / message |
| `type` | `text` | Type: `'general'`, `'offer'`, `'order'` (add `'order'` to constraint) |
| `data` | `jsonb` | Payload: `{ order_id, type: "new_order" }` |
| `image_url` | `text?` | Notification image (null for order notifications) |
| `is_read` | `boolean` | Read status (default: false) |
| `read_at` | `timestamp?` | When notification was read |
| `created_at` | `timestamptz` | When notification was created |
| `delivered_at` | `timestamptz?` | When push was delivered |

**Changes needed**: Add `'order'` to the `notification_type_check` constraint:
```sql
ALTER TABLE notifications DROP CONSTRAINT IF EXISTS notification_type_check;
ALTER TABLE notifications ADD CONSTRAINT notification_type_check 
  CHECK (type IN ('general', 'offer', 'order'));
```

### `user_fcm_tokens`

| Column | Type | Description |
|--------|------|-------------|
| `user_id` | `uuid` FK → `profiles.id` | Admin user |
| `token` | `text` | FCM device token (unique) |

No changes needed. Existing table used for admin push delivery.

### `orders`

| Column | Type | Description |
|--------|------|-------------|
| `id` | `uuid` PK | Order identifier |
| ... | ... | (existing fields) |

No changes needed. The trigger fires on INSERT.

## New: Database Trigger

### `trg_order_insert_notify_admin`

- **Event**: `AFTER INSERT ON orders FOR EACH ROW`
- **Function**: `fn_notify_admin_new_order()`
- **Language**: `plpgsql`
- **Behavior**:
  1. Fetch admin user IDs from `profiles` where role = 'admin' (or use a hardcoded admin lookup)
  2. For each admin, insert a `notifications` row with `type = 'order'`, `data = jsonb_build_object('order_id', NEW.id, 'type', 'new_order')`
  3. Optionally invoke `net.http_post()` to trigger the `notification_handler` edge function for push delivery

### Edge Function Payload

**Trigger → Edge Function**: When `net.http_post()` is used, send:

```json
{
  "type": "new_order",
  "order_id": "<uuid>",
  "title": "New Order #<short_id>",
  "body": "A new order has been placed"
}
```

The edge function fetches admin FCM tokens and sends push notifications.

## State Transitions

```
Order Created (INSERT on orders)
       │
       ▼
Trigger fires → fn_notify_admin_new_order()
       │
       ├── Insert notifications row(s) for admin(s)
       └── Invoke notification_handler edge function for push delivery
               │
               ▼
         Admin receives push (foreground/background/terminated)
               │
               ▼
         Admin taps notification → _handleNotificationTap() navigates to order-details
               │
               ▼
         Admin views notification history → marks as read (is_read = true)
```
