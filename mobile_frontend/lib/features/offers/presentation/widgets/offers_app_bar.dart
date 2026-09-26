import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/custom_controls.dart';

class OffersAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int pendingCount;
  final OfferStatusFilter activeFilter;
  final VoidCallback? onBackTap;

  const OffersAppBar({
    super.key,
    required this.pendingCount,
    required this.activeFilter,
    this.onBackTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72.0);

  String _getSubtitle() {
    switch (activeFilter) {
      case OfferStatusFilter.pending:
        return AppStrings.pendingOffersSubtitle(pendingCount);
      case OfferStatusFilter.answered:
        return AppStrings.answeredOffersSubtitle;
      case OfferStatusFilter.expired:
        return AppStrings.expiredOffersSubtitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textTheme = context.textTheme;

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.pageHorizontalPadding,
        AppDimensions.gap12,
        AppDimensions.pageHorizontalPadding,
        AppDimensions.gap8,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SquareControlButton(
              svgPath: AppIconEnum.back.svgPath,
              onTap: onBackTap ?? () => Navigator.maybePop(context),
            ),
            const SizedBox(width: AppDimensions.gap12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.interviewOffersTitle,
                    style: textTheme.headlineMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.strong,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getSubtitle(),
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.gray500,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
