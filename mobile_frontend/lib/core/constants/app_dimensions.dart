import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



// Can be toggled on/off with [enableResponsiveScaling] without touching any UI widgets.
abstract final class AppDimensions {

  // Set to false to instantly revert to raw native logical pixels.
  // I considered that the design needs to be responsive nowadays.
  static const bool enableResponsiveScaling = true;

  /// Logical Design Canvas Dimensions (iPhone 14/15)
  static const Size designSize = Size(390.0, 844.0);

  // Scaled adapter functions
  static double w(double value) => enableResponsiveScaling ? value.w : value;
  static double h(double value) => enableResponsiveScaling ? value.h : value;
  static double r(double value) => enableResponsiveScaling ? value.r : value;
  static double sp(double value) => enableResponsiveScaling ? value.sp : value;

  // Canvas Viewport (iPhone 14/15)
  static const double deviceWidth = 390.0;
  static const double deviceHeight = 844.0;
  static const double outerRadius = 54.0;
  static const double innerRadius = 44.0;
  static const double bezelWidth = 11.0;

  // Status Bar & Dynamic Island
  static const double statusBarHeight = 54.0;
  static const double dynamicIslandWidth = 126.0;
  static const double dynamicIslandHeight = 37.0;
  static const double dynamicIslandTopPadding = 11.0;
  static const double dynamicIslandLensSize = 10.0;

  // Home Pill Indicator
  static const double homeIndicatorAreaHeight = 30.0;
  static const double homePillWidth = 135.0;
  static const double homePillHeight = 5.0;
  static const double homePillBottomPadding = 8.0;

  // Page Margins & Spacings
  static const double pageHorizontalPadding = 20.0;
  static const double iconTextGap = 4.0;
  static const double cardPhotoTextGap = 12.0;

  // Card & Control Radii
  static const double cardRadius = 20.0;
  static const double controlRadius = 12.0;
  static const double checkboxRadius = 6.0;

  // Control Element Sizes
  static const double squareButtonSize = 44.0;
  static const double squareButtonIconSize = 20.0;

  static const double checkboxSize = 20.0;

  static const double sortChipHeight = 36.0;
  static const double sortChipHorizontalPadding = 10.0;
  static const double sortChipVerticalPadding = 6.0;
  static const double sortChipIconSize = 20.0;
  static const double sortChipGap = 2.0;

  static const double avatarSize = 56.0;
  static const double onlineBadgeSize = 24.0;
  static const double logoSize = 56.0;
}
