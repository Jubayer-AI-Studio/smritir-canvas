// =====================================================================
// 'স্মৃতির ক্যানভাস' (Smritir Canvas) — UI/UX Pro Max Multi-Mode Theme Engine
// Hind Siliguri Font & 4 Elite Cinematic Modes:
// 1. Royal Deep Emerald & Gold (Default)
// 2. Day / Light Mode (Daylight Reading)
// 3. Sepia Warm Reader Mode (Eye-Protection Parchment)
// 4. Midnight AMOLED Black (Pure OLED Black)
// =====================================================================

import 'package:flutter/material.dart';

enum AppThemeMode {
  emerald, // রয়্যাল ডিপ এমারেল্ড ও গোল্ড
  light,   // ডে / লাইট মোড
  sepia,   // সেপিয়া ওয়ার্ম রিডার
  amoled,  // ওলেড পিওর ব্ল্যাক
}

class CanvasColors {
  // ১. রয়্যাল ডিপ এমারেল্ড (ডিফল্ট হলিউড সিনেমাটিক)
  static const Color emeraldBg = Color(0xFF0B1411);
  static const Color emeraldSurface = Color(0xFF121C18);
  static const Color emeraldCard = Color(0xFF162520);
  static const Color emeraldDeep = Color(0xFF1B4D3E);

  // ২. ডে / লাইট মোড (ক্লিন ডে-লাইট)
  static const Color lightBg = Color(0xFFF9F9F6);
  static const Color lightSurface = Color(0xFFF2F2EC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1C2826);
  static const Color lightBorder = Color(0x33D4AF37);

  // ৩. সেপিয়া রিডার মোড (আই-প্রোটেকশন পার্চমেন্ট)
  static const Color sepiaBg = Color(0xFFF4ECD8);
  static const Color sepiaSurface = Color(0xFFEDE0C8);
  static const Color sepiaCard = Color(0xFFF9F3E5);
  static const Color sepiaText = Color(0xFF433422);
  static const Color sepiaBorder = Color(0x44B8860B);

  // ৪. ওলেড ব্ল্যাক মোড (অ্যামোলেড জিরো লাইট)
  static const Color amoledBg = Color(0xFF000000);
  static const Color amoledSurface = Color(0xFF080808);
  static const Color amoledCard = Color(0xFF101010);

  // রয়্যাল গোল্ডেন ও নিয়ন গ্লো (সব মোডের জন্য সিগনেচার অ্যাকসেন্ট)
  static const Color goldPrimary = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFE5C07B);
  static const Color goldNeonGlow = Color(0xFFF1D592);
  static const Color goldMuted = Color(0xFF9E8443);

  // ডার্ক টেক্সট কালার
  static const Color textIvory = Color(0xFFF7F7F2);
  static const Color textMuted = Color(0xFFA6B4AD);
  static const Color textSubtle = Color(0xFF6B7E76);

  static const Color glassBorder = Color(0x33D4AF37);
  static const Color glassSurface = Color(0x40162520);
}

class CanvasTheme {
  static ThemeData getTheme(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return _lightTheme;
      case AppThemeMode.sepia:
        return _sepiaTheme;
      case AppThemeMode.amoled:
        return _amoledTheme;
      case AppThemeMode.emerald:
      default:
        return _emeraldTheme;
    }
  }

  // রয়্যাল এমারেল্ড থিম
  static final ThemeData _emeraldTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: CanvasColors.emeraldBg,
    primaryColor: CanvasColors.goldPrimary,
    fontFamily: 'Hind Siliguri',
    colorScheme: const ColorScheme.dark(
      primary: CanvasColors.goldPrimary,
      secondary: CanvasColors.emeraldDeep,
      surface: CanvasColors.emeraldSurface,
      background: CanvasColors.emeraldBg,
      onPrimary: Colors.black,
      onSurface: CanvasColors.textIvory,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Hind Siliguri',
        color: CanvasColors.goldPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // ডে / লাইট থিম
  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: CanvasColors.lightBg,
    primaryColor: CanvasColors.goldMuted,
    fontFamily: 'Hind Siliguri',
    colorScheme: const ColorScheme.light(
      primary: CanvasColors.goldMuted,
      secondary: CanvasColors.emeraldDeep,
      surface: CanvasColors.lightSurface,
      background: CanvasColors.lightBg,
      onPrimary: Colors.white,
      onSurface: CanvasColors.lightText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Hind Siliguri',
        color: CanvasColors.lightText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // সেপিয়া আই-প্রোটেকশন থিম
  static final ThemeData _sepiaTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: CanvasColors.sepiaBg,
    primaryColor: Color(0xFFB8860B),
    fontFamily: 'Hind Siliguri',
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFB8860B),
      secondary: Color(0xFF8B5A2B),
      surface: CanvasColors.sepiaSurface,
      background: CanvasColors.sepiaBg,
      onPrimary: Colors.white,
      onSurface: CanvasColors.sepiaText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Hind Siliguri',
        color: CanvasColors.sepiaText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // ওলেড পিওর ব্ল্যাক থিম
  static final ThemeData _amoledTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: CanvasColors.amoledBg,
    primaryColor: CanvasColors.goldPrimary,
    fontFamily: 'Hind Siliguri',
    colorScheme: const ColorScheme.dark(
      primary: CanvasColors.goldPrimary,
      secondary: CanvasColors.emeraldDeep,
      surface: CanvasColors.amoledSurface,
      background: CanvasColors.amoledBg,
      onPrimary: Colors.black,
      onSurface: CanvasColors.textIvory,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Hind Siliguri',
        color: CanvasColors.goldPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  /// ফ্রস্টেড গ্লাস বক্স ডেকোরেশন (মোড অনুযায়ী স্বয়ংক্রিয় অ্যাডাপ্ট)
  static BoxDecoration glassBoxDecoration({
    required AppThemeMode mode,
    double radius = 18,
  }) {
    Color surface;
    Color border;

    switch (mode) {
      case AppThemeMode.light:
        surface = CanvasColors.lightCard.withOpacity(0.92);
        border = CanvasColors.lightBorder;
        break;
      case AppThemeMode.sepia:
        surface = CanvasColors.sepiaCard.withOpacity(0.92);
        border = CanvasColors.sepiaBorder;
        break;
      case AppThemeMode.amoled:
        surface = CanvasColors.amoledCard;
        border = CanvasColors.glassBorder;
        break;
      case AppThemeMode.emerald:
      default:
        surface = CanvasColors.emeraldCard.withOpacity(0.85);
        border = CanvasColors.glassBorder;
        break;
    }

    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: border, width: 1.2),
      boxShadow: [
        BoxShadow(
          color: CanvasColors.goldPrimary.withOpacity(mode == AppThemeMode.light ? 0.04 : 0.08),
          blurRadius: 18,
          spreadRadius: 1,
        ),
      ],
    );
  }
}
