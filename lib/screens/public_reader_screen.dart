// =====================================================================
// 'স্মৃতির ক্যানভাস' (Smritir Canvas) — Public Reader Magazine Screen
// Authentic Articles, Bengali Alphabet Indexing, Likes & Comments
// =====================================================================

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../services/interaction_service.dart';
import '../theme/canvas_theme.dart';

class PublicReaderScreen extends StatefulWidget {
  final List<ArticleItem> articles;
  final List<CategoryItem> categories;

  const PublicReaderScreen({
    Key? key,
    required this.articles,
    required this.categories,
  }) : super(key: key);

  @override
  State<PublicReaderScreen> createState() => _PublicReaderScreenState();
}

class _PublicReaderScreenState extends State<PublicReaderScreen> {
  String? _selectedCategoryId;

  List<ArticleItem> get _filteredArticles {
    if (_selectedCategoryId == null) {
      return widget.articles.where((a) => a.status == 'published').toList();
    }
    return widget.articles
        .where((a) => a.status == 'published' && a.categoryId == _selectedCategoryId)
        .toList();
  }

  void _showCommentDialog(ArticleItem article) {
    final nameController = TextEditingController();
    final commentController = TextEditingController();
    final comments = InteractionService.getCommentsForArticle(article.id);

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'পাঠকের মন্তব্য ও পর্যালোচনা',
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

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: comments.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'এখনও কোনো মন্তব্য নেই। প্রথম মন্তব্যটি করুন!',
                                style: TextStyle(color: CanvasColors.textMuted, fontSize: 13),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: comments.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final c = comments[index];
                              return Container(
                                padding: const EdgeInsets.all(10),
                                decoration: CanvasTheme.glassBoxDecoration(radius: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.readerName,
                                      style: const TextStyle(
                                        color: CanvasColors.goldLight,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      c.readerComment,
                                      style: const TextStyle(
                                        color: CanvasColors.textIvory,
                                        fontSize: 13,
                                      ),
                                    ),
                                    if (c.authorReply != null) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: CanvasColors.deepGreenAccent.withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: CanvasColors.goldPrimary, width: 0.6),
                                        ),
                                        child: Text(
                                          'লেখক (স্মৃতির ক্যানভাস): ${c.authorReply}',
                                          style: const TextStyle(
                                            color: CanvasColors.goldLight,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: CanvasColors.textIvory),
                    decoration: InputDecoration(
                      hintText: 'আপনার নাম...',
                      hintStyle: const TextStyle(color: CanvasColors.textSubtle),
                      filled: true,
                      fillColor: CanvasColors.darkCharcoal,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: CanvasColors.glassBorder),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: commentController,
                    maxLines: 2,
                    style: const TextStyle(color: CanvasColors.textIvory),
                    decoration: InputDecoration(
                      hintText: 'আপনার চিন্তাশীল মন্তব্য লিখুন...',
                      hintStyle: const TextStyle(color: CanvasColors.textSubtle),
                      filled: true,
                      fillColor: CanvasColors.darkCharcoal,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: CanvasColors.glassBorder),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CanvasColors.goldPrimary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        if (commentController.text.trim().isNotEmpty) {
                          InteractionService.addComment(
                            articleId: article.id,
                            readerName: nameController.text,
                            commentText: commentController.text,
                          );
                          setModalState(() {});
                          setState(() {});
                          commentController.clear();
                        }
                      },
                      child: const Text('মন্তব্য প্রকাশ করুন', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _shareArticle(ArticleItem article) async {
    final url = InteractionService.generateFacebookShareUrl(article);
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ক্যাটাগরি ফিল্টার চিপস
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _filterChip(
                label: 'সব লেখা',
                isSelected: _selectedCategoryId == null,
                onTap: () => setState(() => _selectedCategoryId = null),
              ),
              ...widget.categories.map((cat) {
                return _filterChip(
                  label: '${cat.bengaliIndex}. ${cat.name}',
                  isSelected: _selectedCategoryId == cat.id,
                  onTap: () => setState(() => _selectedCategoryId = cat.id),
                );
              }).toList(),
            ],
          ),
        ),

        // আর্টিকেল ফিড
        Expanded(
          child: _filteredArticles.isEmpty
              ? const Center(
                  child: Text(
                    'এই ক্যাটাগরিতে এখনও কোনো প্রকাশিত লেখা নেই।',
                    style: TextStyle(color: CanvasColors.textMuted),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                  itemCount: _filteredArticles.length,
                  itemBuilder: (context, index) {
                    final article = _filteredArticles[index];
                    final isLiked = InteractionService.hasLiked(article.id);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: CanvasTheme.glassBoxDecoration(radius: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: CanvasColors.deepGreenAccent.withOpacity(0.55),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: CanvasColors.goldPrimary, width: 0.6),
                                ),
                                child: Text(
                                  article.bengaliOrderTag ?? 'ক-${index + 1}',
                                  style: const TextStyle(
                                    color: CanvasColors.goldLight,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined, size: 13, color: CanvasColors.textSubtle),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${article.readingTimeMinutes} মিনিট পাঠ • ${article.wordCount} শব্দ',
                                    style: const TextStyle(color: CanvasColors.textSubtle, fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Text(
                            article.title,
                            style: const TextStyle(
                              color: CanvasColors.textIvory,
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold,
                              height: 1.35,
                            ),
                          ),
                          if (article.subtitle != null && article.subtitle!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              article.subtitle!,
                              style: const TextStyle(
                                color: CanvasColors.goldLight,
                                fontSize: 13,
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),

                          Text(
                            article.excerpt ?? article.content,
                            style: const TextStyle(
                              color: CanvasColors.textMuted,
                              fontSize: 13.5,
                              height: 1.5,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 14),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isLiked ? Icons.favorite : Icons.favorite_border,
                                      color: isLiked ? Colors.redAccent : CanvasColors.goldPrimary,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        InteractionService.toggleLike(article.id, article);
                                      });
                                    },
                                  ),
                                  Text(
                                    '${article.likesCount + (isLiked ? 1 : 0)}',
                                    style: const TextStyle(color: CanvasColors.textIvory, fontSize: 12),
                                  ),
                                  const SizedBox(width: 14),

                                  IconButton(
                                    icon: const Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      color: CanvasColors.goldPrimary,
                                      size: 19,
                                    ),
                                    onPressed: () => _showCommentDialog(article),
                                  ),
                                  Text(
                                    '${article.commentsCount + InteractionService.getCommentsForArticle(article.id).length}',
                                    style: const TextStyle(color: CanvasColors.textIvory, fontSize: 12),
                                  ),
                                ],
                              ),

                              IconButton(
                                icon: const Icon(Icons.share_outlined, color: CanvasColors.goldPrimary, size: 20),
                                tooltip: 'ফেসবুকে শেয়ার করুন',
                                onPressed: () => _shareArticle(article),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _filterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: CanvasColors.surfaceEmerald,
        selectedColor: CanvasColors.goldPrimary.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? CanvasColors.goldNeonGlow : CanvasColors.textMuted,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? CanvasColors.goldPrimary : CanvasColors.glassBorder,
            width: 0.8,
          ),
        ),
      ),
    );
  }
}
