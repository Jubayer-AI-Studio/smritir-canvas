-- =====================================================================
-- 'স্মৃতির ক্যানভাস' (Smritir Canvas) — Database Schema
-- Architecture: Database First (Zero Dummy Content Enforced)
-- Features: Author Full Identity, Dynamic Bookshelf, Custom PIN, Folders/Categories
-- =====================================================================

-- ১. অথর ও লেখক প্রোফাইল
CREATE TABLE IF NOT EXISTS authors (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    designation VARCHAR(255),                    -- যেমন: "লেখক, গবেষক ও শিক্ষক"
    organization VARCHAR(255),                   -- যেমন: "ourislam24.com"
    full_bio TEXT,                               -- বিস্তারিত আত্মপরিচয় ও ভাবনার জগত
    personal_quote TEXT,                         -- জীবনের মূলমন্ত্র বা প্রিয় বাণী
    studio_pin VARCHAR(32) DEFAULT '1234',       -- অ্যাডমিন স্টুডিওর কাস্টম সিকিউরিটি পিন
    avatar_url TEXT,
    whatsapp_number VARCHAR(32),                 -- +8801990537782
    facebook_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ২. কাস্টম ক্যাটাগরি ও ফোল্ডার বিল্ডার (অ্যাডমিন থেকে সম্পূর্ণ কন্ট্রোলযোগ্য)
CREATE TABLE IF NOT EXISTS categories (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    bengali_index VARCHAR(16) DEFAULT 'ক',
    icon_name VARCHAR(64) DEFAULT 'folder',
    description TEXT,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_categories_sort ON categories(sort_order);

-- ৩. ম্যাগাজিন লেখা ও নিবন্ধ
CREATE TABLE IF NOT EXISTS articles (
    id VARCHAR(64) PRIMARY KEY,
    category_id VARCHAR(64) NOT NULL,
    title TEXT NOT NULL,
    subtitle TEXT,
    content TEXT NOT NULL,
    excerpt TEXT,
    word_count INT DEFAULT 0,
    reading_time_minutes INT DEFAULT 1,
    status VARCHAR(32) DEFAULT 'published',
    views_count INT DEFAULT 0,
    likes_count INT DEFAULT 0,
    published_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_articles_status ON articles(status);
CREATE INDEX IF NOT EXISTS idx_articles_cat ON articles(category_id);

-- ৪. কিতাব তাক ও বুকশেলফ ট্র্যাকার (রেটিং, নোট, প্রায়োরিটি ও স্ট্যাটাসসহ)
CREATE TABLE IF NOT EXISTS bookshelf (
    id VARCHAR(64) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    writer VARCHAR(255) NOT NULL,
    category_name VARCHAR(128) DEFAULT 'সাধারণ',
    reading_status VARCHAR(32) DEFAULT 'reading', -- 'completed' (পড়া শেষ), 'reading' (এখন পড়ছি), 'planned' (আগামীতে পড়ব)
    priority VARCHAR(32) DEFAULT 'normal',       -- 'high' (অত্যন্ত জরুরি), 'normal' (সাধারণ), 'low' (পরে হলেও চলবে)
    rating INT DEFAULT 5,                        -- ১ থেকে ৫ স্টার রেটিং
    scholar_notes TEXT,                         -- কিতাব সম্পর্কে লেখকের ব্যক্তিগত মন্তব্য বা নোট
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_bookshelf_status ON bookshelf(reading_status, priority);

-- ৫. অ্যাপ্লিকেশন সেটিংস ও কনফিগ
CREATE TABLE IF NOT EXISTS app_settings (
    setting_key VARCHAR(64) PRIMARY KEY,
    setting_value TEXT NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
