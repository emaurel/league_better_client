import 'package:flutter/material.dart';

/// League-inspired palette. Names follow Riot's own design tokens loosely.
class AppColors {
  AppColors._();

  // Background layers
  static const Color hextechBlack = Color(0xFF010A13);
  static const Color deepNavy = Color(0xFF091428);
  static const Color navy = Color(0xFF0A1428);
  static const Color navyElevated = Color(0xFF0F1A2C);
  static const Color navyOutline = Color(0xFF1E2D40);

  // Gold family
  static const Color goldDark = Color(0xFF463714);
  static const Color goldMid = Color(0xFF785A28);
  static const Color gold = Color(0xFFC8AA6E);
  static const Color goldHover = Color(0xFFC89B3C);
  static const Color goldLight = Color(0xFFF0E6D2);

  // Text
  static const Color textPrimary = Color(0xFFF0E6D2);
  static const Color textSecondary = Color(0xFFA09B8C);
  static const Color textMuted = Color(0xFF5B5A56);

  // Status
  static const Color positive = Color(0xFF0ACBE6);
  static const Color negative = Color(0xFFE84057);
  static const Color warn = Color(0xFFE8B65A);
  static const Color online = Color(0xFF7AC74F);
  static const Color away = Color(0xFFE8B65A);
  static const Color offline = Color(0xFF6E6E6E);
}
