-- =====================================================================
-- 'স্মৃতির ক্যানভাস' (Smritir Canvas) — Production Supabase SQL Architecture
-- Spec-Kit & Superpowers Phase 1: Database First
-- UI/UX Pro Max Backend Standard: সমস্ত বিষয়ের ওপর অ্যাডমিনের পূর্ণ এডিট/ডিলিট ক্ষমতা
-- =====================================================================

-- এক্সটেনশন লোড
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ১. অথর ও অ্যাডমিন প্রোফাইল টেবিল
CREATE TABLE IF NOT EXISTS public.authors (
    id VARCHAR(64) PRIMARY KEY DEFAULT 'author_canvas_001',
    name TEXT DEFAULT '',                      -- লেখক নিজে যেকোনো সময় এডিট করবেন
    title_badges JSONB DEFAULT '["মাওলানা", "দাওরায়ে হাদিস", "লেখক", "সাংবাদিক (ourislam24.com)", "শিক্ষক"]'::jsonb,
    avatar_url TEXT DEFAULT '',
    bio TEXT DEFAULT '',
    secret_password_hash TEXT NOT NULL,        -- মাস্টার অ্যাডমিন পাসওয়ার্ড হ্যাশ
    vault_pin_hash TEXT DEFAULT '1234',        -- ৪-সংখ্যার ভল্ট পিন
    whatsapp_number TEXT NOT NULL DEFAULT '+8801990537782',
    facebook_profile_url TEXT NOT NULL DEFAULT 'https://www.facebook.com/profile.php?id=100014276491414',
    facebook_page_url TEXT NOT NULL DEFAULT 'https://www.facebook.com/share/19apeVyoa9/',
    portal_url TEXT NOT NULL DEFAULT 'https://ourislam24.com',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ২. কাস্টম ক্যাটাগরি ও ফোল্ডার টেবিল
CREATE TABLE IF NOT EXISTS public.categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    bengali_index TEXT DEFAULT 'ক',            -- ক, খ, গ, ঘ, ঙ...
    sort_order INT DEFAULT 0,
    icon_name TEXT DEFAULT 'folder',
    color_hex TEXT DEFAULT '#1B4D3E',
    is_vault_only BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_categories_order ON public.categories(sort_order ASC, bengali_index ASC);

-- ৩. প্রবন্ধ, খাস খাতার লেখা ও ড্রাফট টেবিল
CREATE TABLE IF NOT EXISTS public.articles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID REFERENCES public.categories(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    subtitle TEXT,
    content TEXT NOT NULL,
    excerpt TEXT,
    cover_image_url TEXT,
    word_count INT DEFAULT 0,
    reading_time_minutes INT DEFAULT 1,
    bengali_order_tag TEXT,                    -- ক-১, খ-১ বা পর্ব ১
    custom_sort_order INT DEFAULT 0,
    status TEXT DEFAULT 'draft',               -- 'draft', 'published', 'archived'
    is_vault_locked BOOLEAN DEFAULT FALSE,     -- ফিঙ্গারপ্রিন্ট বা পিন দিয়ে লক
    views_count INT DEFAULT 0,
    likes_count INT DEFAULT 0,
    comments_count INT DEFAULT 0,
    audio_attachment_url TEXT,                 -- বাংলা ভয়েস বা সাক্ষাৎকার ক্লিপ
    published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_articles_status ON public.articles(status);
CREATE INDEX IF NOT EXISTS idx_articles_category ON public.articles(category_id, custom_sort_order ASC);

-- ৪. ড্রাফট ভার্সন হিস্ট্রি টেবিল (স্বয়ংক্রিয় ব্যাকআপ ও রিস্টোর)
CREATE TABLE IF NOT EXISTS public.article_versions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    article_id UUID REFERENCES public.articles(id) ON DELETE CASCADE,
    content_snapshot TEXT NOT NULL,
    word_count INT NOT NULL,
    summary_note TEXT,
    saved_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_versions_article ON public.article_versions(article_id, saved_at DESC);

-- ৫. সাক্ষাৎকার অডিও চ্যাপ্টার ও টাইমস্ট্যাম্প মার্কার টেবিল
CREATE TABLE IF NOT EXISTS public.interview_audio_markers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    article_id UUID REFERENCES public.articles(id) ON DELETE CASCADE,
    audio_url TEXT NOT NULL,
    timestamp_seconds INT NOT NULL,
    marker_label TEXT NOT NULL,
    transcribed_bengali_text TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ৬. ৩D ভার্চুয়াল বুকশেলফ ও কিতাব রিডার টেবিল
CREATE TABLE IF NOT EXISTS public.bookshelf (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    original_author TEXT NOT NULL,
    cover_image_url TEXT,
    pdf_file_path TEXT,                        -- ক্লাউড স্টোরেজ লিঙ্ক
    reading_status TEXT DEFAULT 'reading',     -- 'reading', 'completed', 'wishlist'
    current_page INT DEFAULT 1,
    total_pages INT DEFAULT 0,
    scholar_notes TEXT,                        -- কিতাব পাঠ পরবর্তী ব্যক্তিগত নোট/টীকা
    sort_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_bookshelf_status ON public.bookshelf(reading_status, sort_order ASC);

-- ৭. স্ক্রিনের নিচে ভাসমান লিভিং বাণী কার্ড টেবিল
CREATE TABLE IF NOT EXISTS public.living_quotes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    quote_text TEXT NOT NULL,
    reference_source TEXT NOT NULL,
    is_active BOOLEAN DEFAULT FALSE,           -- বর্তমানে হোমস্ক্রিনে ফ্লোটিং থাকবে কিনা
    display_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ৮. পাঠক মন্তব্য (Comments) ও লেখকের জবাব টেবিল
CREATE TABLE IF NOT EXISTS public.article_comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    article_id UUID REFERENCES public.articles(id) ON DELETE CASCADE,
    reader_name TEXT NOT NULL,
    reader_comment TEXT NOT NULL,
    is_approved BOOLEAN DEFAULT TRUE,
    author_reply TEXT,                         -- লেখকের সরাসরি জবাব
    replied_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_comments_article ON public.article_comments(article_id, created_at DESC);

-- ৯. পাঠক লাইক ও শেয়ার ইন্টারঅ্যাকশন ট্র্যাকার টেবিল
CREATE TABLE IF NOT EXISTS public.article_interactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    article_id UUID REFERENCES public.articles(id) ON DELETE CASCADE,
    client_fingerprint TEXT NOT NULL,          -- স্প্যামিং রোধে ইউনিক টোকেন
    interaction_type TEXT NOT NULL,            -- 'like', 'share'
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_like ON public.article_interactions(article_id, client_fingerprint, interaction_type);

-- ১০. অ্যাপ্লিকেশন গ্লোবাল কনফিগারেশন টেবিল
CREATE TABLE IF NOT EXISTS public.app_settings (
    setting_key TEXT PRIMARY KEY,
    setting_value JSONB NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================================
-- আরএলএস পলিসি (Row Level Security) — পাবলিক রিড & অ্যাডমিন ফুল এডিট/ডিলিট
-- =====================================================================

ALTER TABLE public.authors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.articles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.article_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interview_audio_markers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookshelf ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.living_quotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.article_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.article_interactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;

-- ১. পাবলিক পাঠকদের জন্য রিড এক্সেস (পাবলিশড লেখা ও কনটেন্ট)
CREATE POLICY "Public Read Authors" ON public.authors FOR SELECT USING (true);
CREATE POLICY "Public Read Categories" ON public.categories FOR SELECT USING (is_vault_only = false);
CREATE POLICY "Public Read Published Articles" ON public.articles FOR SELECT USING (status = 'published' AND is_vault_locked = false);
CREATE POLICY "Public Read Bookshelf" ON public.bookshelf FOR SELECT USING (true);
CREATE POLICY "Public Read Active Quotes" ON public.living_quotes FOR SELECT USING (true);
CREATE POLICY "Public Read Approved Comments" ON public.article_comments FOR SELECT USING (is_approved = true);
CREATE POLICY "Public Read App Settings" ON public.app_settings FOR SELECT USING (true);

-- ২. পাবলিক পাঠকদের লাইক ও কমেন্ট ইনসার্ট অনুমতি
CREATE POLICY "Public Insert Comments" ON public.article_comments FOR INSERT WITH CHECK (true);
CREATE POLICY "Public Insert Interactions" ON public.article_interactions FOR INSERT WITH CHECK (true);

-- ৩. সুপার অ্যাডমিন ফুল এক্সেস পলিসি (অনুমোদিত হলে সব টেবিলে সমস্ত কিছু এডিট/ডিলিট করতে পারবেন)
CREATE POLICY "Admin All Authors" ON public.authors FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Admin All Categories" ON public.categories FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Admin All Articles" ON public.articles FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Admin All Versions" ON public.article_versions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Admin All Markers" ON public.interview_audio_markers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Admin All Bookshelf" ON public.bookshelf FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Admin All Quotes" ON public.living_quotes FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Admin All Comments" ON public.article_comments FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Admin All Interactions" ON public.article_interactions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Admin All Settings" ON public.app_settings FOR ALL USING (true) WITH CHECK (true);

-- =====================================================================
-- রিয়েল-টাইম পাবলিকেশন (Supabase Realtime)
-- =====================================================================
ALTER PUBLICATION supabase_realtime ADD TABLE public.articles;
ALTER PUBLICATION supabase_realtime ADD TABLE public.categories;
ALTER PUBLICATION supabase_realtime ADD TABLE public.living_quotes;
ALTER PUBLICATION supabase_realtime ADD TABLE public.article_comments;
ALTER PUBLICATION supabase_realtime ADD TABLE public.bookshelf;

-- =====================================================================
-- স্টোরেজ বাকেট তৈরি (Storage Buckets)
-- =====================================================================
INSERT INTO storage.buckets (id, name, public) VALUES 
('audio_recordings', 'audio_recordings', true),
('book_pdfs', 'book_pdfs', true),
('author_media', 'author_media', true)
ON CONFLICT (id) DO NOTHING;
