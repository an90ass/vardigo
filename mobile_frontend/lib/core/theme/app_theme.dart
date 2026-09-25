import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import '../constants/app_dimensions.dart';


abstract final class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.weak,
      primaryColor: AppColors.primary,
      fontFamily: AppTypography.fontFamily,
      colorScheme: _colorScheme,
      textTheme: _textTheme,
      appBarTheme: _appBarTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      dividerTheme: _dividerTheme,
    );
  }


  static const ColorScheme _colorScheme = ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.primarySoft,
    surface: AppColors.white,
    error: AppColors.error,
    onPrimary: AppColors.white,
    onSurface: AppColors.strong,
    outline: AppColors.slate200,
    outlineVariant: AppColors.stroke,
  );


  static TextTheme get _textTheme => TextTheme(
        headlineMedium: AppTypography.title20,
        titleLarge: AppTypography.title18,
        titleMedium: AppTypography.title16Med,
        titleSmall: AppTypography.tab13Active,
        bodyLarge: AppTypography.label14,
        bodyMedium: AppTypography.caption13,
        bodySmall: AppTypography.caption12Med,
        labelLarge: AppTypography.label14,
        labelSmall: AppTypography.caption12Company,
      );


  static AppBarTheme get _appBarTheme => AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.slate700),
        titleTextStyle: AppTypography.title20,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      );


  static CardThemeData get _cardTheme => CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          side: const BorderSide(color: AppColors.slate200, width: 1.0),
        ),
        margin: EdgeInsets.zero,
      );


  static ElevatedButtonThemeData get _elevatedButtonTheme => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.controlRadius),
          ),
          textStyle: AppTypography.label14,
        ),
      );

  static OutlinedButtonThemeData get _outlinedButtonTheme => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.slate700,
          side: const BorderSide(color: AppColors.slate200, width: 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.controlRadius),
          ),
          textStyle: AppTypography.label14.copyWith(color: AppColors.slate700),
        ),
      );


  // ==========================================
  static const DividerThemeData _dividerTheme = DividerThemeData(
    color: AppColors.stroke,
    thickness: 1.0,
    space: 1.0,
  );
}
