// =====================================================================
// 'স্মৃতির ক্যানভাস' (Smritir Canvas) — Super Admin Dashboard & Workspace
// Full-Screen Exclusive Studio, ক-খ-গ-ঘ Drag Sorting & All-Subject Edit Option
// =====================================================================

import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/admin_repository.dart';
import '../services/sorting_service.dart';
import '../theme/canvas_theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  final List<ArticleItem> articles;
  final List<CategoryItem> categories;
  final List<LivingQuote> quotes;
  final List<BookItem> books;
  final AuthorProfile author;
  final Function(List<ArticleItem>) onArticlesReordered;
  final Function(CategoryItem) onAddCategory;
  final Function(ArticleItem) onUpdateArticle;
  final Function(AuthorProfile) onUpdateProfile;
  final VoidCallback onOpenWritingStudio;

  const AdminDashboardScreen({
    Key? key,
    required this.articles,
    required this.categories,
    required this.quotes,
    required this.books,
    required this.author,
    required this.onArticlesReordered,
    required this.onAddCategory,
    required this.onUpdateArticle,
    required this.onUpdateProfile,
    required this.onOpenWritingStudio,
  }) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<ArticleItem> _editableArticles;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _editableArticles = List.from(widget.articles);
  }

  // যেকোনো আর্টিকেলের সব বিষয় (All Subject) এডিট করার মডাল
  void _editArticleModal(ArticleItem article) {
    final titleController = TextEditingController(text: article.title);
    final subtitleController = TextEditingController(text: article.subtitle ?? '');
    final contentController = TextEditingController(text: article.content);
    final tagController = TextEditingController(text: article.bengaliOrderTag ?? '');
    String selectedCatId = article.categoryId;
    String selectedStatus = article.status;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CanvasColors.surfaceEmerald,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
                left: 16,
                right: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'লেখার সমস্ত বিষয় এডিট করুন (All Subject Edit)',
                          style: TextStyle(
                            color: CanvasColors.goldLight,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: CanvasColors.textMuted),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(color: CanvasColors.glassBorder),
                    const SizedBox(height: 8),

                    // ক্যাটাগরি ড্রপডাউন
                    const Text('ক্যাটাগরি:', style: TextStyle(color: CanvasColors.textSubtle, fontSize: 12)),
                    DropdownButton<String>(
                      value: selectedCatId,
                      dropdownColor: CanvasColors.cardEmerald,
                      isExpanded: true,
                      style: const TextStyle(color: CanvasColors.textIvory),
                      items: widget.categories.map((c) {
                        return DropdownMenuItem<String>(
                          value: c.id,
                          child: Text('${c.bengaliIndex}. ${c.name}'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedCatId = val);
                      },
                    ),
                    const SizedBox(height: 10),

                    // শিরোনাম
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: CanvasColors.textIvory),
                      decoration: const InputDecoration(
                        labelText: 'শিরোনাম',
                        labelStyle: TextStyle(color: CanvasColors.goldLight),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: CanvasColors.glassBorder)),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // উপশিরোনাম
                    TextField(
                      controller: subtitleController,
                      style: const TextStyle(color: CanvasColors.textIvory),
                      decoration: const InputDecoration(
                        labelText: 'উপ-শিরোনাম (ঐচ্ছিক)',
                        labelStyle: TextStyle(color: CanvasColors.goldLight),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: CanvasColors.glassBorder)),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // কাস্টম বর্ণ / পর্ব ট্যাগ
                    TextField(
                      controller: tagController,
                      style: const TextStyle(color: CanvasColors.textIvory),
                      decoration: const InputDecoration(
                        labelText: 'কাস্টম ট্যাগ (যেমন: ক-১, পর্ব ১)',
                        labelStyle: TextStyle(color: CanvasColors.goldLight),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: CanvasColors.glassBorder)),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // মূল বিষয়বস্তু/বডি
                    TextField(
                      controller: contentController,
                      maxLines: 5,
                      style: const TextStyle(color: CanvasColors.textIvory),
                      decoration: const InputDecoration(
                        labelText: 'মূল বক্তব্য / লেখা',
                        labelStyle: TextStyle(color: CanvasColors.goldLight),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: CanvasColors.glassBorder)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // সেভ বাটন
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CanvasColors.goldPrimary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          final updated = AdminRepository.updateArticle(
                            article: article,
                            newCategoryId: selectedCatId,
                            newTitle: titleController.text.trim(),
                            newSubtitle: subtitleController.text.trim(),
                            newContent: contentController.text.trim(),
                            newBengaliOrderTag: tagController.text.trim(),
                            newStatus: selectedStatus,
                          );
                          widget.onUpdateArticle(updated);
                          setState(() {
                            final idx = _editableArticles.indexWhere((a) => a.id == article.id);
                            if (idx != -1) _editableArticles[idx] = updated;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✅ লেখার তথ্য সফলভাবে আপডেট হয়েছে!'),
                              backgroundColor: CanvasColors.deepGreenAccent,
                            ),
                          );
                        },
                        child: const Text('সংরক্ষণ করুন', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // নতুন ক্যাটাগরি ডায়লগ
  void _showNewCategoryDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CanvasColors.surfaceEmerald,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: CanvasColors.glassBorder),
          ),
          title: const Text('নতুন ক্যাটাগরি তৈরি', style: TextStyle(color: CanvasColors.goldLight)),
          content: TextField(
            controller: nameController,
            style: const TextStyle(color: CanvasColors.textIvory),
            decoration: const InputDecoration(
              hintText: 'ক্যাটাগরির নাম (যেমন: ফিল্ড ডায়রি)',
              hintStyle: TextStyle(color: CanvasColors.textSubtle),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: CanvasColors.glassBorder)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: CanvasColors.goldPrimary)),
            ),
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
                if (nameController.text.trim().isNotEmpty) {
                  final newIndex = SortingService.getBengaliTagForIndex(widget.categories.length);
                  final newCat = CategoryItem(
                    id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
                    name: nameController.text.trim(),
                    slug: nameController.text.trim().toLowerCase().replaceAll(' ', '-'),
                    bengaliIndex: newIndex,
                    sortOrder: widget.categories.length + 1,
                  );
                  widget.onAddCategory(newCat);
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: const Text('তৈরি করুন'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('সুপার অ্যাডমিন স্টুডিও'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: CanvasColors.goldPrimary,
          labelColor: CanvasColors.goldNeonGlow,
          unselectedLabelColor: CanvasColors.textMuted,
          tabs: const [
            Tab(icon: Icon(Icons.sort_by_alpha), text: 'ক-খ-গ সর্টিং'),
            Tab(icon: Icon(Icons.folder_open), text: 'ক্যাটাগরি'),
            Tab(icon: Icon(Icons.format_quote), text: 'বাণী নিয়ন্ত্রণ'),
            Tab(icon: Icon(Icons.person_outline), text: 'প্রোফাইল'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: CanvasColors.goldPrimary,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.edit_note_rounded),
        label: const Text('খাস খাতা স্টুডিও', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: widget.onOpenWritingStudio,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ট্যাব ১: ক-খ-গ-ঘ-ঙ ড্র্যাগ-অ্যান্ড-ড্রপ সর্টিং ও এডিট
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '💡 ড্র্যাগ করে উপরে-নিচে সাজান এবং ট্যাপ করে যেকোনো বিষয় এডিট করুন:',
                  style: TextStyle(color: CanvasColors.goldLight, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ReorderableListView.builder(
                    itemCount: _editableArticles.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        _editableArticles = SortingService.reorderArticles(_editableArticles, oldIndex, newIndex);
                        widget.onArticlesReordered(_editableArticles);
                      });
                    },
                    itemBuilder: (context, index) {
                      final article = _editableArticles[index];
                      return Container(
                        key: ValueKey(article.id),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: CanvasTheme.glassBoxDecoration(radius: 14),
                        child: Row(
                          children: [
                            // বাংলা বর্ণ ট্যাগ
                            Container(
                              width: 38,
                              height: 38,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: CanvasColors.deepGreenAccent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: CanvasColors.goldPrimary, width: 1),
                              ),
                              child: Text(
                                article.bengaliOrderTag ?? '${index + 1}',
                                style: const TextStyle(
                                  color: CanvasColors.goldNeonGlow,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // শিরোনাম ও মেটা
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.title,
                                    style: const TextStyle(
                                      color: CanvasColors.textIvory,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${article.wordCount} শব্দ • ${article.readingTimeMinutes} মি. পাঠ',
                                    style: const TextStyle(color: CanvasColors.textSubtle, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),

                            // এডিট বাটন
                            IconButton(
                              icon: const Icon(Icons.edit, color: CanvasColors.goldLight, size: 18),
                              tooltip: 'এডিট করুন',
                              onPressed: () => _editArticleModal(article),
                            ),

                            // ড্র্যাগ হ্যান্ডেল
                            const Icon(Icons.drag_indicator, color: CanvasColors.goldPrimary),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ট্যাব ২: ক্যাটাগরি বিল্ডার
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CanvasColors.deepGreenAccent,
                      foregroundColor: CanvasColors.goldLight,
                      side: const BorderSide(color: CanvasColors.goldPrimary, width: 0.8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('নতুন ক্যাটাগরি তৈরি করুন', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: _showNewCategoryDialog,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: widget.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final cat = widget.categories[index];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: CanvasTheme.glassBoxDecoration(radius: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.folder, color: CanvasColors.goldPrimary),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${cat.bengaliIndex}. ${cat.name}',
                                      style: const TextStyle(
                                        color: CanvasColors.textIvory,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'স্লাগ: /${cat.slug}',
                                      style: const TextStyle(color: CanvasColors.textSubtle, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                              onPressed: () {
                                setState(() {
                                  widget.categories.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ট্যাব ৩: বাণী নিয়ন্ত্রণ
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.separated(
              itemCount: widget.quotes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final q = widget.quotes[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: CanvasTheme.glassBoxDecoration(radius: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: q.isActive ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              q.isActive ? 'হোমস্ক্রিনে সক্রিয়' : 'নিষ্ক্রিয়',
                              style: TextStyle(
                                color: q.isActive ? Colors.greenAccent : CanvasColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Switch(
                            value: q.isActive,
                            activeColor: CanvasColors.goldPrimary,
                            onChanged: (val) {
                              setState(() {
                                for (var item in widget.quotes) {
                                  widget.quotes[widget.quotes.indexOf(item)] = LivingQuote(
                                    id: item.id,
                                    quoteText: item.quoteText,
                                    referenceSource: item.referenceSource,
                                    isActive: item.id == q.id ? val : false,
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '"${q.quoteText}"',
                        style: const TextStyle(color: CanvasColors.textIvory, fontSize: 13, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'উৎস: ${q.referenceSource}',
                        style: const TextStyle(color: CanvasColors.goldLight, fontSize: 11),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ট্যাব ৪: প্রোফাইল সম্পূর্ণ এডিট
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: CanvasTheme.glassBoxDecoration(radius: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('লেখক প্রোফাইল ও সংযোগ সেটিংস', style: TextStyle(color: CanvasColors.goldLight, fontWeight: FontWeight.bold, fontSize: 16)),
                    const Divider(color: CanvasColors.glassBorder),
                    const SizedBox(height: 10),
                    Text('নাম: ${widget.author.name.isEmpty ? "(খালি আছে)" : widget.author.name}', style: const TextStyle(color: CanvasColors.textIvory)),
                    const SizedBox(height: 6),
                    Text('WhatsApp: ${widget.author.whatsappNumber}', style: const TextStyle(color: CanvasColors.textIvory)),
                    const SizedBox(height: 6),
                    Text('Facebook Profile: ${widget.author.facebookProfileUrl}', style: const TextStyle(color: CanvasColors.textSubtle, fontSize: 11)),
                    const SizedBox(height: 6),
                    Text('Portal: ${widget.author.portalUrl}', style: const TextStyle(color: CanvasColors.textSubtle, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
