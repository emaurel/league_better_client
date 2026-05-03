import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Builds the global Material theme. Two type families:
///   - Cinzel for display/heading (open-source stand-in for Beaufort).
///   - Spectral for body — readable serif that pairs well with Cinzel.
ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: true);

  final headingStyle = GoogleFonts.cinzelTextTheme(base.textTheme);
  final bodyStyle = GoogleFonts.spectralTextTheme(base.textTheme);

  final textTheme = bodyStyle.copyWith(
    displayLarge: headingStyle.displayLarge?.copyWith(color: AppColors.goldLight),
    displayMedium: headingStyle.displayMedium?.copyWith(color: AppColors.goldLight),
    displaySmall: headingStyle.displaySmall?.copyWith(color: AppColors.goldLight),
    headlineLarge: headingStyle.headlineLarge?.copyWith(
      color: AppColors.goldLight,
      letterSpacing: 1.4,
    ),
    headlineMedium: headingStyle.headlineMedium?.copyWith(
      color: AppColors.goldLight,
      letterSpacing: 1.2,
    ),
    headlineSmall: headingStyle.headlineSmall?.copyWith(
      color: AppColors.goldLight,
      letterSpacing: 1.0,
    ),
    titleLarge: headingStyle.titleLarge?.copyWith(
      color: AppColors.gold,
      letterSpacing: 1.0,
    ),
    titleMedium: headingStyle.titleMedium?.copyWith(color: AppColors.gold),
    titleSmall: headingStyle.titleSmall?.copyWith(color: AppColors.gold),
    bodyLarge: bodyStyle.bodyLarge?.copyWith(color: AppColors.textPrimary),
    bodyMedium: bodyStyle.bodyMedium?.copyWith(color: AppColors.textPrimary),
    bodySmall: bodyStyle.bodySmall?.copyWith(color: AppColors.textSecondary),
    labelLarge: headingStyle.labelLarge?.copyWith(
      color: AppColors.gold,
      letterSpacing: 1.4,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.hextechBlack,
    canvasColor: AppColors.hextechBlack,
    colorScheme: ColorScheme.dark(
      surface: AppColors.navy,
      surfaceContainerHighest: AppColors.navyElevated,
      primary: AppColors.gold,
      onPrimary: AppColors.hextechBlack,
      secondary: AppColors.goldHover,
      onSecondary: AppColors.hextechBlack,
      error: AppColors.negative,
      outline: AppColors.goldMid,
      onSurface: AppColors.textPrimary,
    ),
    textTheme: textTheme,
    dividerTheme: const DividerThemeData(
      color: AppColors.navyOutline,
      thickness: 1,
      space: 1,
    ),
    iconTheme: const IconThemeData(color: AppColors.gold, size: 20),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.gold,
      linearTrackColor: AppColors.navyElevated,
      circularTrackColor: AppColors.navyElevated,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.navyElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: AppColors.goldMid),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: AppColors.navyOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: AppColors.gold, width: 1.4),
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.navyElevated;
          }
          return AppColors.goldMid;
        }),
        foregroundColor: WidgetStateProperty.all(AppColors.goldLight),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return const BorderSide(color: AppColors.navyOutline);
          }
          return const BorderSide(color: AppColors.gold, width: 1.2);
        }),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        textStyle: WidgetStateProperty.all(
          textTheme.labelLarge?.copyWith(letterSpacing: 1.6, fontSize: 13),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        ),
        elevation: WidgetStateProperty.all(0),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.gold),
        side: WidgetStateProperty.all(
          const BorderSide(color: AppColors.goldMid, width: 1.2),
        ),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        textStyle: WidgetStateProperty.all(
          textTheme.labelLarge?.copyWith(letterSpacing: 1.4),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.gold),
        textStyle: WidgetStateProperty.all(
          textTheme.labelLarge?.copyWith(letterSpacing: 1.2),
        ),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      ),
    ),
    tooltipTheme: TooltipThemeData(
      textStyle: textTheme.bodySmall?.copyWith(color: AppColors.goldLight),
      decoration: BoxDecoration(
        color: AppColors.navyElevated,
        border: Border.all(color: AppColors.goldMid),
      ),
    ),
    splashColor: AppColors.goldMid.withValues(alpha: 0.18),
    highlightColor: AppColors.goldMid.withValues(alpha: 0.12),
  );
}
