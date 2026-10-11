// =====================================================================
// 'স্মৃতির ক্যানভাস' (Smritir Canvas) — Dual Language Localization Service
// Bengali (বাংলা - ডিফল্ট) & English (ইংরেজি)
// =====================================================================

enum AppLanguage { bn, en }

class LocalizationService {
  static const Map<String, Map<AppLanguage, String>> _strings = {
    'app_name': {
      AppLanguage.bn: 'স্মৃতির ক্যানভাস',
      AppLanguage.en: 'Smritir Canvas',
    },
    'magazine_tab': {
      AppLanguage.bn: 'লাইভ ম্যাগাজিন',
      AppLanguage.en: 'Live Magazine',
    },
    'bookshelf_tab': {
      AppLanguage.bn: 'কিতাব তাক',
      AppLanguage.en: 'Bookshelf',
    },
    'admin_tab': {
      AppLanguage.bn: 'অ্যাডমিন স্টুডিও',
      AppLanguage.en: 'Admin Studio',
    },
    'vault_tab': {
      AppLanguage.bn: 'সিক্রেট ভল্ট',
      AppLanguage.en: 'Secret Vault',
    },
    'next_prayer': {
      AppLanguage.bn: 'পরবর্তী ওয়াক্ত',
      AppLanguage.en: 'Next Prayer',
    },
    'remaining': {
      AppLanguage.bn: 'বাকি',
      AppLanguage.en: 'Remaining',
    },
    'reading_time': {
      AppLanguage.bn: 'মিনিট পাঠ',
      AppLanguage.en: 'min read',
    },
    'word_count': {
      AppLanguage.bn: 'শব্দ',
      AppLanguage.en: 'words',
    },
    'all_articles': {
      AppLanguage.bn: 'সব লেখা',
      AppLanguage.en: 'All Writings',
    },
    'comments': {
      AppLanguage.bn: 'মন্তব্য',
      AppLanguage.en: 'Comments',
    },
    'share': {
      AppLanguage.bn: 'শেয়ার',
      AppLanguage.en: 'Share',
    },
    'reading_status_reading': {
      AppLanguage.bn: 'পড়ছি',
      AppLanguage.en: 'Reading',
    },
    'reading_status_completed': {
      AppLanguage.bn: 'পড়া শেষ',
      AppLanguage.en: 'Completed',
    },
    'reading_status_wishlist': {
      AppLanguage.bn: 'পড়ার ইচ্ছা',
      AppLanguage.en: 'Wishlist',
    },
    'open_studio': {
      AppLanguage.bn: 'খাস খাতা স্টুডিও',
      AppLanguage.en: 'Khas Khata Studio',
    },
  };

  static String tr(String key, AppLanguage lang) {
    return _strings[key]?[lang] ?? key;
  }
}
