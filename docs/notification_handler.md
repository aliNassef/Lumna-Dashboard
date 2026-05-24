Got it — **dashboard/backend only**. No user app handling.

Copy this for your agent:

---

Implement notification management in the **dashboard + backend**.

The system must support **3 notification sources**:

1. Manual admin notifications.
2. Automatic notification when creating an offer.
3. Automatic notification when order status becomes `shipped`.

---

# 1. Manual Admin Notifications

Create a dashboard page for sending notifications manually.

## Dashboard Form

Fields:

```txt id="4nh73x"
title (required)

body (required)

type (required)

image_url (optional)
```

Supported types:

```txt id="0e4lfn"
general
offer
```

---

## Manual Send Flow

Admin fills form.

Clicks:

```txt id="rq8r0j"
Send Notification
```

Dashboard calls notification edge function.

---

## Request Payload

```json id="4u3x0i"
{
  "title":"Store Update",
  "body":"New products available",
  "type":"general",
  "image_url":"https://cdn.app.com/news.png"
}
```

---

## Backend Behavior

System must:

* validate request
* fetch target tokens
* save notification rows
* send FCM notifications

---

# 2. Automatic Offer Notifications

Notifications must be automatically sent when admin creates an offer.

Admin should not manually send a second notification.

---

## Trigger

New row inserted into:

```txt id="f76eie"
offers
```

---

## Flow

```txt id="4v6b7z"
Admin creates offer
      ↓
offer saved
      ↓
notification auto-generated
      ↓
save notification rows
      ↓
send FCM
```

---

## Payload Generation

Build notification automatically.

Example:

```json id="g1tzbx"
{
  "title":"50% OFF Today",
  "body":"Special discount available",
  "type":"offer",
  "offer_id":"offer_uuid",
  "product_id":"product_uuid",
  "image_url":"offer image"
}
```

---

## Data Source

Use:

```txt id="jlwm1"
offers
products
```

Fetch:

* offer title
* related product id
* product image

---

## Audience

Broadcast to all users.

---

# 3. Automatic Order Notifications

Notifications must be automatically sent when order status changes to `shipped`.

---

## Trigger

Order update.

Example:

```txt id="pxt3sg"
pending → shipped
```

Detected from:

```txt id="jlwm2"
orders.status
```

---

## Flow

```txt id="2x2mlm"
Admin updates order
       ↓
status becomes shipped
       ↓
notification generated
       ↓
save notification row
       ↓
send FCM
```

---

## Recipient Logic

Do NOT broadcast.

Send only to:

```txt id="n0t32f"
order owner
```

Use:

```txt id="4u0mnx"
orders.user_id
```

---

## Payload Example

```json id="t58bnq"
{
  "title":"Order Shipped",
  "body":"Your order is on the way",
  "type":"order",
  "order_id":"order_uuid"
}
```

---

# 4. Edge Function Updates

Update existing notification send function.

---

## Supported Payload

```json id="jlwm3"
{
  "title":"string",
  "body":"string",
  "type":"general",
  "offer_id":null,
  "product_id":null,
  "order_id":null,
  "image_url":null,
  "user_ids":[]
}
```

---

Supported types:

```txt id="rltxgq"
general
offer
order
```

---

## Validation Rules

Required:

```txt id="5x1sbh"
title
body
```

Optional:

```txt id="jlwm4"
image_url
offer_id
product_id
order_id
user_ids
```

If image exists:

```txt id="jlwm5"
must be valid URL
```

---

## Target Logic

If:

```txt id="s7nrtp"
user_ids provided
```

send to selected users.

Else:

broadcast to all users.

---

Examples:

Manual notification:

```txt id="8bh6ye"
broadcast
```

Offer notification:

```txt id="b8iz1d"
broadcast
```

Order shipped:

```txt id="mq4yfh"
single targeted user
```

---

## Database Insert

Save notifications.

Structure:

```ts id="jlwm6"
{
   user_id,
   title,
   body,
   type,
   image_url,
   data:{
      offer_id,
      product_id,
      order_id
   }
}
```

Return inserted ids using:

```ts id="dtsn2l"
.select("id,user_id")
```

---

## FCM Payload

Send both:

### notification payload

```json id="0k4gbd"
{
  "title":"...",
  "body":"...",
  "image":"..."
}
```

### data payload

```json id="jlwm7"
{
  "type":"offer",
  "notification_id":"uuid",
  "offer_id":"uuid",
  "product_id":"uuid",
  "order_id":"uuid",
  "image_url":"https://..."
}
```

---

## Token Cleanup

Delete invalid tokens for:

```txt id="jlwm8"
UNREGISTERED
INVALID_ARGUMENT
NOT_FOUND
```

---

# 5. Database Changes

## notifications

Add:

```sql id="jlwm9"
ALTER TABLE notifications
ADD COLUMN image_url text;
```

Add type constraint:

```sql id="jlwm10"
ALTER TABLE notifications
ADD CONSTRAINT notification_type_check
CHECK (
  type IN (
    'general',
    'offer',
    'order'
  )
);
```

---

## user_fcm_tokens

Prevent duplicates.

```sql id="jlwm11"
ALTER TABLE user_fcm_tokens
ADD CONSTRAINT unique_token
UNIQUE(token);
```

---

# Acceptance Criteria

### Manual Notification

Admin can send normal notifications from dashboard.

---

### Offer Notification

Creating an offer automatically sends notifications.

No manual second step required.

---

### Order Notification

Changing order status to `shipped` automatically sends notification to order owner only.

---

### Backend

Notifications saved correctly.

FCM payload generated correctly.

Invalid tokens cleaned automatically.

---

### Images

Optional image supported in all notification types.
