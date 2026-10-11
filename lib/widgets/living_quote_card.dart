// =====================================================================
// 'স্মৃতির ক্যানভাস' (Smritir Canvas) — Living Shimmering Quote Card
// Subtle Breathing Glow Micro-Animation with Authentic Scholar Quotes
// =====================================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/canvas_theme.dart';

class LivingQuoteCard extends StatefulWidget {
  final LivingQuote quote;
  final VoidCallback? onTap;

  const LivingQuoteCard({
    Key? key,
    required this.quote,
    this.onTap,
  }) : super(key: key);

  @override
  State<LivingQuoteCard> createState() => _LivingQuoteCardState();
}

class _LivingQuoteCardState extends State<LivingQuoteCard> with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    // মৃদু নিয়ন আলোয় ব্রিদিং/ঝিকিমিকি অ্যানিমেশন (Breathing/Shimmer)
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.18, end: 0.48).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breathingController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: CanvasColors.goldPrimary.withOpacity(_glowAnimation.value),
                blurRadius: 18,
                spreadRadius: 1.2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: InkWell(
                onTap: widget.onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: CanvasColors.cardEmerald.withOpacity(0.88),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: CanvasColors.goldPrimary.withOpacity(0.3 + (_glowAnimation.value * 0.5)),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      // ক্যালিগ্রাফিক কোট আইকন
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: CanvasColors.deepGreenAccent.withOpacity(0.55),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: CanvasColors.goldPrimary.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.format_quote_rounded,
                          color: CanvasColors.goldPrimary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // লেখকের খাঁটি বাণী ও উৎস
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '"${widget.quote.quoteText}"',
                              style: const TextStyle(
                                color: CanvasColors.textIvory,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '— ${widget.quote.referenceSource}',
                              style: const TextStyle(
                                color: CanvasColors.goldLight,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // পালস স্পার্কল আইকন
                      Icon(
                        Icons.auto_awesome,
                        color: CanvasColors.goldLight.withOpacity(_glowAnimation.value + 0.35),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
