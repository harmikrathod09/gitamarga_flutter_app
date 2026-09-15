import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTextStyles {
  AppTextStyles._();

  // Sanskrit / Devanagari text
  static TextStyle sanskritDisplay({
    Color? color,
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w600,
  }) =>
      TextStyle(
        fontFamily: 'NotoSansDevanagari',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: 1.6,
        letterSpacing: 0.5,
      );

  static TextStyle sanskritBody({
    Color? color,
    double fontSize = 20,
  }) =>
      TextStyle(
        fontFamily: 'NotoSansDevanagari',
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.8,
      );

  // App UI — using Inter
  static TextStyle displayLarge({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.5,
      );

  static TextStyle displayMedium({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.3,
      );

  static TextStyle headlineLarge({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle headlineMedium({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle titleLarge({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle titleMedium({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.1,
      );

  static TextStyle bodyLarge({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.6,
      );

  static TextStyle bodyMedium({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle bodySmall({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.4,
      );

  static TextStyle labelLarge({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
      );

  static TextStyle labelMedium({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.4,
      );

  static TextStyle labelSmall({Color? color}) =>
      GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.5,
      );

  // Special: Om symbol
  static TextStyle omSymbol({Color? color, double fontSize = 48}) =>
      TextStyle(
        fontFamily: 'NotoSansDevanagari',
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color,
      );

  // Transliteration
  static TextStyle transliteration({Color? color, double fontSize = 17}) =>
      GoogleFonts.crimsonText(
        fontSize: fontSize,
        fontStyle: FontStyle.italic,
        color: color,
        height: 1.7,
      );
}
