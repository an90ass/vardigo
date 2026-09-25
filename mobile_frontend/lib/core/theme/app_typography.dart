import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';


abstract final class AppTypography {
  static const String fontFamily = 'Urbanist';

  // Helper factory for base Urbanist style with proper font fallbacks
  static TextStyle _urbanist({
    required double fontSize,
    required FontWeight fontWeight,
    double? height,
    double? letterSpacing,
    Color? color,
  }) {
    return GoogleFonts.urbanist(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  // 17 / 700 / 22, tracking -0.3, strong (9:41)
  static final TextStyle statusTime = _urbanist(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 22 / 17,
    letterSpacing: -0.3,
    color: AppColors.strong,
  );

  // 20 / 600 / 28, tracking 0, slate-700 (Görüşme Talepleri)
  static final TextStyle title20 = _urbanist(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    letterSpacing: 0,
    color: AppColors.slate700,
  );

  // 18 / 500 / 24, tracking -0.27, slate-700 (isim, ünvan)
  static final TextStyle title18 = _urbanist(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 24 / 18,
    letterSpacing: -0.27,
    color: AppColors.slate700,
  );

  // 16 / 500 / 24, tracking -0.176, slate-700 (Eşleşen Personeller)
  static final TextStyle title16Med = _urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    letterSpacing: -0.176,
    color: AppColors.slate700,
  );

  // 16 / 600 / 24, tracking -0.176, primary (N kişi seçildi)
  static final TextStyle title16SemiPrimary = _urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
    letterSpacing: -0.176,
    color: AppColors.primary,
  );

  // 16 / 600 / 24, tracking -0.176, green (45.000)
  static final TextStyle title16SemiGreen = _urbanist(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
    letterSpacing: -0.176,
    color: AppColors.green,
  );

  // 13 / 400 / 20, tracking -0.078, slate-500/80 (26 personel bulundu)
  static final TextStyle caption13 = _urbanist(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 20 / 13,
    letterSpacing: -0.078,
    color: AppColors.slate500.withValues(alpha: 0.8),
  );

  // 12 / 500 / 16, slate-700 (puan, katılım, km)
  static final TextStyle caption12Med = _urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: AppColors.slate700,
  );

  // 12 / 400 / 16, #7B7B7B (işletme)
  static final TextStyle caption12Company = _urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    color: AppColors.gray500,
  );

  // 12 / 500 / 16, white (aktif tab)
  static final TextStyle caption12TabActive = _urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: AppColors.white,
  );

  // 12 / 500 / 16, slate-500 (pasif tab)
  static final TextStyle caption12TabInactive = _urbanist(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    color: AppColors.slate500,
  );

  // 14 / 500 / 20, tracking -0.084 (butonlar, rozetler)
  static final TextStyle label14 = _urbanist(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: -0.084,
    color: AppColors.white,
  );

  // 13 / 500, tracking -0.084, strong (aktif tab)
  static final TextStyle tab13Active = _urbanist(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.084,
    color: AppColors.strong,
  );

  // 13 / 500, tracking -0.084, soft (pasif tab)
  static final TextStyle tab13Inactive = _urbanist(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.084,
    color: AppColors.soft,
  );
}
