-- Supabase Database Trigger: Order Insert → Admin Notification
-- Deploy via: Supabase SQL Editor or migration file

-- 1. Create function that will be called by the trigger
CREATE OR REPLACE FUNCTION public.fn_notify_admin_new_order()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  admin_record RECORD;
  notification_id uuid;
BEGIN
  -- Insert notification row for each admin user
  -- Admins are identified by role = 'admin' in profiles table
  FOR admin_record IN 
    SELECT id FROM public.profiles WHERE role = 'admin'
  LOOP
    INSERT INTO public.notifications (
      user_id,
      title,
      body,
      type,
      data,
      is_read,
      created_at
    ) VALUES (
      admin_record.id,
      'New Order',
      'A new order has been placed',
      'order',
      jsonb_build_object('order_id', NEW.id, 'type', 'new_order'),
      false,
      now()
    )
    RETURNING id INTO notification_id;
  END LOOP;

  -- Optionally invoke edge function for push delivery
  -- Requires pg_net extension: https://supabase.com/docs/guides/database/extensions/pgnet
  -- PERFORM net.http_post(
  --   url := '<edge_function_url>',
  --   headers := jsonb_build_object('Content-Type', 'application/json', 'Authorization', 'Bearer <anon_key>'),
  --   body := jsonb_build_object('type', 'new_order', 'order_id', NEW.id)
  -- );

  RETURN NEW;
END;
$$;

-- 2. Create trigger on orders table
DROP TRIGGER IF EXISTS trg_order_insert_notify_admin ON public.orders;
CREATE TRIGGER trg_order_insert_notify_admin
  AFTER INSERT ON public.orders
  FOR EACH ROW
  EXECUTE FUNCTION public.fn_notify_admin_new_order();

-- 3. Add 'order' to notification type constraint
ALTER TABLE public.notifications DROP CONSTRAINT IF EXISTS notification_type_check;
ALTER TABLE public.notifications ADD CONSTRAINT notification_type_check 
  CHECK (type IN ('general', 'offer', 'order'));
