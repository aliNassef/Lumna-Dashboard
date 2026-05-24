# Supabase Schema Review

Project reviewed: `wwwuzefuhknjtyxcztdk`

Scope:
- Scalability
- RLS security
- Indexing
- Normalization
- Naming conventions
- Realtime performance
- Auth safety

## Findings

### 1. Profile Role Escalation Risk

`public.profiles` has a privilege escalation risk. The policy `Users can update own profile` allows users to update their own row, but `profiles.role` lives on that same row. A signed-in customer can likely set `role = 'admin'`, then pass every `is_admin()` policy.

Recommended fix:
- Revoke client-side updates to `profiles.role`.
- Move roles to an admin-only table, or add a trigger/policy that prevents normal users from changing their own role.
- Keep profile self-service fields such as `full_name` and `avatar_url` separate from authorization fields.

### 2. Offers Write Policies Are Too Permissive

`public.offers` write RLS is too open. Any authenticated user can insert, update, and delete offers because the policies use `true`.

Recommended fix:

```sql
using ((select public.is_admin()))
with check ((select public.is_admin()))
```

Apply that pattern to insert, update, and delete policies, or restrict offer writes to a dedicated admin role.

### 3. Exposed SECURITY DEFINER RPCs

Several `SECURITY DEFINER` functions are exposed through RPC to `anon` and `authenticated`:

- `get_dashboard_summary`
- `get_order_count_growth`
- `get_revenue_growth`
- `handle_new_user`
- `is_admin`
- `place_order`

Risks:
- Dashboard RPCs leak global sales/order metrics.
- `handle_new_user` should not be callable manually.
- `place_order` should be callable only by authenticated users if kept as RPC.

Recommended fix:
- Revoke public execute from these functions.
- Grant execute only to the exact intended roles.
- Keep trigger-only functions unavailable through the exposed API.

### 4. Mutable Function Search Path

Supabase flagged these functions because they do not have a fixed `search_path`:

- `set_notification_read_at`
- `get_dashboard_summary`
- `get_order_count_growth`
- `get_revenue_growth`
- `set_updated_at`
- `place_order`
- `handle_new_user`
- `ensure_single_default_address`
- `touch_cart`
- `touch_order`
- `is_admin`

This is especially important for `SECURITY DEFINER` functions.

Recommended fix:
- Add a fixed search path such as `set search_path = public, pg_temp`.
- Schema-qualify sensitive table and function references.

### 5. SECURITY DEFINER View

`public.sales_stats` is a `SECURITY DEFINER` view. That can bypass caller RLS and expose aggregate revenue/order data.

Recommended fix:
- Prefer `security_invoker = true`.
- Or replace it with an admin-only RPC.
- Or use an admin-only reporting/materialized table.

### 6. Notifications Insert Policy Is Public

`public.notifications` has a policy named `Service role inserts notifications`, but it is defined for `roles = {public}` with `with check true`. This is not service-role-only; it is broad insert access.

Recommended fix:
- Remove this policy if inserts are done with the service role, since the service role bypasses RLS.
- Or restrict notification inserts to admins/service-owned server paths only.

### 7. Realtime Publication Does Not Match App Streams

Realtime is enabled only for:

- `public.orders`
- `public.notifications`

The admin app streams:

- `orders`
- `order_items`
- `profiles`

Relevant code: `lib/features/orders/data/datasource/orders_remote_datasource.dart`

Risk:
- `order_items` and `profiles` changes may not emit reliably to the admin order stream.

Recommended fix:
- Add `order_items` and `profiles` to the realtime publication if the app needs those events.
- Or stream only `orders` and refetch joined data after order-level events.

### 8. Realtime Refetch Pattern May Not Scale

The admin app refetches the full order list after realtime events. This can become expensive as orders grow.

Recommended fix:
- Add pagination.
- Add status/date filters server-side.
- Avoid refetching all orders after every realtime event.
- Add indexes matching the actual admin list queries.

### 9. Missing Foreign Key Indexes

Supabase flagged these unindexed foreign keys:

- `cart_items.product_id`
- `categories.parent_id`
- `content_banners.product_id`
- `order_items.order_id`
- `order_items.product_id`
- `orders.address_id`
- `wishlists.product_id`

Most important for current app behavior:
- `order_items.order_id`, because order details join through order items.
- `order_items.product_id`, because product details are joined from order items.
- `orders.address_id`, because order details load address data.

Recommended fix:
- Add simple btree indexes for the missing FK columns.

### 10. Query Indexes Do Not Fully Match Admin Reads

The app orders products by `created_at desc`, but there is no `products(created_at desc)` index.

Relevant code: `lib/features/products/data/datasource/products_remote_datasource.dart`

The app orders admin order lists by `created_at desc`, but there is no `orders(created_at desc)` index.

Relevant code: `lib/features/orders/data/datasource/orders_remote_datasource.dart`

Recommended fix:
- Add `products(created_at desc)`.
- Add `orders(created_at desc)`.
- Consider `orders(status, created_at desc)` if filtering by status becomes server-side.

### 11. Normalization Concerns

The schema is mostly reasonable for ecommerce, but a few areas will become limiting:

- `products.images text[]`
- `reviews.images text[]`
- `store_settings.value text`

Risks:
- Image arrays limit metadata, ordering, alt text, per-image deletion, and storage cleanup.
- Text settings lose type safety as settings grow.

Recommended fix:
- Introduce `product_images` and `review_images` child tables when image metadata or lifecycle management matters.
- Use `jsonb` or typed settings for `store_settings.value`.

### 12. Order Placement Integrity

`place_order` computes totals from `products.price`, not `sale_price`, and does not check or decrement stock. It also accepts shipping distance and shipping price from the caller.

Risks:
- Incorrect totals during sales.
- Overselling inventory.
- Client-controlled shipping values.

Recommended fix:
- Compute effective price server-side using sale rules.
- Validate or compute shipping server-side.
- Lock cart/product rows while placing an order.
- Decrement stock atomically.
- Reject empty carts and insufficient stock.

### 13. Naming And API Alignment

Database naming is mostly consistent snake_case. The bigger naming/API issue is the client invoking an edge function named `send-notification`, while deployed edge functions are:

- `app_config`
- `notification_handler`
- `shipping_price`

Recommended fix:
- Align the client function name with the deployed function slug.
- Keep function names consistent, preferably action-oriented for RPCs and trigger-specific for trigger functions.

## Priority Fix Order

1. Lock down `profiles.role`, `offers`, `notifications`, `sales_stats`, and exposed `SECURITY DEFINER` RPCs.
2. Add fixed `search_path` to functions and revoke broad RPC execute.
3. Add missing FK and query indexes.
4. Align realtime publication with actual streams or simplify streaming.
5. Normalize image arrays/settings and harden `place_order`.

## Notes

No local Supabase migrations were found in this repo at review time. This review is based on the live Supabase project `wwwuzefuhknjtyxcztdk` plus the Flutter data access code.
