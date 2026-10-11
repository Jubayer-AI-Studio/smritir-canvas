// =====================================================================
// 'স্মৃতির ক্যানভাস' (Smritir Canvas) — 3D Virtual Bookshelf & Kitab Reader
// Featuring Author's Authentic Reading List & Eye-Protection Reader
// =====================================================================

import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/canvas_theme.dart';

class BookshelfScreen extends StatefulWidget {
  final List<BookItem> books;

  const BookshelfScreen({Key? key, required this.books}) : super(key: key);

  @override
  State<BookshelfScreen> createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State<BookshelfScreen> {
  String _selectedFilter = 'all';

  List<BookItem> get _filteredBooks {
    if (_selectedFilter == 'all') return widget.books;
    return widget.books.where((b) => b.readingStatus == _selectedFilter).toList();
  }

  void _openBookReader(BookItem book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CanvasColors.surfaceEmerald,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      book.title,
                      style: const TextStyle(
                        color: CanvasColors.goldNeonGlow,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: CanvasColors.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Text(
                'সংকলক/লেখক: ${book.originalAuthor}',
                style: const TextStyle(color: CanvasColors.textMuted, fontSize: 13),
              ),
              const Divider(color: CanvasColors.glassBorder),
              const SizedBox(height: 10),

              Text(
                'পড়া হয়েছে: ${book.currentPage} / ${book.totalPages} পৃষ্ঠা',
                style: const TextStyle(color: CanvasColors.textIvory, fontSize: 14),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: book.totalPages > 0 ? (book.currentPage / book.totalPages) : 0.0,
                backgroundColor: CanvasColors.darkCharcoal,
                valueColor: const AlwaysStoppedAnimation<Color>(CanvasColors.goldPrimary),
              ),
              const SizedBox(height: 16),

              if (book.scholarNotes != null) ...[
                const Text(
                  '📝 কিতাব পাঠ পরবর্তী আপনার নোট:',
                  style: TextStyle(color: CanvasColors.goldLight, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: CanvasTheme.glassBoxDecoration(radius: 12),
                  child: Text(
                    book.scholarNotes!,
                    style: const TextStyle(color: CanvasColors.textIvory, fontSize: 13, height: 1.4),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CanvasColors.goldPrimary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.menu_book_rounded),
                  label: const Text('কিতাব পড়ুন (সেপিয়া / নাইট মোড)', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('📖 কিতাব রিডার নাইট আই-প্রোটেকশন মোডে ওপেন হচ্ছে...'),
                        backgroundColor: CanvasColors.deepGreenAccent,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _filterTab('সব', 'all'),
              _filterTab('পড়ছি', 'reading'),
              _filterTab('পড়া শেষ', 'completed'),
              _filterTab('পড়ার ইচ্ছা', 'wishlist'),
            ],
          ),
        ),

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.72,
            ),
            itemCount: _filteredBooks.length,
            itemBuilder: (context, index) {
              final book = _filteredBooks[index];
              return InkWell(
                onTap: () => _openBookReader(book),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CanvasColors.cardEmerald,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: CanvasColors.glassBorder, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(4, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [CanvasColors.deepGreenAccent, Color(0xFF0A2219)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: CanvasColors.goldPrimary.withOpacity(0.4), width: 1),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.menu_book, color: CanvasColors.goldPrimary, size: 36),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    book.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: CanvasColors.goldNeonGlow,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        book.title,
                        style: const TextStyle(
                          color: CanvasColors.textIvory,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        book.originalAuthor,
                        style: const TextStyle(color: CanvasColors.textSubtle, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: CanvasColors.deepGreenAccent.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              book.readingStatus == 'reading'
                                  ? 'পড়ছি'
                                  : (book.readingStatus == 'completed' ? 'পড়া শেষ' : 'ইচ্ছা'),
                              style: const TextStyle(color: CanvasColors.goldLight, fontSize: 10),
                            ),
                          ),
                          Text(
                            '${book.currentPage}/${book.totalPages} পৃ.',
                            style: const TextStyle(color: CanvasColors.textSubtle, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _filterTab(String label, String value) {
    final isSelected = _selectedFilter == value;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? CanvasColors.goldPrimary.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? CanvasColors.goldPrimary : Colors.transparent,
            width: 0.8,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? CanvasColors.goldNeonGlow : CanvasColors.textMuted,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12.5,
          ),
        ),
      ),
    );
  }
}
