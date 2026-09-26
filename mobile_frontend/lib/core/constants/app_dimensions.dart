import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class AppDimensions {
  static const bool enableResponsiveScaling = true;

  static const Size designSize = Size(390.0, 844.0);

  static double w(double value) => enableResponsiveScaling ? value.w : value;
  static double h(double value) => enableResponsiveScaling ? value.h : value;
  static double r(double value) => enableResponsiveScaling ? value.r : value;
  static double sp(double value) => enableResponsiveScaling ? value.sp : value;

  static const double deviceWidth = 390.0;
  static const double deviceHeight = 844.0;
  static const double outerRadius = 54.0;
  static const double innerRadius = 44.0;
  static const double bezelWidth = 11.0;

  static const double statusBarHeight = 54.0;
  static const double dynamicIslandWidth = 126.0;
  static const double dynamicIslandHeight = 37.0;
  static const double dynamicIslandTopPadding = 11.0;
  static const double dynamicIslandLensSize = 10.0;

  static const double homeIndicatorAreaHeight = 30.0;
  static const double homePillWidth = 135.0;
  static const double homePillHeight = 5.0;
  static const double homePillBottomPadding = 8.0;

  static const double pageHorizontalPadding = 20.0;
  static const double headerTopPadding = 16.0;
  static const double headerBottomPadding = 8.0;
  static const double headerHeight = 68.0;

  static const double tabBarTopMargin = 20.0;
  static const double tabBarTrackPadding = 4.0;
  static const double tabBarTrackRadius = 999.0;
  static const double tabPillPaddingHorizontal = 8.0;
  static const double tabPillPaddingVertical = 10.0;
  static const double tabPillRadius = 999.0;

  static const double subHeaderPaddingTop = 8.0;
  static const double subHeaderPaddingBottom = 8.0;
  static const double listBottomPadding = 16.0;
  static const double cardGap = 10.0;

  static const double squareButtonSize = 44.0;
  static const double squareButtonIconSize = 20.0;
  static const double squareButtonRadius = 12.0;
  static const double controlRadius = 12.0;
  static const double iconTextGap = 4.0;
  static const double logoSize = 56.0;

  static const double checkboxSize = 20.0;
  static const double checkboxRadius = 6.0;
  static const double checkboxIconSize = 12.0;

  static const double sortChipHeight = 36.0;
  static const double sortChipHorizontalPadding = 10.0;
  static const double sortChipVerticalPadding = 6.0;
  static const double sortChipIconSize = 20.0;
  static const double sortChipGap = 2.0;
  static const double sortChipRadius = 12.0;

  static const double cardRadius = 20.0;
  static const double cardPaddingHorizontal = 16.0;
  static const double cardPaddingVertical = 12.0;
  static const double cardSelectionBarWidth = 4.0;
  static const double avatarSize = 56.0;
  static const double onlineBadgeSize = 24.0;
  static const double onlineBadgeOffset = -2.0;
  static const double cardPhotoTextGap = 12.0;

  static const double metaRowItemGap = 4.0;
  static const double metaRowSectionGap = 8.0;
  static const double metaStarIconSize = 16.0;
  static const double metaShieldIconSize = 16.0;
  static const double metaPinIconSize = 14.0;
  static const double verticalDividerWidth = 1.0;
  static const double verticalDividerHeight = 11.0;

  static const double salaryBannerPaddingHorizontal = 10.0;
  static const double salaryBannerPaddingVertical = 8.0;
  static const double salaryBannerRadius = 8.0;
  static const double salaryBannerIconSize = 16.0;
  static const double salaryBannerGap = 6.0;

  static const double footerPaddingHorizontal = 24.0;
  static const double footerPaddingTop = 20.0;
  static const double footerBorderWidth = 1.0;
  static const double ctaHeight = 44.0;
  static const double ctaRadius = 10.0;
  static const double ctaIconSize = 20.0;
  static const double ctaGap = 8.0;

  static const double errorIconSize = 48.0;
  static const double errorSpacingVertical = 12.0;
  static const double errorButtonSpacing = 16.0;
  static const double gap2 = 2.0;
  static const double gap4 = 4.0;
  static const double gap6 = 6.0;
  static const double gap8 = 8.0;
  static const double gap10 = 10.0;
  static const double gap12 = 12.0;
  static const double gap14 = 14.0;
  static const double gap16 = 16.0;
  static const double gap20 = 20.0;
  static const double gap24 = 24.0;
  static const double gap40 = 40.0;

  static const double radius6 = 6.0;
  static const double radius8 = 8.0;
  static const double radius10 = 10.0;
  static const double radius12 = 12.0;
  static const double radius16 = 16.0;
  static const double radius20 = 20.0;
  static const double radius24 = 24.0;
  static const double radius26 = 26.0;
  static const double radius28 = 28.0;
  static const double radius54 = 54.0;

  static const double iconSize12 = 12.0;
  static const double iconSize14 = 14.0;
  static const double iconSize16 = 16.0;
  static const double iconSize20 = 20.0;
  static const double iconSize24 = 24.0;
  static const double iconSize32 = 32.0;

  static const double cardPadding = 16.0;
  static const double controlButtonSize = 44.0;
  static const double buttonHeight36 = 36.0;

  static const double bottomSheetHandleWidth = 40.0;
  static const double bottomSheetHandleHeight = 4.0;
  static const double bottomSheetHandleMargin = 16.0;
  static const double bottomSheetRadius = 20.0;
}
