import 'package:flutter/material.dart';


abstract final class AppColors {
  // Primary
  static const Color primary = Color(0xFF335CFF);
  static const Color primarySoft = Color(0xFF3485FF);
  static const Color primaryLight = Color(0xFFD5E2FF);
  static const Color primaryLighter = Color(0xFFEBF1FF);
  static const Color primaryDarkest = Color(0xFF1F3BAD);

  // Neutrals / Typography
  static const Color strong = Color(0xFF171717);
  static const Color slate700 = Color(0xFF2B303B);
  static const Color slate600 = Color(0xFF525866);
  static const Color slate500 = Color(0xFF717784);
  static const Color gray500 = Color(0xFF7B7B7B);
  static const Color sub = Color(0xFF5C5C5C);
  static const Color soft = Color(0xFFA3A3A3);
  static const Color soft400 = Color(0xFFA3A3A3);

  // Surfaces & Dividers
  static const Color white = Color(0xFFFFFFFF);
  static const Color weak = Color(0xFFFBFBFB);
  static const Color weak50 = Color(0xFFF7F7F7);
  static const Color slate50 = Color(0xFFF5F7FA);
  static const Color slate100 = Color(0xFFF2F5F8);
  static const Color slate200 = Color(0xFFEAECF0);
  static const Color stroke = Color(0xFFEBEBEB);
  static const Color slate300 = Color(0xFFCACFD8);

  // Feedback & Status
  static const Color green = Color(0xFF1DAF61);
  static const Color greenDark = Color(0xFF178C4E);
  static const Color greenLighter = Color(0xFFE3F7EC);
  static const Color error = Color(0xFFFB3748);
  static const Color errorSoft = Color(0x1AFB3748); // #FB37481A (10% alpha)
  static const Color warning = Color(0xFFFA7319);

  // Device Frame Elements
  static const Color bezel = Color(0xFF0B0B0D);
  static const Color island = Color(0xFF000000);
  static const Color islandLens = Color(0xFF1C1C1E);
  static const Color islandRing = Color(0xFF2A2A2C);
  static const Color homePill = Color(0xFFB9C0C9);
}
