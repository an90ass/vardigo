import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/custom_controls.dart';

class CandidatesAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int totalCount;
  final VoidCallback? onBackTap;
  final VoidCallback? onHelpTap;

  const CandidatesAppBar({
    super.key,
    required this.totalCount,
    this.onBackTap,
    this.onHelpTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppDimensions.headerHeight);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textTheme = context.textTheme;

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.pageHorizontalPadding,
        AppDimensions.headerTopPadding,
        AppDimensions.pageHorizontalPadding,
        AppDimensions.headerBottomPadding,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SquareControlButton(
              svgPath: AppIconEnum.back.svgPath,
              onTap: onBackTap ?? () => Navigator.maybePop(context),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$totalCount personel bulundu',
                    style: textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Eşleşen Personeller',
                    style: textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SquareControlButton(
              svgPath: AppIconEnum.help.svgPath,
              onTap: onHelpTap,
            ),
          ],
        ),
      ),
    );
  }
}
