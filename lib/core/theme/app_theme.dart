import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.primaryRed,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryRed,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.primaryRed.withAlpha(128),
        onPrimaryContainer: AppColors.white,
        secondary: AppColors.accentRed,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.accentRed.withAlpha(128),
        onSecondaryContainer: AppColors.white,
        tertiary: AppColors.accentRed,
        onTertiary: AppColors.white,
        tertiaryContainer: AppColors.accentRed.withAlpha(128),
        onTertiaryContainer: AppColors.white,
        error: AppColors.error,
        onError: AppColors.white,
        errorContainer: AppColors.error.withAlpha(128),
        onErrorContainer: AppColors.white,
        surface: AppColors.cardBackground,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.cardBackground,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.border,
        outlineVariant: AppColors.border,
        shadow: AppColors.shadow,
        scrim: AppColors.black.withAlpha(128),
        inverseSurface: AppColors.textPrimary,
        onInverseSurface: AppColors.background,
        inversePrimary: AppColors.primaryRed,
        surfaceTint: AppColors.primaryRed.withAlpha(128),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          elevation: 4,
          shadowColor: AppColors.primaryRed.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.cardBackground,
        elevation: 8,
        shadowColor: AppColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryRed, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textTertiary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: AppColors.iconPrimary),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryRed,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.black54,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryRed,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryRed.withAlpha(128),
        onPrimaryContainer: Colors.white,
        secondary: AppColors.accentRed,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.accentRed.withAlpha(128),
        onSecondaryContainer: Colors.white,
        tertiary: AppColors.accentRed,
        onTertiary: Colors.white,
        tertiaryContainer: AppColors.accentRed.withAlpha(128),
        onTertiaryContainer: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        errorContainer: AppColors.error.withAlpha(128),
        onErrorContainer: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        surfaceContainerHighest: Colors.grey.shade100,
        onSurfaceVariant: Colors.black54,
        outline: Colors.grey.shade400,
        outlineVariant: Colors.grey.shade400,
        shadow: Colors.black.withAlpha(128),
        scrim: Colors.black.withAlpha(128),
        inverseSurface: Colors.black,
        onInverseSurface: Colors.white,
        inversePrimary: AppColors.primaryRed,
        surfaceTint: AppColors.primaryRed.withAlpha(128),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.primaryRed.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.black.withAlpha(128),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryRed, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.black54),
        hintStyle: const TextStyle(color: Colors.black38),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
    );
  }
}
