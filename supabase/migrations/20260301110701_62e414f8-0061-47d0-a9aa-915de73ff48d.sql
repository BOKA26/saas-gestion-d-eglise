
-- Add missing columns to churches
ALTER TABLE public.churches ADD COLUMN IF NOT EXISTS contact TEXT;
ALTER TABLE public.churches ADD COLUMN IF NOT EXISTS facebook TEXT;
ALTER TABLE public.churches ADD COLUMN IF NOT EXISTS whatsapp TEXT;
ALTER TABLE public.churches ADD COLUMN IF NOT EXISTS verset_clef TEXT;
ALTER TABLE public.churches ADD COLUMN IF NOT EXISTS couverture_url TEXT;

-- Add missing columns to members
ALTER TABLE public.members ADD COLUMN IF NOT EXISTS sexe TEXT;
ALTER TABLE public.members ADD COLUMN IF NOT EXISTS groupe_departement TEXT;

-- Add missing columns to messages
ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS subject TEXT;
ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS content TEXT;
ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS recipient_type TEXT DEFAULT 'all';
ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS read BOOLEAN DEFAULT false;
ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS recipient_role public.app_role;

-- Add missing columns to notifications (keep French columns, add English aliases)
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS title TEXT;
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS content TEXT;
ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS read BOOLEAN DEFAULT false;

-- Add missing columns to donations
ALTER TABLE public.donations ADD COLUMN IF NOT EXISTS type_don TEXT;

-- Add missing columns to prayer_requests
ALTER TABLE public.prayer_requests ADD COLUMN IF NOT EXISTS texte TEXT;
ALTER TABLE public.prayer_requests ADD COLUMN IF NOT EXISTS membre_id UUID REFERENCES public.members(id) ON DELETE SET NULL;
ALTER TABLE public.prayer_requests ADD COLUMN IF NOT EXISTS date_demande TIMESTAMPTZ DEFAULT now();
ALTER TABLE public.prayer_requests ADD COLUMN IF NOT EXISTS reponse TEXT;
ALTER TABLE public.prayer_requests ADD COLUMN IF NOT EXISTS answered_at TIMESTAMPTZ;

-- Create kb_documents table
CREATE TABLE IF NOT EXISTS public.kb_documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  church_id UUID REFERENCES public.churches(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  content TEXT,
  source_type TEXT DEFAULT 'text',
  chunk_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Create kb_faq table
CREATE TABLE IF NOT EXISTS public.kb_faq (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  church_id UUID REFERENCES public.churches(id) ON DELETE CASCADE NOT NULL,
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Enable RLS on new tables
ALTER TABLE public.kb_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kb_faq ENABLE ROW LEVEL SECURITY;

-- RLS for kb_documents
CREATE POLICY "Church members can read kb_documents" ON public.kb_documents FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = kb_documents.church_id)
);
CREATE POLICY "Admins can manage kb_documents" ON public.kb_documents FOR ALL TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role IN ('admin', 'operateur') AND church_id = kb_documents.church_id)
);

-- RLS for kb_faq
CREATE POLICY "Church members can read kb_faq" ON public.kb_faq FOR SELECT TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND church_id = kb_faq.church_id)
);
CREATE POLICY "Admins can manage kb_faq" ON public.kb_faq FOR ALL TO authenticated USING (
  EXISTS (SELECT 1 FROM public.user_roles WHERE user_id = auth.uid() AND role IN ('admin', 'operateur') AND church_id = kb_faq.church_id)
);

-- Triggers for new tables
CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.kb_documents FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.kb_faq FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();
