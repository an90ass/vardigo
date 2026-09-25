import 'package:flutter/material.dart';


abstract final class AppShadows {
  // Card normal
  static const List<BoxShadow> cardNormal = [
    BoxShadow(
      color: Color.fromRGBO(36, 61, 130, 0.04),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  // Card selected
  static const List<BoxShadow> cardSelected = [
    BoxShadow(
      color: Color.fromRGBO(36, 61, 130, 0.04),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  // Tab active (Eşleşen Personeller)
  static const List<BoxShadow> tabActiveCandidates = [
    BoxShadow(
      color: Color.fromRGBO(14, 18, 27, 0.06),
      blurRadius: 5,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color.fromRGBO(14, 18, 27, 0.03),
      blurRadius: 2,
      offset: Offset(0, 2),
    ),
  ];

  // Tab active (Görüşme Talepleri)
  static const List<BoxShadow> tabActiveOffers = [
    BoxShadow(
      color: Color.fromRGBO(14, 18, 27, 0.06),
      blurRadius: 10,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color.fromRGBO(14, 18, 27, 0.03),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  // Square button
  static const List<BoxShadow> squareButton = [
    BoxShadow(
      color: Color.fromRGBO(10, 13, 20, 0.08),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  // Sort chip
  static const List<BoxShadow> sortChip = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  // Phone Bezel
  static const List<BoxShadow> bezel = [
    BoxShadow(
      color: Color.fromRGBO(15, 18, 27, 0.22),
      blurRadius: 48,
      offset: Offset(0, 28),
    ),
  ];
}
