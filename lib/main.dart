// =====================================================================
// 'স্মৃতির ক্যানভাস' (Smritir Canvas) — Production App Entrypoint
// Hollywood Cinematic Animated Splash (% Counter), Multi-Mode & English Date
// =====================================================================

import 'package:flutter/material.dart';
import 'models/models.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/bookshelf_screen.dart';
import 'screens/khas_khata_studio_screen.dart';
import 'screens/public_reader_screen.dart';
import 'services/auth_service.dart';
import 'services/localization_service.dart';
import 'theme/canvas_theme.dart';
import 'widgets/hollywood_cinematic_splash.dart';
import 'widgets/live_glass_header.dart';
import 'widgets/living_quote_card.dart';
import 'widgets/royal_author_card.dart';

void main() {
  runApp(const SmritirCanvasApp());
}

class SmritirCanvasApp extends StatefulWidget {
  const SmritirCanvasApp({Key? key}) : super(key: key);

  @override
  State<SmritirCanvasApp> createState() => _SmritirCanvasAppState();
}

class _SmritirCanvasAppState extends State<SmritirCanvasApp> {
  AppThemeMode _currentMode = AppThemeMode.emerald;
  AppLanguage _currentLang = AppLanguage.bn;
  bool _isLoaded = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'স্মৃতির ক্যানভাস (Smritir Canvas)',
      debugShowCheckedModeBanner: false,
      theme: CanvasTheme.getTheme(_currentMode),
      home: !_isLoaded
          // ১. হলিউড সিনেমাটিক লাইভ % লোডার স্ক্রিন
          ? HollywoodCinematicSplash(
              onLoaded: () {
                setState(() => _isLoaded = true);
              },
            )
          // ২. মূল অ্যাপ্লিকেশন স্ক্রিন
          : MainHomeScreen(
              currentMode: _currentMode,
              currentLang: _currentLang,
              onThemeModeChanged: (mode) => setState(() => _currentMode = mode),
              onLanguageChanged: (lang) => setState(() => _currentLang = lang),
            ),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  final AppThemeMode currentMode;
  final AppLanguage currentLang;
  final Function(AppThemeMode) onThemeModeChanged;
  final Function(AppLanguage) onLanguageChanged;

  const MainHomeScreen({
    Key? key,
    required this.currentMode,
    required this.currentLang,
    required this.onThemeModeChanged,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentTabIndex = 0;
  bool _isAdminMode = false;

  late AuthorProfile _author;
  late List<CategoryItem> _categories;
  late List<ArticleItem> _articles;
  late List<BookItem> _books;
  late List<LivingQuote> _quotes;

  @override
  void initState() {
    super.initState();
    _loadAuthenticState();
  }

  void _loadAuthenticState() {
    _author = AuthorProfile(
      id: 'author_canvas_001',
      name: '', // খালি রাখা হয়েছে — লেখক নিজে অ্যাপ থেকে লিখবেন
      titleBadges: ['মাওলানা', 'দাওরায়ে হাদিস', 'লেখক', 'সাংবাদিক (ourislam24.com)', 'শিক্ষক'],
      bio: 'ইসলামিক স্কলার, শিক্ষক, সাংবাদিক ও চিন্তাশীল লেখক।',
      secretPasswordHash: 'meshk_admin_secret_2026',
      vaultPinHash: '1234',
      whatsappNumber: '+8801990537782',
      facebookProfileUrl: 'https://www.facebook.com/profile.php?id=100014276491414',
      facebookPageUrl: 'https://www.facebook.com/share/19apeVyoa9/',
      portalUrl: 'https://ourislam24.com',
    );

    _categories = [
      CategoryItem(id: 'cat_01', name: 'জুমা ও সীরাতের পাঠ', slug: 'juma-o-seerat', bengaliIndex: 'ক', sortOrder: 1),
      CategoryItem(id: 'cat_02', name: 'কিতাব পাঠ পরবর্তী ভাবনা', slug: 'kitab-path-vabna', bengaliIndex: 'খ', sortOrder: 2),
      CategoryItem(id: 'cat_03', name: 'ফিল্ড ডায়রি ও ভ্রমণ কথা', slug: 'field-diary-vromon', bengaliIndex: 'গ', sortOrder: 3),
      CategoryItem(id: 'cat_04', name: 'তাহকিক ও মনীষী সান্নিধ্য', slug: 'tahqiq-monishi', bengaliIndex: 'ঘ', sortOrder: 4),
      CategoryItem(id: 'cat_05', name: 'সমকালীন গ্রন্থালোচনা ও রাজনীতি', slug: 'somokalin-grantha', bengaliIndex: 'ঙ', sortOrder: 5),
    ];

    _articles = [
      ArticleItem(
        id: 'art_01',
        categoryId: 'cat_01',
        title: 'জুমার খুতবা ও সীরাতের পাঠ: পারস্য সম্রাটের বালা ও সাহাবায়ে কেরামের মর্যাদা',
        subtitle: 'বায়তুল মোকাররম ও সচিবালয় এলাকার জুমার স্মৃতি ও খুতবার সারাংশ',
        content: 'সাড়ে এগারোটায় মসজিদের ৪ ভাগের ৩ ভাগ মুসল্লীতে ভরপুর। শান্ত পরিবেশে নামাজ শেষ করেই চলে এলাম।\n\nএমনিতে শুক্রবারে সচিবালয়-পল্টন-বায়তুল মোকাররমে কয়েকশত পুলিশ মোতায়েন করা থাকে। আজ তাদেরকে একটু বেশি সতর্ক মনে হলো। অন্যদিন একপাশে সারিবদ্ধভাবে দাঁড়িয়ে থাকেন। আজ তারা গেটের কাছে এসে দুপাশে সারি সারি হয়ে দাঁড়িয়ে ছিলেন...',
        excerpt: 'সাড়ে এগারোটায় মসজিদের ৪ ভাগের ৩ ভাগ মুসল্লীতে ভরপুর। শান্ত পরিবেশে নামাজ শেষ করেই চলে এলাম...',
        wordCount: 238,
        readingTimeMinutes: 2,
        bengaliOrderTag: 'ক-১',
        customSortOrder: 1,
        status: 'published',
        likesCount: 154,
        commentsCount: 5,
        createdAt: DateTime.now(),
      ),
      ArticleItem(
        id: 'art_02',
        categoryId: 'cat_02',
        title: 'দারুল উলুম দেওবন্দের ইতিহাস পাঠ: ৮০০ পৃষ্ঠার এক অনবদ্য সফর',
        subtitle: 'ড. মুহাম্মদুল্লাহ কাসেমীর জামে ওয়া মুখতাসার তারিখ পাঠ পরবর্তী ভাবনা',
        content: 'দারুল উলুম দেওবন্দের ইতিহাস ও অবদান নিয়ে আমার আগ্রহ অনেক আগে থেকে। উপমহাদেশের ইসলামচর্চা থেকে শুরু করে শিক্ষা-সংস্কৃতি, রাজনীতি সবকিছুতেই অগ্রণী ভুমিকা পালন করেছেন এ পাঠশালার সূর্য-সন্তানেরা...',
        excerpt: 'দারুল উলুম দেওবন্দের ইতিহাস ও অবদান নিয়ে আমার আগ্রহ অনেক আগে থেকে...',
        wordCount: 168,
        readingTimeMinutes: 2,
        bengaliOrderTag: 'খ-১',
        customSortOrder: 2,
        status: 'published',
        likesCount: 189,
        commentsCount: 7,
        createdAt: DateTime.now(),
      ),
      ArticleItem(
        id: 'art_03',
        categoryId: 'cat_03',
        title: 'বৃষ্টিভেজা রাতে সিলেট মহাসড়ক: টু-ওয়ে সড়ক ও মৃত্যুঝুঁকির স্মৃতি',
        subtitle: 'ড্রাইভারের পাশে ইঞ্জিন কভারে বসে কাটানো একটি ভ্রমণ রাতের অভিজ্ঞতা',
        content: 'সিলেট ভ্রমণের সময় ওই অঞ্চলের রাস্তা দেখে আমিও অবাক হয়েছিলাম। দেশের এত গুরুত্বপূর্ণ সড়ক মাত্র ‘টু ওয়ে’র...',
        excerpt: 'সিলেট ভ্রমণের সময় ওই অঞ্চলের রাস্তা দেখে আমিও অবাক হয়েছিলাম...',
        wordCount: 95,
        readingTimeMinutes: 1,
        bengaliOrderTag: 'গ-১',
        customSortOrder: 3,
        status: 'published',
        likesCount: 142,
        commentsCount: 4,
        createdAt: DateTime.now(),
      ),
      ArticleItem(
        id: 'art_04',
        categoryId: 'cat_04',
        title: 'সুলহে হুদায়বিয়া: ইজতিহাদী নাকি ওহী? হযরত আব্দুল মালেক সাহেবের সান্নিধ্যে',
        subtitle: 'ফিকহ ও সিরাত গবেষণার একটি গভীর পর্যবেক্ষণ',
        content: 'তখন আব্দুল মালেক সাহেব বললেন, আমার সতর্কতার জন্য তো এতটুকুই যথেষ্ট। বাকি আরো দেখা যেতে পারে,,,,\n\n.\n\nকিন্তু হুজুরের কথা রক্ষার্থে যখন ঘাঁটাঘাঁটি শুরু করি তখন দেখি, সুলহে হুদাইবিয়া ইজতেহাদী না ওহী এই বিষয়ে পূর্ববর্তীদের অনেকেই আলোচনা করেছেন...',
        excerpt: 'তখন আব্দুল মালেক সাহেব বললেন, আমার সতর্কতার জন্য তো এতটুকুই যথেষ্ট...',
        wordCount: 47,
        readingTimeMinutes: 1,
        bengaliOrderTag: 'ঘ-১',
        customSortOrder: 4,
        status: 'published',
        likesCount: 210,
        commentsCount: 9,
        createdAt: DateTime.now(),
      ),
      ArticleItem(
        id: 'art_05',
        categoryId: 'cat_05',
        title: '\'জুলাই কেন আমাদের লড়াই?\' এবং আমাদের তরুণ প্রজন্মের পঠনধারা',
        subtitle: 'মাওলানা মামুনুল হক সাহেবের গ্রন্থের রিভিউ প্রতিযোগিতা ও আব্দুল্লাহর পাঠ',
        content: '\'জুলাই কেন আমাদের লড়াই?\' মাওলানা মামুনুল হক সাহেবের সদ্য প্রকাশিত একটি গ্রন্থনা...\n\nনিচের লেখাটি লিখেছে আবদুল্লাহ। রাজনীতি নিয়ে তার আগ্রহ আছে। এই পঠনধারা বজায় থাকুক। জানার পরিধি বাড়ুক। জাতির কল্যাণে এগিয়ে যাক সেই কামনায়,,,,',
        excerpt: '\'জুলাই কেন আমাদের লড়াই?\' মাওলানা মামুনুল হক সাহেবের সদ্য প্রকাশিত একটি গ্রন্থনা...',
        wordCount: 70,
        readingTimeMinutes: 1,
        bengaliOrderTag: 'ঙ-১',
        customSortOrder: 5,
        status: 'published',
        likesCount: 175,
        commentsCount: 6,
        createdAt: DateTime.now(),
      ),
    ];

    _books = [
      BookItem(
        id: 'book_01',
        title: 'দারুল উলুম দেওবন্দ কী জামে ওয়া মুখতাসার তারিখ',
        originalAuthor: 'ড. মাওলানা মুহাম্মদুল্লাহ কাসেমী (তত্ত্বাবধানে: মাওলানা বাহাউদ্দীন যাকারিয়া)',
        readingStatus: 'reading',
        currentPage: 400,
        totalPages: 850,
        scholarNotes: 'মুফতি হুমায়ুন আইয়ুব সাহেবের থেকে ধার করে আনা। নতুন অনেক বিষয় জানছি, কিছু ভুল ধারণা দূর হচ্ছে। বাকিটা শেষ করতে হাতে সময় দুই দিন।',
      ),
      BookItem(
        id: 'book_02',
        title: 'জুলাই কেন আমাদের লড়াই?',
        originalAuthor: 'মাওলানা মামুনুল হক',
        readingStatus: 'wishlist',
        currentPage: 0,
        totalPages: 250,
        scholarNotes: 'সমাজ-রাষ্ট্র-রাজনীতিকে গভীরভাবে উপলব্ধি করার গ্রন্থনা। পড়ার আগ্রহ রয়েছে।',
      ),
    ];

    _quotes = [
      LivingQuote(
        id: 'quote_01',
        quoteText: 'পৃথিবীর শ্রেষ্ঠ হাজার হাজার বুযুর্গের মর্যাদা একজন সাহাবীর সমান হবে না।',
        referenceSource: 'জুমার বয়ানের নির্যাস',
        isActive: true,
      ),
      LivingQuote(
        id: 'quote_02',
        quoteText: 'রাজনীতি নিয়ে তরুণদের পঠনধারা বজায় থাকুক। জানার পরিধি বাড়ুক। জাতির কল্যাণে এগিয়ে যাক।',
        referenceSource: 'স্মৃতির ক্যানভাস',
        isActive: false,
      ),
    ];
  }

  void _openSecretAdminDialog() {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CanvasColors.emeraldSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: CanvasColors.glassBorder),
          ),
          title: Row(
            children: const [
              Icon(Icons.shield_rounded, color: CanvasColors.goldPrimary, size: 22),
              SizedBox(width: 8),
              Text('সুপার অ্যাডমিন সিক্রেট কোড', style: TextStyle(fontFamily: 'Hind Siliguri', color: CanvasColors.goldLight, fontSize: 16)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'শুধুমাত্র লেখকের প্রবেশের জন্য। গোপন সিক্রেট পাসওয়ার্ডটি দিন:',
                style: TextStyle(fontFamily: 'Hind Siliguri', color: CanvasColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: CanvasColors.textIvory),
                decoration: InputDecoration(
                  hintText: 'সিক্রেট পাসওয়ার্ড...',
                  hintStyle: const TextStyle(color: CanvasColors.textSubtle),
                  filled: true,
                  fillColor: CanvasColors.emeraldBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: CanvasColors.glassBorder),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('বাতিল', style: TextStyle(color: CanvasColors.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CanvasColors.goldPrimary,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                if (AuthService.authenticateAdmin(passwordController.text)) {
                  setState(() => _isAdminMode = true);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('স্বাগতম! সুপার অ্যাডমিন স্টুডিও সক্রিয় হয়েছে।'),
                      backgroundColor: CanvasColors.emeraldDeep,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('❌ ভুল সিক্রেট পাসওয়ার্ড!'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: const Text('প্রবেশ করুন'),
            ),
          ],
        );
      },
    );
  }

  void _openWritingStudio() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KhasKhataStudioScreen(
          onSaveDraft: (newArticle) {
            setState(() {
              _articles.insert(0, newArticle);
            });
          },
        ),
      ),
    );
  }

  LivingQuote get _activeQuote {
    return _quotes.firstWhere((q) => q.isActive, orElse: () => _quotes.first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // ১. লাইভ ফ্রস্টেড গ্লাস হেডার (ইংরেজি তারিখ, ডিজিটাল ঘড়ি, থিম ও ল্যাঙ্গুয়েজ সুইচার)
              LiveGlassHeader(
                currentMode: widget.currentMode,
                currentLang: widget.currentLang,
                onThemeModeChanged: widget.onThemeModeChanged,
                onLanguageChanged: widget.onLanguageChanged,
              ),

              // ২. রয়্যাল অথর হিরো কার্ড (হোম স্ক্রিনে)
              if (_currentTabIndex == 0)
                RoyalAuthorCard(
                  author: _author,
                  onSecretAdminTap: _openSecretAdminDialog,
                  onUpdateAuthorName: (newName) {
                    setState(() {
                      _author = AuthorProfile(
                        id: _author.id,
                        name: newName,
                        titleBadges: _author.titleBadges,
                        avatarUrl: _author.avatarUrl,
                        bio: _author.bio,
                        secretPasswordHash: _author.secretPasswordHash,
                        vaultPinHash: _author.vaultPinHash,
                        whatsappNumber: _author.whatsappNumber,
                        facebookProfileUrl: _author.facebookProfileUrl,
                        facebookPageUrl: _author.facebookPageUrl,
                        portalUrl: _author.portalUrl,
                      );
                    });
                  },
                ),

              // ৩. মূল স্ক্রিন ভিউ (ম্যাগাজিন, বুকশেলফ, অ্যাডমিন)
              Expanded(
                child: _isAdminMode && _currentTabIndex == 2
                    ? AdminDashboardScreen(
                        articles: _articles,
                        categories: _categories,
                        quotes: _quotes,
                        books: _books,
                        author: _author,
                        onArticlesReordered: (newList) => setState(() => _articles = newList),
                        onAddCategory: (newCat) => setState(() => _categories.add(newCat)),
                        onUpdateArticle: (updatedArt) {
                          setState(() {
                            final idx = _articles.indexWhere((a) => a.id == updatedArt.id);
                            if (idx != -1) _articles[idx] = updatedArt;
                          });
                        },
                        onUpdateProfile: (newProf) => setState(() => _author = newProf),
                        onOpenWritingStudio: _openWritingStudio,
                      )
                    : (_currentTabIndex == 0
                        ? PublicReaderScreen(articles: _articles, categories: _categories)
                        : BookshelfScreen(books: _books)),
              ),
            ],
          ),

          // ৪. স্ক্রিনের নিচে ভাসমান লিভিং বাণী কার্ড (Shimmer Breathing Glow)
          Positioned(
            left: 0,
            right: 0,
            bottom: 60,
            child: LivingQuoteCard(
              quote: _activeQuote,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('বাণী: "${_activeQuote.quoteText}"'),
                    backgroundColor: CanvasColors.emeraldSurface,
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // বটম ন্যাভিগেশন বার
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: widget.currentMode == AppThemeMode.light 
              ? CanvasColors.lightSurface 
              : (widget.currentMode == AppThemeMode.sepia 
                  ? CanvasColors.sepiaSurface 
                  : (widget.currentMode == AppThemeMode.amoled 
                      ? Colors.black 
                      : CanvasColors.emeraldSurface)),
          border: const Border(top: BorderSide(color: CanvasColors.glassBorder, width: 0.8)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: CanvasColors.goldNeonGlow,
          unselectedItemColor: CanvasColors.textSubtle,
          onTap: (index) {
            if (index == 2 && !_isAdminMode) {
              _openSecretAdminDialog();
            } else {
              setState(() => _currentTabIndex = index);
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.auto_stories_outlined),
              activeIcon: const Icon(Icons.auto_stories),
              label: LocalizationService.tr('magazine_tab', widget.currentLang),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shelves),
              activeIcon: const Icon(Icons.book),
              label: LocalizationService.tr('bookshelf_tab', widget.currentLang),
            ),
            BottomNavigationBarItem(
              icon: Icon(_isAdminMode ? Icons.admin_panel_settings : Icons.lock_outline),
              label: _isAdminMode 
                  ? LocalizationService.tr('admin_tab', widget.currentLang) 
                  : LocalizationService.tr('vault_tab', widget.currentLang),
            ),
          ],
        ),
      ),
    );
  }
}
