
-- Fix security warnings: set search_path on functions
CREATE OR REPLACE FUNCTION public.generate_church_code()
RETURNS TEXT
LANGUAGE plpgsql
SET search_path = public
AS $$
DECLARE
  new_code TEXT;
BEGIN
  LOOP
    new_code := upper(substr(md5(random()::text), 1, 6));
    EXIT WHEN NOT EXISTS (SELECT 1 FROM public.churches WHERE code_eglise = new_code);
  END LOOP;
  RETURN new_code;
END;
$$;

CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = public
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- Tighten permissive policies
DROP POLICY IF EXISTS "Authenticated can create church" ON public.churches;
CREATE POLICY "Authenticated can create church" ON public.churches FOR INSERT TO authenticated WITH CHECK (auth.uid() IS NOT NULL);

DROP POLICY IF EXISTS "Admins can create notifications" ON public.notifications;
CREATE POLICY "Admins can create notifications" ON public.notifications FOR INSERT TO authenticated WITH CHECK (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role IN ('admin', 'operateur'))
);
