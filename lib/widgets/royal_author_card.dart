// =====================================================================
// 'স্মৃতির ক্যানভাস' (Smritir Canvas) — Royal Author Hero Section
// Editable Author Name Placeholder, Badges & Verified Quick Connect Links
// =====================================================================

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../theme/canvas_theme.dart';

class RoyalAuthorCard extends StatefulWidget {
  final AuthorProfile author;
  final VoidCallback onSecretAdminTap;
  final Function(String newName) onUpdateAuthorName;

  const RoyalAuthorCard({
    Key? key,
    required this.author,
    required this.onSecretAdminTap,
    required this.onUpdateAuthorName,
  }) : super(key: key);

  @override
  State<RoyalAuthorCard> createState() => _RoyalAuthorCardState();
}

class _RoyalAuthorCardState extends State<RoyalAuthorCard> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 2.0, end: 8.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _launchExternalUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _editNameDialog() {
    final controller = TextEditingController(text: widget.author.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CanvasColors.surfaceEmerald,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: CanvasColors.glassBorder),
          ),
          title: const Text('আপনার নাম ও পরিচয় লিখুন', style: TextStyle(color: CanvasColors.goldLight, fontSize: 16)),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: CanvasColors.textIvory),
            decoration: const InputDecoration(
              hintText: 'মাওলানা [আপনার নাম]...',
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
                widget.onUpdateAuthorName(controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text('সংরক্ষণ করুন'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.author.name.trim().isNotEmpty 
        ? widget.author.name 
        : 'মাওলানা (নাম যোগ করতে ট্যাপ করুন)';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: CanvasTheme.glassBoxDecoration(radius: 20),
      child: Column(
        children: [
          Row(
            children: [
              // গোল ফ্রেমে মৃদু পালস গ্লো বর্ডারযুক্ত প্রোফাইল ছবি
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: CanvasColors.goldPrimary.withOpacity(0.4),
                          blurRadius: _glowAnimation.value,
                          spreadRadius: _glowAnimation.value * 0.3,
                        ),
                      ],
                      border: Border.all(color: CanvasColors.goldPrimary, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 34,
                      backgroundColor: CanvasColors.surfaceEmerald,
                      child: const Icon(
                        Icons.person_rounded,
                        size: 42,
                        color: CanvasColors.goldLight,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 14),

              // লেখকের নাম ও ক্যালিগ্রাফিক ব্যাজ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _editNameDialog,
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    displayName,
                                    style: TextStyle(
                                      color: widget.author.name.trim().isNotEmpty 
                                          ? CanvasColors.textIvory 
                                          : CanvasColors.goldLight.withOpacity(0.85),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.edit, size: 14, color: CanvasColors.goldPrimary),
                              ],
                            ),
                          ),
                        ),
                        // সুপার অ্যাডমিন কিহোল বাটন
                        IconButton(
                          icon: const Icon(Icons.vpn_key_outlined, size: 20),
                          color: CanvasColors.goldPrimary.withOpacity(0.85),
                          tooltip: 'সুপার অ্যাডমিন লগইন',
                          onPressed: widget.onSecretAdminTap,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),

                    // ব্যাজসমূহ
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: widget.author.titleBadges.map((badge) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: CanvasColors.deepGreenAccent.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: CanvasColors.goldPrimary.withOpacity(0.3),
                              width: 0.6,
                            ),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: CanvasColors.goldLight,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ভেরিফায়েড কুইক কানেক্ট বাটন বার
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            decoration: BoxDecoration(
              color: CanvasColors.darkCharcoal.withOpacity(0.65),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: CanvasColors.glassBorder, width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _connectButton(
                  icon: Icons.chat_bubble_outline,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  onTap: () => _launchExternalUrl('https://wa.me/8801990537782'),
                ),
                Container(height: 20, width: 1, color: CanvasColors.glassBorder),

                _connectButton(
                  icon: Icons.person_search_outlined,
                  label: 'প্রোফাইল',
                  color: const Color(0xFF1877F2),
                  onTap: () => _launchExternalUrl(widget.author.facebookProfileUrl),
                ),
                Container(height: 20, width: 1, color: CanvasColors.glassBorder),

                _connectButton(
                  icon: Icons.thumb_up_alt_outlined,
                  label: 'ফেসবুক পেজ',
                  color: const Color(0xFF4267B2),
                  onTap: () => _launchExternalUrl(widget.author.facebookPageUrl),
                ),
                Container(height: 20, width: 1, color: CanvasColors.glassBorder),

                _connectButton(
                  icon: Icons.newspaper_outlined,
                  label: 'ourislam24',
                  color: CanvasColors.goldPrimary,
                  onTap: () => _launchExternalUrl(widget.author.portalUrl),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _connectButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: CanvasColors.textIvory.withOpacity(0.9),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
