import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary — Deep Saffron / Warm Orange
  static const Color primary = Color(0xFFE8680A);
  static const Color primaryLight = Color(0xFFF5892A);
  static const Color primaryDark = Color(0xFFBF4F00);

  // Gold accent
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFEDD881);
  static const Color goldDark = Color(0xFFA0850B);

  // Backgrounds — Light
  static const Color backgroundLight = Color(0xFFFDF8F0);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFF9EE);
  static const Color dividerLight = Color(0xFFEDE0C8);

  // Backgrounds — Dark
  static const Color backgroundDark = Color(0xFF1A1410);
  static const Color surfaceDark = Color(0xFF252018);
  static const Color cardDark = Color(0xFF2E2618);
  static const Color dividerDark = Color(0xFF3A3020);

  // Text — Light
  static const Color textPrimaryLight = Color(0xFF1A120B);
  static const Color textSecondaryLight = Color(0xFF6B5A48);
  static const Color textTertiaryLight = Color(0xFF9B8878);

  // Text — Dark
  static const Color textPrimaryDark = Color(0xFFF5ECD8);
  static const Color textSecondaryDark = Color(0xFFB8A898);
  static const Color textTertiaryDark = Color(0xFF7A6E62);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFF9800);

  // Streak / gamification
  static const Color streakFire = Color(0xFFFF6B35);
  static const Color streakGold = Color(0xFFFFD700);

  // Chapter palette (cycling colors for chapter cards)
  static const List<Color> chapterGradients = [
    Color(0xFFE8680A),
    Color(0xFFBF4F00),
    Color(0xFF8B5E3C),
    Color(0xFF6B4C2A),
    Color(0xFF9E7B4F),
    Color(0xFFD4891A),
  ];

  // Situation tags for Apply Gita
  static const Color situationStress = Color(0xFF7B68EE);
  static const Color situationSadness = Color(0xFF4682B4);
  static const Color situationAnger = Color(0xFFDC143C);
  static const Color situationFocus = Color(0xFF2E8B57);
  static const Color situationWork = Color(0xFFE8680A);
  static const Color situationPeace = Color(0xFF20B2AA);
  static const Color situationCourage = Color(0xFFFF6347);
}
