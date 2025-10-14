import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Common font family (you can change to your favorite Google Font)
  static const String _fontFamily = 'Poppins';

  // ---------------------------
  // DARK TEXT STYLES
  // ---------------------------
  static const TextStyle darkHeadline1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.darkTextPrimary,
  );

  static const TextStyle darkHeadline2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.darkTextPrimary,
  );

  static const TextStyle darkBodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    color: AppColors.darkTextPrimary,
  );

  static const TextStyle darkBodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    color: AppColors.darkTextSecondary,
  );

  static const TextStyle darkButton = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.darkBackground,
  );

  // ---------------------------
  // LIGHT TEXT STYLES
  // ---------------------------
  static const TextStyle lightHeadline1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.lightTextPrimary,
  );

  static const TextStyle lightHeadline2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.lightTextPrimary,
  );

  static const TextStyle lightBodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    color: AppColors.lightTextPrimary,
  );

  static const TextStyle lightBodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    color: AppColors.lightTextSecondary,
  );

  static const TextStyle lightButton = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.lightBackground,
  );
}
