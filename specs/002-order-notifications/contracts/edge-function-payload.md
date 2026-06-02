# Contract: `notification_handler` Edge Function — Admin Order Notification

## Trigger

The edge function is invoked when the `trg_order_insert_notify_admin` database trigger fires on `orders` INSERT (via `net.http_post()` or when the function is called from Flutter after an order is detected).

## Input Payload

```json
{
  "type": "new_order",
  "order_id": "uuid"
}
```

## Behavior

1. **Validate**: `type == "new_order"` and `order_id` is a valid UUID
2. **Fetch admin tokens**: Query `user_fcm_tokens` for all admin users (users with `role = 'admin'` in `profiles`)
3. **Check existing notifications**: Skip if a `notifications` row with same `type = 'order'`, `data->>'order_id'` already exists for this admin (dedup)
4. **Send FCM push**: For each admin token, send FCM message with:
   - `notification.title`: "New Order"
   - `notification.body`: "A new order has been placed"
   - `data.order_id`: the order UUID
   - `data.type`: "new_order"
5. **Cleanup invalid tokens**: On FCM error (UNREGISTERED, INVALID_ARGUMENT), delete the invalid token from `user_fcm_tokens`
6. **Log**: Record delivery success/failure in application logs

## Output

```json
{
  "success": true,
  "admin_count": 2,
  "notification_ids": ["uuid1", "uuid2"]
}
```

On failure:

```json
{
  "success": false,
  "error": "message"
}
```

## Flutter Side Contract

In `RemoteNotificationService._handleNotificationTap()`:

```dart
void _handleNotificationTap(Map<String, dynamic> data) {
  if (data['type'] == 'new_order' && data['order_id'] != null) {
    // Navigate to order-details
    navigatorKey.currentContext?.pushNamed(
      'order-details',
      arguments: NavArgs(data: {
        'orderId': data['order_id'],
        'orderCubit': GetIt.instance<OrdersCubit>(),
      }),
    );
  }
}
```
