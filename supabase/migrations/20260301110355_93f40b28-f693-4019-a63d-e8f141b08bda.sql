
-- 1. Enum pour les rôles
CREATE TYPE public.app_role AS ENUM ('admin', 'operateur', 'fidele');

-- 2. Table churches
CREATE TABLE public.churches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nom TEXT NOT NULL,
  adresse TEXT,
  ville TEXT,
  pays TEXT DEFAULT 'Cameroun',
  telephone TEXT,
  email TEXT,
  site_web TEXT,
  logo_url TEXT,
  code_eglise TEXT UNIQUE,
  description TEXT,
  denomination TEXT,
  pasteur_principal TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. Table user_roles
CREATE TABLE public.user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  church_id UUID REFERENCES public.churches(id) ON DELETE CASCADE NOT NULL,
  role public.app_role NOT NULL DEFAULT 'fidele',
  full_name TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, church_id)
);

-- 4. Table members
CREATE TABLE public.members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  church_id UUID REFERENCES public.churches(id) ON DELETE CASCADE NOT NULL,
  nom TEXT NOT NULL,
  prenom TEXT,
  email TEXT,
  telephone TEXT,
  adresse TEXT,
  date_naissance DATE,
  date_adhesion DATE DEFAULT CURRENT_DATE,
  statut TEXT DEFAULT 'actif',
  photo_url TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 5. Table donations
CREATE TABLE public.donations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  church_id UUID REFERENCES public.churches(id) ON DELETE CASCADE NOT NULL,
  member_id UUID REFERENCES public.members(id) ON DELETE SET NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  montant DECIMAL(12,2) NOT NULL,
  type TEXT DEFAULT 'dime',
  mode_paiement TEXT DEFAULT 'especes',
  reference TEXT,
  statut TEXT DEFAULT 'completed',
  notes TEXT,
  date_don TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 6. Table announcements
CREATE TABLE public.announcements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  church_id UUID REFERENCES public.churches(id) ON DELETE CASCADE NOT NULL,
  titre TEXT NOT NULL,
  contenu TEXT NOT NULL,
  type TEXT DEFAULT 'annonce',
  image_url TEXT,
  date_evenement TIMESTAMPTZ,
  auteur_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  est_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 7. Table prayer_requests
CREATE TABLE public.prayer_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  church_id UUID REFERENCES public.churches(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  sujet TEXT NOT NULL,
  description TEXT,
  est_anonyme BOOLEAN DEFAULT false,
  statut TEXT DEFAULT 'active',
  nombre_prieres INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 8. Table messages
CREATE TABLE public.messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  church_id UUID REFERENCES public.churches(id) ON DELETE CASCADE NOT NULL,
  sender_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  contenu TEXT NOT NULL,
  type TEXT DEFAULT 'general',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 9. Table notifications
CREATE TABLE public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  church_id UUID REFERENCES public.churches(id) ON DELETE CASCADE,
  titre TEXT NOT NULL,
  message TEXT,
  type TEXT DEFAULT 'info',
  est_lue BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 10. Table ministries
CREATE TABLE public.ministries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  church_id UUID REFERENCES public.churches(id) ON DELETE CASCADE NOT NULL,
  nom TEXT NOT NULL,
  description TEXT,
  responsable_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 11. Table ministry_missions
CREATE TABLE public.ministry_missions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ministry_id UUID REFERENCES public.ministries(id) ON DELETE CASCADE NOT NULL,
  titre TEXT NOT NULL,
  description TEXT,
  statut TEXT DEFAULT 'en_cours',
  date_debut DATE,
  date_fin DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 12. Table spiritual_resources
CREATE TABLE public.spiritual_resources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  church_id UUID REFERENCES public.churches(id) ON DELETE CASCADE NOT NULL,
  titre TEXT NOT NULL,
  contenu TEXT,
  type TEXT DEFAULT 'article',
  auteur TEXT,
  url_media TEXT,
  est_public BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 13. Table activity_logs
CREATE TABLE public.activity_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  church_id UUID REFERENCES public.churches(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  action TEXT NOT NULL,
  details JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 14. Fonction has_role (SECURITY DEFINER)
CREATE OR REPLACE FUNCTION public.has_role(_user_id UUID, _role public.app_role)
RETURNS BOOLEAN
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = _user_id AND role = _role
  )
$$;

-- 15. Fonction generate_church_code
CREATE OR REPLACE FUNCTION public.generate_church_code()
RETURNS TEXT
LANGUAGE plpgsql
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

-- 16. Fonction updated_at trigger
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- 17. Triggers updated_at
CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.churches FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.members FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.announcements FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.prayer_requests FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.ministries FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.spiritual_resources FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

-- 18. Enable RLS on all tables
ALTER TABLE public.churches ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.donations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.prayer_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ministries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ministry_missions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.spiritual_resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;

-- 19. RLS Policies

-- user_roles: users can read their own roles
CREATE POLICY "Users can read own roles" ON public.user_roles FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Admins can manage roles" ON public.user_roles FOR ALL TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles ur WHERE ur.user_id = auth.uid() AND ur.role = 'admin' AND ur.church_id = user_roles.church_id)
);
CREATE POLICY "Users can insert own role" ON public.user_roles FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

-- churches: members can read their church
CREATE POLICY "Users can read own church" ON public.churches FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = churches.id)
);
CREATE POLICY "Anyone can read churches for joining" ON public.churches FOR SELECT TO authenticated USING (true);
CREATE POLICY "Admins can update church" ON public.churches FOR UPDATE TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin' AND church_id = churches.id)
);
CREATE POLICY "Authenticated can create church" ON public.churches FOR INSERT TO authenticated WITH CHECK (true);

-- members
CREATE POLICY "Church members can read members" ON public.members FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = members.church_id)
);
CREATE POLICY "Admins can manage members" ON public.members FOR ALL TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role IN ('admin', 'operateur') AND church_id = members.church_id)
);
CREATE POLICY "Users can insert as member" ON public.members FOR INSERT TO authenticated WITH CHECK (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = members.church_id)
);

-- donations
CREATE POLICY "Church members can read donations" ON public.donations FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = donations.church_id)
);
CREATE POLICY "Users can create donations" ON public.donations FOR INSERT TO authenticated WITH CHECK (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = donations.church_id)
);
CREATE POLICY "Admins can manage donations" ON public.donations FOR ALL TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role IN ('admin', 'operateur') AND church_id = donations.church_id)
);

-- announcements
CREATE POLICY "Church members can read announcements" ON public.announcements FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = announcements.church_id)
);
CREATE POLICY "Admins can manage announcements" ON public.announcements FOR ALL TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role IN ('admin', 'operateur') AND church_id = announcements.church_id)
);

-- prayer_requests
CREATE POLICY "Church members can read prayers" ON public.prayer_requests FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = prayer_requests.church_id)
);
CREATE POLICY "Users can create prayers" ON public.prayer_requests FOR INSERT TO authenticated WITH CHECK (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = prayer_requests.church_id)
);
CREATE POLICY "Users can update own prayers" ON public.prayer_requests FOR UPDATE TO authenticated USING (auth.uid() = user_id);

-- messages
CREATE POLICY "Church members can read messages" ON public.messages FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = messages.church_id)
);
CREATE POLICY "Users can send messages" ON public.messages FOR INSERT TO authenticated WITH CHECK (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = messages.church_id)
);

-- notifications
CREATE POLICY "Users can read own notifications" ON public.notifications FOR SELECT TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Users can update own notifications" ON public.notifications FOR UPDATE TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Admins can create notifications" ON public.notifications FOR INSERT TO authenticated WITH CHECK (true);

-- ministries
CREATE POLICY "Church members can read ministries" ON public.ministries FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = ministries.church_id)
);
CREATE POLICY "Admins can manage ministries" ON public.ministries FOR ALL TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin' AND church_id = ministries.church_id)
);

-- ministry_missions
CREATE POLICY "Church members can read missions" ON public.ministry_missions FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.ministries m JOIN public.user_roles ur ON ur.church_id = m.church_id WHERE m.id = ministry_missions.ministry_id AND ur.user_id = auth.uid())
);
CREATE POLICY "Admins can manage missions" ON public.ministry_missions FOR ALL TO authenticated USING (
  EXISTS (SELECT 1 FROM public.ministries m JOIN public.user_roles ur ON ur.church_id = m.church_id WHERE m.id = ministry_missions.ministry_id AND ur.user_id = auth.uid() AND ur.role = 'admin')
);

-- spiritual_resources
CREATE POLICY "Church members can read resources" ON public.spiritual_resources FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = spiritual_resources.church_id)
);
CREATE POLICY "Admins can manage resources" ON public.spiritual_resources FOR ALL TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role IN ('admin', 'operateur') AND church_id = spiritual_resources.church_id)
);

-- activity_logs
CREATE POLICY "Admins can read logs" ON public.activity_logs FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role = 'admin' AND church_id = activity_logs.church_id)
);
CREATE POLICY "System can insert logs" ON public.activity_logs FOR INSERT TO authenticated WITH CHECK (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = activity_logs.church_id)
);

-- 20. Storage bucket
INSERT INTO storage.buckets (id, name, public) VALUES ('church-assets', 'church-assets', true);

CREATE POLICY "Authenticated users can upload" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'church-assets');
CREATE POLICY "Anyone can read church assets" ON storage.objects FOR SELECT USING (bucket_id = 'church-assets');
CREATE POLICY "Authenticated users can delete own" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'church-assets');

-- 21. Enable realtime for messages
ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;
