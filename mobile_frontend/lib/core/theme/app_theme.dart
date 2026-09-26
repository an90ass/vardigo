import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import '../constants/app_dimensions.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.weak,
      primaryColor: AppColors.primary,
      fontFamily: GoogleFonts.urbanist().fontFamily,
      colorScheme: _colorScheme,
      textTheme: GoogleFonts.urbanistTextTheme(_textTheme),
      appBarTheme: _appBarTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      dividerTheme: _dividerTheme,
      extensions: const [AppThemeColors.light],
    );
  }


  static const ColorScheme _colorScheme = ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.primarySoft,
    surface: AppColors.white,
    error: AppColors.error,
    onPrimary: AppColors.white,
    onSurface: AppColors.strong,
    onSurfaceVariant: AppColors.slate600,
    outline: AppColors.slate200,
    outlineVariant: AppColors.stroke,
  );


  static TextTheme get _textTheme => TextTheme(
        headlineMedium: AppTypography.title20,
        titleLarge: AppTypography.title18,
        titleMedium: AppTypography.title16Med,
        titleSmall: AppTypography.title16SemiPrimary,
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

@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color green;
  final Color greenLight;
  final Color greenBadge;
  final Color warning;
  final Color warningLight;
  final Color purple;
  final Color star;
  final Color slate500;
  final Color slate600;
  final Color slate700;
  final Color selectedCardBg;
  final Color salaryBarBg;

  const AppThemeColors({
    required this.green,
    required this.greenLight,
    required this.greenBadge,
    required this.warning,
    required this.warningLight,
    required this.purple,
    required this.star,
    required this.slate500,
    required this.slate600,
    required this.slate700,
    required this.selectedCardBg,
    required this.salaryBarBg,
  });

  static const light = AppThemeColors(
    green: AppColors.green,
    greenLight: Color(0xFFF0FDF4),
    greenBadge: Color(0xFFDCFCE7),
    warning: AppColors.warning,
    warningLight: Color(0xFFFFF7ED),
    purple: Color(0xFF7D52F4),
    star: Color(0xFFF59E0B),
    slate500: AppColors.slate500,
    slate600: AppColors.slate600,
    slate700: AppColors.slate700,
    selectedCardBg: Color(0xFFEBF1FF),
    salaryBarBg: Color(0xFFF7F7F7),
  );

  @override
  AppThemeColors copyWith({
    Color? green,
    Color? greenLight,
    Color? greenBadge,
    Color? warning,
    Color? warningLight,
    Color? purple,
    Color? star,
    Color? slate500,
    Color? slate600,
    Color? slate700,
    Color? selectedCardBg,
    Color? salaryBarBg,
  }) {
    return AppThemeColors(
      green: green ?? this.green,
      greenLight: greenLight ?? this.greenLight,
      greenBadge: greenBadge ?? this.greenBadge,
      warning: warning ?? this.warning,
      warningLight: warningLight ?? this.warningLight,
      purple: purple ?? this.purple,
      star: star ?? this.star,
      slate500: slate500 ?? this.slate500,
      slate600: slate600 ?? this.slate600,
      slate700: slate700 ?? this.slate700,
      selectedCardBg: selectedCardBg ?? this.selectedCardBg,
      salaryBarBg: salaryBarBg ?? this.salaryBarBg,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      green: Color.lerp(green, other.green, t)!,
      greenLight: Color.lerp(greenLight, other.greenLight, t)!,
      greenBadge: Color.lerp(greenBadge, other.greenBadge, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      star: Color.lerp(star, other.star, t)!,
      slate500: Color.lerp(slate500, other.slate500, t)!,
      slate600: Color.lerp(slate600, other.slate600, t)!,
      slate700: Color.lerp(slate700, other.slate700, t)!,
      selectedCardBg: Color.lerp(selectedCardBg, other.selectedCardBg, t)!,
      salaryBarBg: Color.lerp(salaryBarBg, other.salaryBarBg, t)!,
    );
  }
}

