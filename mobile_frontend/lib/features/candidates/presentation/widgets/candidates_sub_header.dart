import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/theme_context_ext.dart';

class CandidatesSubHeader extends StatelessWidget {
  final int selectedCount;
  final CandidateSort activeSort;
  final ValueChanged<CandidateSort> onSortChanged;

  const CandidatesSubHeader({
    super.key,
    required this.selectedCount,
    required this.activeSort,
    required this.onSortChanged,
  });

  String get _sortLabel {
    switch (activeSort) {
      case CandidateSort.near:
        return AppStrings.sortNear;
      case CandidateSort.rating:
        return AppStrings.sortRating;
      case CandidateSort.recommended:
        return AppStrings.sortRecommended;
    }
  }

  void _showSortBottomSheet(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.bottomSheetRadius),
        ),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.bottomSheetHandleMargin,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppDimensions.bottomSheetHandleWidth,
                  height: AppDimensions.bottomSheetHandleHeight,
                  margin: const EdgeInsets.only(
                    bottom: AppDimensions.bottomSheetHandleMargin,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.bottomSheetHandleHeight / 2,
                    ),
                  ),
                ),
                Text(
                  AppStrings.sortBottomSheetTitle,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.cardPhotoTextGap),
                _buildSortOption(ctx, AppStrings.sortOptionRecommended, CandidateSort.recommended),
                _buildSortOption(ctx, AppStrings.sortOptionNear, CandidateSort.near),
                _buildSortOption(ctx, AppStrings.sortOptionRating, CandidateSort.rating),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String label,
    CandidateSort sort,
  ) {
    final isSelected = activeSort == sort;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return ListTile(
      title: Text(
        label,
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_rounded,
              color: colorScheme.primary,
              size: AppDimensions.squareButtonIconSize,
            )
          : null,
      onTap: () {
        Navigator.pop(context);
        if (activeSort == sort) {
          onSortChanged(CandidateSort.recommended);
        } else {
          onSortChanged(sort);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimensions.subHeaderPaddingTop,
        bottom: AppDimensions.subHeaderPaddingBottom,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.personSelected(selectedCount),
            style: textTheme.titleSmall,
          ),
          GestureDetector(
            onTap: () => _showSortBottomSheet(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: AppDimensions.sortChipHeight,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.sortChipHorizontalPadding,
                vertical: AppDimensions.sortChipVerticalPadding,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(AppDimensions.sortChipRadius),
                border: Border.all(
                  color: colorScheme.outline,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppIconEnum.sort.svgPath,
                    width: AppDimensions.sortChipIconSize,
                    height: AppDimensions.sortChipIconSize,
                    colorFilter: ColorFilter.mode(
                      colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.sortChipGap),
                  Text(
                    _sortLabel,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
