// =====================================================================
// 'স্মৃতির ক্যানভাস' (Smritir Canvas) — Hollywood Cinematic Live Loading
// Rotating Golden Aurora Light Ring, Real-Time % Counter & Particle Dispersion
// =====================================================================

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/canvas_theme.dart';

class HollywoodCinematicSplash extends StatefulWidget {
  final VoidCallback onLoaded;

  const HollywoodCinematicSplash({Key? key, required this.onLoaded}) : super(key: key);

  @override
  State<HollywoodCinematicSplash> createState() => _HollywoodCinematicSplashState();
}

class _HollywoodCinematicSplashState extends State<HollywoodCinematicSplash> with TickerProviderStateMixin {
  late AnimationController _auroraRingController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  int _progressPercent = 0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();

    // ১. গোল্ডেন অরোরা রিং ঘূর্ণন অ্যানিমেশন (Hollywood Cinematic Rotation)
    _auroraRingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // ২. ক্যানভাস লোগো পালস ইফেক্ট
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // ৩. রিয়েল-টাইম ০% থেকে ১০০% লাইভ অ্যানিমেটেড কাউন্টার
    _startPercentageCounter();
  }

  void _startPercentageCounter() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      if (_progressPercent < 100) {
        setState(() {
          _progressPercent += 1;
        });
      } else {
        _progressTimer?.cancel();
        // ১০০% হওয়ার পর হালকা সিনেমাটিক ডিলে দিয়ে মূল স্ক্রিন উন্মোচন
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            widget.onLoaded();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _auroraRingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CanvasColors.emeraldBg,
      body: Stack(
        children: [
          // ব্যাকগ্রাউন্ড সিনেমাটিক আলোর আভা
          Positioned.fill(
            child: Container(
              decoration: const RadialGradient(
                center: Alignment(0.0, -0.1),
                radius: 1.1,
                colors: [
                  Color(0xFF1B4D3E),
                  Color(0xFF0E2A22),
                  CanvasColors.emeraldBg,
                ],
              ),
            ),
          ),

          // সেন্ট্রাল হলিউড অরোরা ও % লোডার
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ঘূর্ণায়মান সিনেমাটিক অরোরা রিং ও ক্যানভাস প্রতীক
                SizedBox(
                  width: 170,
                  height: 170,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // ঘূর্ণায়মান গোল্ডেন রেখা
                      AnimatedBuilder(
                        animation: _auroraRingController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _auroraRingController.value * 2 * math.pi,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: CanvasColors.goldPrimary.withOpacity(0.35),
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: CanvasColors.goldPrimary.withOpacity(0.3),
                                    blurRadius: 25,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      // প্রগ্রেস ইন্ডিকেটর আর্ক
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircularProgressIndicator(
                          value: _progressPercent / 100.0,
                          strokeWidth: 3.5,
                          valueColor: const AlwaysStoppedAnimation<Color>(CanvasColors.goldNeonGlow),
                          backgroundColor: Colors.transparent,
                        ),
                      ),

                      // সেন্ট্রাল পালসিং ক্যানভাস ও কলম মোটিফ
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 105,
                              height: 105,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: CanvasColors.surfaceEmerald,
                                border: Border.all(color: CanvasColors.goldPrimary, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: CanvasColors.goldPrimary.withOpacity(0.4),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.auto_stories,
                                color: CanvasColors.goldPrimary,
                                size: 50,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // অ্যাপের নাম (স্মৃতির ক্যানভাস)
                const Text(
                  'স্মৃতির ক্যানভাস',
                  style: TextStyle(
                    fontFamily: 'Hind Siliguri',
                    color: CanvasColors.goldNeonGlow,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        color: CanvasColors.goldPrimary,
                        blurRadius: 18,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Smritir Canvas • Living Magazine & Studio',
                  style: TextStyle(
                    fontFamily: 'Hind Siliguri',
                    color: CanvasColors.textMuted,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 28),

                // লাইভ রিয়েল-টাইম % কাউন্টার ডিসপ্লে
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: CanvasColors.emeraldSurface.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: CanvasColors.glassBorder),
                    boxShadow: [
                      BoxShadow(
                        color: CanvasColors.goldPrimary.withOpacity(0.15),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, color: CanvasColors.goldPrimary, size: 14),
                      const SizedBox(width: 8),
                      Text(
                        'প্রবেশ করা হচ্ছে... $_progressPercent%',
                        style: const TextStyle(
                          fontFamily: 'Hind Siliguri',
                          color: CanvasColors.textIvory,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
