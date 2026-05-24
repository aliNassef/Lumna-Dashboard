-- ============================================================
-- Migration: Critical safe schema security and performance fixes
-- Project:   wwwuzefuhknjtyxcztdk
-- Scope:     RLS, grants, search_path, sales_stats, indexes, realtime
-- Notes:     Review before applying. This file intentionally does not
--            rewrite place_order business logic or add normalization tables.
-- ============================================================

BEGIN;

-- ============================================================
-- 1. RLS SECURITY
-- ============================================================

-- Prevent users from changing their own authorization role.
DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;

CREATE POLICY "Users can update own profile"
  ON public.profiles
  FOR UPDATE
  TO authenticated
  USING ((select auth.uid()) = id)
  WITH CHECK (
    (select auth.uid()) = id
    AND role = (
      SELECT p.role
      FROM public.profiles AS p
      WHERE p.id = (select auth.uid())
    )
  );

-- Restrict offer writes to admins while preserving authenticated reads.
DROP POLICY IF EXISTS "Authenticated users can insert offers" ON public.offers;
DROP POLICY IF EXISTS "Authenticated users can update offers" ON public.offers;
DROP POLICY IF EXISTS "Authenticated users can delete offers" ON public.offers;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON public.offers;
DROP POLICY IF EXISTS "Enable update for authenticated users only" ON public.offers;
DROP POLICY IF EXISTS "Enable delete for authenticated users only" ON public.offers;
DROP POLICY IF EXISTS "Admins can insert offers" ON public.offers;
DROP POLICY IF EXISTS "Admins can update offers" ON public.offers;
DROP POLICY IF EXISTS "Admins can delete offers" ON public.offers;

CREATE POLICY "Admins can insert offers"
  ON public.offers
  FOR INSERT
  TO authenticated
  WITH CHECK ((select public.is_admin()));

CREATE POLICY "Admins can update offers"
  ON public.offers
  FOR UPDATE
  TO authenticated
  USING ((select public.is_admin()))
  WITH CHECK ((select public.is_admin()));

CREATE POLICY "Admins can delete offers"
  ON public.offers
  FOR DELETE
  TO authenticated
  USING ((select public.is_admin()));

-- Service role bypasses RLS, so no broad insert policy is needed.
DROP POLICY IF EXISTS "Service role inserts notifications" ON public.notifications;
DROP POLICY IF EXISTS "Admins can insert notifications" ON public.notifications;

CREATE POLICY "Admins can insert notifications"
  ON public.notifications
  FOR INSERT
  TO authenticated
  WITH CHECK ((select public.is_admin()));

-- ============================================================
-- 2. FUNCTION SEARCH PATHS AND RPC EXECUTE GRANTS
-- ============================================================

CREATE OR REPLACE FUNCTION public.is_admin()
  RETURNS boolean
  LANGUAGE sql
  SECURITY DEFINER
  SET search_path = public, pg_temp
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE id = auth.uid()
      AND role = 'admin'
  );
$$;

CREATE OR REPLACE FUNCTION public.set_updated_at()
  RETURNS trigger
  LANGUAGE plpgsql
  SET search_path = public, pg_temp
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.set_notification_read_at()
  RETURNS trigger
  LANGUAGE plpgsql
  SET search_path = public, pg_temp
AS $$
BEGIN
  IF NEW.is_read = true AND OLD.is_read = false THEN
    NEW.read_at = now();
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.ensure_single_default_address()
  RETURNS trigger
  LANGUAGE plpgsql
  SET search_path = public, pg_temp
AS $$
BEGIN
  IF NEW.is_default = true THEN
    UPDATE public.addresses
    SET is_default = false
    WHERE user_id = NEW.user_id
      AND id <> NEW.id;
  END IF;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.touch_cart()
  RETURNS trigger
  LANGUAGE plpgsql
  SET search_path = public, pg_temp
AS $$
BEGIN
  UPDATE public.carts
  SET updated_at = now()
  WHERE id = COALESCE(NEW.cart_id, OLD.cart_id);
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.touch_order()
  RETURNS trigger
  LANGUAGE plpgsql
  SET search_path = public, pg_temp
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.handle_new_user()
  RETURNS trigger
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public, pg_temp
AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url, email)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url',
    NEW.email
  );
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_dashboard_summary()
  RETURNS json
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public, pg_temp
AS $$
DECLARE
  curr_sales numeric;
  prev_sales numeric;
  curr_orders bigint;
  prev_orders bigint;
  active_prod_count bigint;
BEGIN
  IF NOT (select public.is_admin()) THEN
    RAISE EXCEPTION 'Admin access required';
  END IF;

  SELECT COALESCE(SUM(total_amount), 0)
  INTO curr_sales
  FROM public.orders
  WHERE payment_status = 'paid'
    AND created_at >= date_trunc('month', now());

  SELECT COALESCE(SUM(total_amount), 0)
  INTO prev_sales
  FROM public.orders
  WHERE payment_status = 'paid'
    AND created_at >= date_trunc('month', now() - interval '1 month')
    AND created_at < date_trunc('month', now());

  SELECT COUNT(id)
  INTO curr_orders
  FROM public.orders
  WHERE created_at >= date_trunc('month', now());

  SELECT COUNT(id)
  INTO prev_orders
  FROM public.orders
  WHERE created_at >= date_trunc('month', now() - interval '1 month')
    AND created_at < date_trunc('month', now());

  SELECT COUNT(id)
  INTO active_prod_count
  FROM public.products
  WHERE is_active = true;

  RETURN json_build_object(
    'total_sales', curr_sales,
    'sales_growth', CASE
      WHEN prev_sales = 0 THEN 100
      ELSE ((curr_sales - prev_sales) / prev_sales) * 100
    END,
    'total_orders', curr_orders,
    'orders_growth', CASE
      WHEN prev_orders = 0 THEN 100
      ELSE ((curr_orders::numeric - prev_orders) / prev_orders) * 100
    END,
    'active_products', active_prod_count
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.get_order_count_growth()
  RETURNS TABLE(
    current_month_count bigint,
    previous_month_count bigint,
    percentage_growth numeric
  )
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public, pg_temp
AS $$
DECLARE
  curr_count bigint;
  prev_count bigint;
BEGIN
  IF NOT (select public.is_admin()) THEN
    RAISE EXCEPTION 'Admin access required';
  END IF;

  SELECT COUNT(id)
  INTO curr_count
  FROM public.orders
  WHERE created_at >= date_trunc('month', now());

  SELECT COUNT(id)
  INTO prev_count
  FROM public.orders
  WHERE created_at >= date_trunc('month', now() - interval '1 month')
    AND created_at < date_trunc('month', now());

  RETURN QUERY
  SELECT
    curr_count,
    prev_count,
    CASE
      WHEN prev_count = 0 THEN 100.0
      ELSE ((curr_count::numeric - prev_count::numeric) / prev_count::numeric) * 100
    END;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_revenue_growth()
  RETURNS TABLE(
    current_month_total numeric,
    previous_month_total numeric,
    percentage_growth numeric
  )
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public, pg_temp
AS $$
DECLARE
  curr_total numeric;
  prev_total numeric;
BEGIN
  IF NOT (select public.is_admin()) THEN
    RAISE EXCEPTION 'Admin access required';
  END IF;

  SELECT COALESCE(SUM(total_amount), 0)
  INTO curr_total
  FROM public.orders
  WHERE payment_status = 'paid'
    AND created_at >= date_trunc('month', now());

  SELECT COALESCE(SUM(total_amount), 0)
  INTO prev_total
  FROM public.orders
  WHERE payment_status = 'paid'
    AND created_at >= date_trunc('month', now() - interval '1 month')
    AND created_at < date_trunc('month', now());

  RETURN QUERY
  SELECT
    curr_total,
    prev_total,
    CASE
      WHEN prev_total = 0 THEN 100.0
      ELSE ((curr_total - prev_total) / prev_total) * 100
    END;
END;
$$;

CREATE OR REPLACE FUNCTION public.place_order(
  p_address_id uuid,
  p_payment_method public.payment_method,
  p_notes text,
  p_shipping_distance_km numeric,
  p_shipping_price numeric
)
  RETURNS json
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public, pg_temp
AS $$
DECLARE
  new_order_id uuid;
  v_total_amount numeric;
BEGIN
  SELECT
    p_shipping_price + COALESCE(SUM(p.price * ci.quantity), 0)
  INTO v_total_amount
  FROM public.cart_items AS ci
  JOIN public.carts AS c ON c.id = ci.cart_id
  JOIN public.products AS p ON p.id = ci.product_id
  WHERE c.user_id = auth.uid();

  INSERT INTO public.orders (
    user_id,
    address_id,
    payment_method,
    notes,
    shipping_distance_km,
    shipping_price,
    total_amount
  )
  VALUES (
    auth.uid(),
    p_address_id,
    p_payment_method,
    p_notes,
    p_shipping_distance_km,
    p_shipping_price,
    v_total_amount
  )
  RETURNING id INTO new_order_id;

  INSERT INTO public.order_items (
    order_id,
    product_id,
    product_name,
    unit_price,
    quantity
  )
  SELECT
    new_order_id,
    p.id,
    p.name,
    p.price,
    ci.quantity
  FROM public.cart_items AS ci
  JOIN public.products AS p ON p.id = ci.product_id
  JOIN public.carts AS c ON c.id = ci.cart_id
  WHERE c.user_id = auth.uid();

  DELETE FROM public.cart_items
  WHERE cart_id = (
    SELECT id
    FROM public.carts
    WHERE user_id = auth.uid()
  );

  RETURN json_build_object(
    'success', true,
    'order_id', new_order_id,
    'total_amount', v_total_amount
  );
END;
$$;

REVOKE EXECUTE ON FUNCTION public.get_dashboard_summary() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.get_order_count_growth() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.get_revenue_growth() FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.place_order(
  uuid,
  public.payment_method,
  text,
  numeric,
  numeric
) FROM PUBLIC, anon;
REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM PUBLIC, anon, authenticated;
REVOKE EXECUTE ON FUNCTION public.is_admin() FROM PUBLIC, anon;

GRANT EXECUTE ON FUNCTION public.get_dashboard_summary() TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_order_count_growth() TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_revenue_growth() TO authenticated;
GRANT EXECUTE ON FUNCTION public.place_order(
  uuid,
  public.payment_method,
  text,
  numeric,
  numeric
) TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;

-- ============================================================
-- 3. SALES STATS VIEW
-- ============================================================

DROP VIEW IF EXISTS public.sales_stats;

CREATE VIEW public.sales_stats
  WITH (security_invoker = true)
AS
SELECT
  SUM(total_amount) AS total_revenue,
  COUNT(id) AS total_orders
FROM public.orders
WHERE payment_status = 'paid'::public.payment_status;

REVOKE SELECT ON public.sales_stats FROM PUBLIC, anon;
GRANT SELECT ON public.sales_stats TO authenticated;

-- ============================================================
-- 4. INDEXES
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_cart_items_product_id
  ON public.cart_items(product_id);

CREATE INDEX IF NOT EXISTS idx_categories_parent_id
  ON public.categories(parent_id);

CREATE INDEX IF NOT EXISTS idx_content_banners_product_id
  ON public.content_banners(product_id);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id
  ON public.order_items(order_id);

CREATE INDEX IF NOT EXISTS idx_order_items_product_id
  ON public.order_items(product_id);

CREATE INDEX IF NOT EXISTS idx_orders_address_id
  ON public.orders(address_id);

CREATE INDEX IF NOT EXISTS idx_wishlists_product_id
  ON public.wishlists(product_id);

CREATE INDEX IF NOT EXISTS idx_products_created_at_desc
  ON public.products(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_orders_created_at_desc
  ON public.orders(created_at DESC);

-- ============================================================
-- 5. REALTIME PUBLICATION
-- ============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_publication AS p
    JOIN pg_publication_rel AS pr ON pr.prpubid = p.oid
    JOIN pg_class AS c ON c.oid = pr.prrelid
    JOIN pg_namespace AS n ON n.oid = c.relnamespace
    WHERE p.pubname = 'supabase_realtime'
      AND n.nspname = 'public'
      AND c.relname = 'order_items'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.order_items;
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_publication AS p
    JOIN pg_publication_rel AS pr ON pr.prpubid = p.oid
    JOIN pg_class AS c ON c.oid = pr.prrelid
    JOIN pg_namespace AS n ON n.oid = c.relnamespace
    WHERE p.pubname = 'supabase_realtime'
      AND n.nspname = 'public'
      AND c.relname = 'profiles'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.profiles;
  END IF;
END;
$$;

COMMIT;
