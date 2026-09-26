import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/theme_context_ext.dart';

class CandidatesTabBar extends StatelessWidget {
  final CandidateTab activeTab;
  final int totalPerfect;
  final int totalSimilar;
  final ValueChanged<CandidateTab> onTabChanged;

  const CandidatesTabBar({
    super.key,
    required this.activeTab,
    required this.totalPerfect,
    required this.totalSimilar,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.tabBarTrackPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5F8),
        borderRadius: BorderRadius.circular(AppDimensions.tabBarTrackRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              context: context,
              title: AppStrings.perfectMatchTab(totalPerfect),
              isActive: activeTab == CandidateTab.perfect,
              onTap: () => onTabChanged(CandidateTab.perfect),
            ),
          ),
          Expanded(
            child: _buildTab(
              context: context,
              title: AppStrings.similarMatchTab(totalSimilar),
              isActive: activeTab == CandidateTab.similar,
              onTap: () => onTabChanged(CandidateTab.similar),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final customColors = context.customColors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.fastOutSlowIn,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.tabPillPaddingHorizontal,
          vertical: AppDimensions.tabPillPaddingVertical,
        ),
        decoration: BoxDecoration(
          color: isActive ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.tabPillRadius),
          boxShadow: isActive ? AppShadows.tabActiveCandidates : null,
        ),
        child: Text(
          title,
          style: textTheme.bodySmall?.copyWith(
            color: isActive ? colorScheme.onPrimary : customColors.slate500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
