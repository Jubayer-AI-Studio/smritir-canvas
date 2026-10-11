// =====================================================================
// 'স্মৃতির ক্যানভাস' (Smritir Canvas) — Live Frosted Glass Header
// English Date Display, Real-time Seconds Digital Clock, Multi-Mode & Language Toggles
// =====================================================================

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/localization_service.dart';
import '../services/prayer_service.dart';
import '../theme/canvas_theme.dart';

class LiveGlassHeader extends StatefulWidget {
  final AppThemeMode currentMode;
  final AppLanguage currentLang;
  final Function(AppThemeMode) onThemeModeChanged;
  final Function(AppLanguage) onLanguageChanged;

  const LiveGlassHeader({
    Key? key,
    required this.currentMode,
    required this.currentLang,
    required this.onThemeModeChanged,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  State<LiveGlassHeader> createState() => _LiveGlassHeaderState();
}

class _LiveGlassHeaderState extends State<LiveGlassHeader> with SingleTickerProviderStateMixin {
  late Timer _clockTimer;
  late DateTime _currentTime;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  PrayerCalculationResult? _prayerTimes;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _updateCalculations();

    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
          if (_currentTime.second == 0) {
            _updateCalculations();
          }
        });
      }
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _updateCalculations() {
    _prayerTimes = PrayerService.calculatePrayerTimes(date: _currentTime);
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String _formatLiveClock(DateTime dt) {
    int h = dt.hour;
    int m = dt.minute;
    int s = dt.second;
    String ampm = h >= 12 ? 'PM' : 'AM';
    int displayH = h % 12;
    if (displayH == 0) displayH = 12;
    return '${displayH.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')} $ampm';
  }

  // ইউজার নির্দেশনা অনুযায়ী তারিখ সর্বদা স্পষ্ট ইংরেজি ফরম্যাটে প্রদর্শিত হবে
  String _formatEnglishDate(DateTime dt) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    final dayName = days[dt.weekday - 1];
    final monthName = months[dt.month - 1];
    return '$dayName, ${dt.day} $monthName ${dt.year}';
  }

  void _cycleNextTheme() {
    final modes = [AppThemeMode.emerald, AppThemeMode.light, AppThemeMode.sepia, AppThemeMode.amoled];
    final nextIdx = (modes.indexOf(widget.currentMode) + 1) % modes.length;
    widget.onThemeModeChanged(modes[nextIdx]);
  }

  IconData _getModeIcon() {
    switch (widget.currentMode) {
      case AppThemeMode.light:
        return Icons.wb_sunny_rounded;
      case AppThemeMode.sepia:
        return Icons.auto_stories;
      case AppThemeMode.amoled:
        return Icons.dark_mode;
      case AppThemeMode.emerald:
      default:
        return Icons.diamond_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final englishDate = _formatEnglishDate(_currentTime);
    final isBn = widget.currentLang == AppLanguage.bn;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(26),
        bottomRight: Radius.circular(26),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                widget.currentMode == AppThemeMode.light 
                    ? CanvasColors.lightSurface.withOpacity(0.96)
                    : (widget.currentMode == AppThemeMode.sepia 
                        ? CanvasColors.sepiaSurface.withOpacity(0.96)
                        : (widget.currentMode == AppThemeMode.amoled 
                            ? Colors.black.withOpacity(0.98) 
                            : CanvasColors.emeraldBg.withOpacity(0.96))),
                widget.currentMode == AppThemeMode.light 
                    ? CanvasColors.lightCard.withOpacity(0.90)
                    : (widget.currentMode == AppThemeMode.sepia 
                        ? CanvasColors.sepiaCard.withOpacity(0.90)
                        : (widget.currentMode == AppThemeMode.amoled 
                            ? Colors.black.withOpacity(0.92) 
                            : CanvasColors.emeraldSurface.withOpacity(0.88))),
              ],
            ),
            border: Border(
              bottom: BorderSide(
                color: widget.currentMode == AppThemeMode.light 
                    ? CanvasColors.lightBorder 
                    : CanvasColors.glassBorder, 
                width: 1.2,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // টপ বার: লোগো ও নাম, থিম সুইচার, ল্যাঙ্গুয়েজ টগল ও রিয়েল-টাইম ডিজিটাল ঘড়ি
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: CanvasColors.goldPrimary, width: 1.2),
                          color: CanvasColors.emeraldDeep.withOpacity(0.4),
                        ),
                        child: const Icon(Icons.auto_stories, color: CanvasColors.goldPrimary, size: 17),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isBn ? 'স্মৃতির ক্যানভাস' : 'Smritir Canvas',
                        style: const TextStyle(
                          fontFamily: 'Hind Siliguri',
                          color: CanvasColors.goldPrimary,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      // মোড সুইচার বাটন (Emerald, Light, Sepia, AMOLED)
                      IconButton(
                        icon: Icon(_getModeIcon(), color: CanvasColors.goldLight, size: 19),
                        tooltip: 'থিম পরিবর্তন (৪টি মোড)',
                        onPressed: _cycleNextTheme,
                      ),

                      // ভাষা পরিবর্তন বাটন (বাংলা / English)
                      InkWell(
                        onTap: () {
                          widget.onLanguageChanged(
                            widget.currentLang == AppLanguage.bn ? AppLanguage.en : AppLanguage.bn,
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            border: Border.all(color: CanvasColors.glassBorder, width: 0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isBn ? 'বাং' : 'EN',
                            style: const TextStyle(
                              color: CanvasColors.goldNeonGlow,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // রিয়েল-টাইম সেকেন্ড ডিজিটাল ঘড়ি
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: CanvasColors.goldPrimary.withOpacity(0.6 * _pulseAnimation.value),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: CanvasColors.goldPrimary.withOpacity(0.2 * _pulseAnimation.value),
                                  blurRadius: 10 * _pulseAnimation.value,
                                ),
                              ],
                            ),
                            child: Text(
                              _formatLiveClock(_currentTime),
                              style: const TextStyle(
                                color: CanvasColors.goldNeonGlow,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                fontFamily: 'monospace',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ব্যবহারকারীর নির্দেশ অনুযায়ী ইংরেজি তারিখ (English Date Display)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: CanvasTheme.glassBoxDecoration(mode: widget.currentMode, radius: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined, color: CanvasColors.goldPrimary, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          englishDate,
                          style: TextStyle(
                            fontFamily: 'Hind Siliguri',
                            color: widget.currentMode == AppThemeMode.light 
                                ? CanvasColors.lightText 
                                : (widget.currentMode == AppThemeMode.sepia 
                                    ? CanvasColors.sepiaText 
                                    : CanvasColors.textIvory),
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: CanvasColors.goldPrimary.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'English Date',
                        style: TextStyle(
                          color: CanvasColors.goldLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // নামাজের ওয়াক্ত কাউন্টডাউন
              if (_prayerTimes != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: CanvasColors.emeraldDeep.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: CanvasColors.goldPrimary.withOpacity(0.4), width: 0.8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time_filled, color: CanvasColors.goldPrimary, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        isBn 
                            ? 'পরবর্তী ওয়াক্ত: ${_prayerTimes!.nextPrayerName} — বাকি ${_formatRemaining(_prayerTimes!.timeRemaining)}'
                            : 'Next Prayer: ${_prayerTimes!.nextPrayerName} — ${_formatRemainingEn(_prayerTimes!.timeRemaining)} left',
                        style: TextStyle(
                          fontFamily: 'Hind Siliguri',
                          color: widget.currentMode == AppThemeMode.light ? CanvasColors.lightText : CanvasColors.textIvory,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatRemaining(Duration d) {
    if (d.isNegative) return 'এখনই';
    int hours = d.inHours;
    int mins = d.inMinutes % 60;
    if (hours > 0) return '$hours ঘণ্টা $mins মি.';
    return '$mins মিনিট';
  }

  String _formatRemainingEn(Duration d) {
    if (d.isNegative) return 'Now';
    int hours = d.inHours;
    int mins = d.inMinutes % 60;
    if (hours > 0) return '$hours hrs $mins mins';
    return '$mins mins';
  }
}
