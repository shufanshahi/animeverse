import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  // ============================
  // DARK THEME
  // ============================
  static ThemeData darkTheme({bool useMaterial3 = true}) {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: useMaterial3,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkAccent,
        onPrimary: AppColors.darkBackground,
        surface: AppColors.darkCard,
        onSurface: AppColors.darkTextPrimary,
        error: AppColors.darkError,
        onError: AppColors.darkBackground,
        secondary: AppColors.darkTextSecondary,
        onSecondary: AppColors.darkTextPrimary,
      ),

      // ============================
      // App Bar
      // ============================
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.darkHeadline2,
        iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      ),

      // ============================
      // Text Theme
      // ============================
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.darkHeadline1,
        displayMedium: AppTextStyles.darkHeadline2,
        bodyLarge: AppTextStyles.darkBodyLarge,
        bodyMedium: AppTextStyles.darkBodyMedium,
        labelLarge: AppTextStyles.darkButton,
      ),

      // ============================
      // Buttons
      // ============================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkAccent,
          foregroundColor: AppColors.darkBackground,
          textStyle: AppTextStyles.darkButton,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkTextPrimary,
          side: const BorderSide(color: AppColors.darkDivider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // ============================
      // Input Fields
      // ============================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
        labelStyle: const TextStyle(color: AppColors.darkTextPrimary),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.darkDivider),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.darkAccent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      // ============================
      // Cards
      // ============================
      cardTheme: const CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),

      dividerColor: AppColors.darkDivider,
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
    );
  }

  // ============================
  // LIGHT THEME
  // ============================
  static ThemeData lightTheme({bool useMaterial3 = true}) {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: useMaterial3,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightAccent,
        onPrimary: AppColors.lightBackground,
        surface: AppColors.lightCard,
        onSurface: AppColors.lightTextPrimary,
        error: AppColors.lightError,
        onError: AppColors.lightBackground,
        secondary: AppColors.lightTextSecondary,
        onSecondary: AppColors.lightTextPrimary,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.lightHeadline2,
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      ),

      textTheme: const TextTheme(
        displayLarge: AppTextStyles.lightHeadline1,
        displayMedium: AppTextStyles.lightHeadline2,
        bodyLarge: AppTextStyles.lightBodyLarge,
        bodyMedium: AppTextStyles.lightBodyMedium,
        labelLarge: AppTextStyles.lightButton,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightAccent,
          foregroundColor: AppColors.lightBackground,
          textStyle: AppTextStyles.lightButton,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.lightTextPrimary,
          side: const BorderSide(color: AppColors.lightDivider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightCard,
        hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
        labelStyle: const TextStyle(color: AppColors.lightTextPrimary),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.lightDivider),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.lightAccent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      cardTheme: const CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),

      dividerColor: AppColors.lightDivider,
      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
    );
  }
}
