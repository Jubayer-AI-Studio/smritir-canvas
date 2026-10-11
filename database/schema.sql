-- =====================================================================
-- 'মেশক' (Meshk) — All-in-One Live Magazine, Kitab Bookshelf & Super Admin
-- Database Schema (PostgreSQL & SQLite Compatible DDL)
-- Spec-Kit & Superpowers Phase 1: Database First
-- =====================================================================

-- ১. অথর ও সুপার অ্যাডমিন প্রোফাইল
CREATE TABLE IF NOT EXISTS authors (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    title_badges TEXT NOT NULL, -- JSON String: ["মাওলানা", "লেখক", "সাংবাদিক (ourislam24.com)", "শিক্ষক"]
    avatar_url TEXT,
    bio TEXT,
    secret_password_hash VARCHAR(255) NOT NULL, -- সিক্রেট অ্যাডমিন পাসওয়ার্ড হ্যাশ
    vault_pin_hash VARCHAR(255),               -- সংবেদনশীল খাস খাতার পিন
    whatsapp_number VARCHAR(32) NOT NULL,       -- +8801990537782
    facebook_profile_url TEXT NOT NULL,         -- https://www.facebook.com/profile.php?id=100014276491414
    facebook_page_url TEXT NOT NULL,            -- https://www.facebook.com/share/19apeVyoa9/
    portal_url TEXT NOT NULL,                   -- https://ourislam24.com
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ২. কাস্টম ক্যাটাগরি ও ফোল্ডার বিল্ডার
CREATE TABLE IF NOT EXISTS categories (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    bengali_index VARCHAR(16) DEFAULT 'ক',       -- ক, খ, গ, ঘ... ইত্যাদি বর্ণানুক্রম
    sort_order INT DEFAULT 0,                   -- ড্র্যাগ-অ্যান্ড-ড্রপ পজিশনিং ক্রম
    icon_name VARCHAR(64) DEFAULT 'folder',
    color_hex VARCHAR(16) DEFAULT '#1B4D3E',    -- ডিপ এমারেল্ড অ্যাকসেন্ট
    is_vault_only BOOLEAN DEFAULT 0,            -- শুধু প্রাইভেট ভল্টেই থাকবে কিনা
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_categories_sort ON categories(sort_order, bengali_index);

-- ৩. ম্যাগাজিন লেখা ও খাস খাতা ড্রাফট
CREATE TABLE IF NOT EXISTS articles (
    id VARCHAR(64) PRIMARY KEY,
    category_id VARCHAR(64) NOT NULL,
    title TEXT NOT NULL,
    subtitle TEXT,
    content TEXT NOT NULL,                      -- মূল বডি (Rich Text / Markdown)
    excerpt TEXT,                               -- হোমস্ক্রিনের জন্য সারসংক্ষেপ
    cover_image_url TEXT,
    word_count INT DEFAULT 0,                   -- রিয়েল-টাইম শব্দ গণনা
    reading_time_minutes INT DEFAULT 1,         -- আনুমানিক পড়ার সময় (মিনিট)
    bengali_order_tag VARCHAR(32),              -- ক-১, খ-২ বা পর্ব ১, ২
    custom_sort_order INT DEFAULT 0,
    status VARCHAR(32) DEFAULT 'draft',         -- 'draft', 'published', 'archived'
    is_vault_locked BOOLEAN DEFAULT 0,          -- বায়োমেট্রিক বা পিন দিয়ে লক করা
    views_count INT DEFAULT 0,
    likes_count INT DEFAULT 0,
    comments_count INT DEFAULT 0,
    audio_attachment_url TEXT,                  -- ভয়েস নোট বা ইন্টারভিউ রেকর্ডিং লিঙ্ক
    published_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_articles_status ON articles(status);
CREATE INDEX IF NOT EXISTS idx_articles_sort ON articles(category_id, custom_sort_order);

-- ৪. ড্রাফট ভার্সন হিস্ট্রি (অটোসেভ ও রিস্টোর)
CREATE TABLE IF NOT EXISTS article_versions (
    id VARCHAR(64) PRIMARY KEY,
    article_id VARCHAR(64) NOT NULL,
    content_snapshot TEXT NOT NULL,
    word_count INT NOT NULL,
    summary_note VARCHAR(255),                  -- যেমন: "স্বয়ংক্রিয় সেভ", "প্রথম খসড়া"
    saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_versions_article ON article_versions(article_id, saved_at DESC);

-- ৫. ফিল্ড ইন্টারভিউ অডিও ও চ্যাপ্টার মার্কার
CREATE TABLE IF NOT EXISTS interview_audio_markers (
    id VARCHAR(64) PRIMARY KEY,
    article_id VARCHAR(64) NOT NULL,
    audio_url TEXT NOT NULL,
    timestamp_seconds INT NOT NULL,             -- অডিওর যে সেকেন্ডে মার্কার রাখা হয়েছে
    marker_label VARCHAR(255) NOT NULL,         -- যেমন: "গুরুত্বপূর্ণ বক্তব্য", "প্রশ্ন ১"
    transcribed_bengali_text TEXT,              -- বাংলা ভয়েস-টু-টেক্সট ট্রান্সক্রিপ্ট
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
);

-- ৬. ৩D ভার্চুয়াল বুকশেলফ ও কিতাব রিডার
CREATE TABLE IF NOT EXISTS bookshelf (
    id VARCHAR(64) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    original_author VARCHAR(255) NOT NULL,
    cover_image_url TEXT,
    pdf_file_path TEXT,
    reading_status VARCHAR(32) DEFAULT 'reading', -- 'reading', 'completed', 'wishlist'
    current_page INT DEFAULT 1,
    total_pages INT DEFAULT 0,
    scholar_notes TEXT,                         -- কিতাব পাঠ পরবর্তী ব্যক্তিগত ভাবনা/নোট
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_bookshelf_status ON bookshelf(reading_status, sort_order);

-- ৭. স্ক্রিনের নিচে ভাসমান লিভিং বাণী কার্ড (Living Quotes)
CREATE TABLE IF NOT EXISTS living_quotes (
    id VARCHAR(64) PRIMARY KEY,
    quote_text TEXT NOT NULL,
    reference_source VARCHAR(255) NOT NULL,     -- যেমন: "বুখারি শরীফ", "লেখক"
    is_active BOOLEAN DEFAULT 0,                -- হোমস্ক্রিনে ফ্লোট করবে কিনা
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ৮. পাবলিক পাঠক মন্তব্য (Comments) ও লেখকের জবাব
CREATE TABLE IF NOT EXISTS article_comments (
    id VARCHAR(64) PRIMARY KEY,
    article_id VARCHAR(64) NOT NULL,
    reader_name VARCHAR(128) NOT NULL,
    reader_comment TEXT NOT NULL,
    is_approved BOOLEAN DEFAULT 1,              -- পাবলিক ডিসপ্লে মডারেশন
    author_reply TEXT,                          -- লেখকের সরাসরি প্রতিউত্তর
    replied_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_comments_article ON article_comments(article_id, created_at DESC);

-- ৯. পাবলিক লাইক ও শেয়ার ট্র্যাকার
CREATE TABLE IF NOT EXISTS article_interactions (
    id VARCHAR(64) PRIMARY KEY,
    article_id VARCHAR(64) NOT NULL,
    client_fingerprint VARCHAR(128) NOT NULL,   -- স্প্যামিং রোধে ইউনিক ক্লায়েন্ট টোকেন
    interaction_type VARCHAR(32) NOT NULL,      -- 'like', 'share'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_like ON article_interactions(article_id, client_fingerprint, interaction_type);

-- ১০. অ্যাপ্লিকেশন গ্লোবাল কনফিগারেশন ও নামাজের ওয়াক্ত নিয়ম
CREATE TABLE IF NOT EXISTS app_settings (
    setting_key VARCHAR(64) PRIMARY KEY,
    setting_value TEXT NOT NULL,                -- JSON Payload
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
