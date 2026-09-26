import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/theme_context_ext.dart';

class OffersTabBar extends StatelessWidget {
  final OfferStatusFilter activeFilter;
  final ValueChanged<OfferStatusFilter> onFilterChanged;

  const OffersTabBar({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.tabBarTrackPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(AppDimensions.tabBarTrackRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              context: context,
              title: AppStrings.tabPending,
              isActive: activeFilter == OfferStatusFilter.pending,
              onTap: () => onFilterChanged(OfferStatusFilter.pending),
            ),
          ),
          const SizedBox(width: AppDimensions.gap4),
          Expanded(
            child: _buildTab(
              context: context,
              title: AppStrings.tabAnswered,
              isActive: activeFilter == OfferStatusFilter.answered,
              onTap: () => onFilterChanged(OfferStatusFilter.answered),
            ),
          ),
          const SizedBox(width: AppDimensions.gap4),
          Expanded(
            child: _buildTab(
              context: context,
              title: AppStrings.tabExpired,
              isActive: activeFilter == OfferStatusFilter.expired,
              onTap: () => onFilterChanged(OfferStatusFilter.expired),
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
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.tabPillRadius),
          boxShadow: isActive ? AppShadows.tabActiveOffers : null,
        ),
        child: Text(
          title,
          style: textTheme.bodySmall?.copyWith(
            color: isActive ? const Color(0xFF171717) : customColors.slate500,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
