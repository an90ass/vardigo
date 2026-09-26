import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_dimensions.dart';
import '../enums/app_enums.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

class SquareControlButton extends StatelessWidget {
  final IconData? icon;
  final String? svgPath;
  final VoidCallback? onTap;

  const SquareControlButton({
    super.key,
    this.icon,
    this.svgPath,
    this.onTap,
  }) : assert(icon != null || svgPath != null, 'Either icon or svgPath must be provided');

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Widget iconWidget = svgPath != null
        ? SvgPicture.asset(
            svgPath!,
            width: AppDimensions.squareButtonIconSize,
            height: AppDimensions.squareButtonIconSize,
            colorFilter: ColorFilter.mode(
              colorScheme.onSurfaceVariant,
              BlendMode.srcIn,
            ),
          )
        : Icon(
            icon,
            size: AppDimensions.squareButtonIconSize,
            color: colorScheme.onSurfaceVariant,
          );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: AppDimensions.squareButtonSize,
        height: AppDimensions.squareButtonSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.squareButtonRadius),
          border: Border.all(color: colorScheme.outline, width: 1.0),
          boxShadow: AppShadows.squareButton,
        ),
        child: iconWidget,
      ),
    );
  }
}

class VardigoCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?>? onChanged;

  const VardigoCheckbox({
    super.key,
    required this.isChecked,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!isChecked) : null,
      child: Container(
        width: AppDimensions.checkboxSize,
        height: AppDimensions.checkboxSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isChecked ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.checkboxRadius),
          border: Border.all(
            color: isChecked ? colorScheme.primary : AppColors.slate300,
            width: 1.0,
          ),
        ),
        child: isChecked
            ? SvgPicture.asset(
                AppIconEnum.check.svgPath,
                width: AppDimensions.checkboxIconSize,
                height: AppDimensions.checkboxIconSize,
                colorFilter: ColorFilter.mode(
                  colorScheme.onPrimary,
                  BlendMode.srcIn,
                ),
              )
            : null,
      ),
    );
  }
}

class SortChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? svgPath;
  final VoidCallback? onTap;

  const SortChip({
    super.key,
    required this.label,
    this.icon,
    this.svgPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final Widget iconWidget = svgPath != null
        ? SvgPicture.asset(
            svgPath!,
            width: AppDimensions.sortChipIconSize,
            height: AppDimensions.sortChipIconSize,
            colorFilter: ColorFilter.mode(
              colorScheme.primary,
              BlendMode.srcIn,
            ),
          )
        : Icon(
            icon ?? Icons.unfold_more,
            size: AppDimensions.sortChipIconSize,
            color: colorScheme.primary,
          );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.sortChipHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.sortChipHorizontalPadding,
          vertical: AppDimensions.sortChipVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.sortChipRadius),
          border: Border.all(color: colorScheme.outline, width: 1.0),
          boxShadow: AppShadows.sortChip,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(width: AppDimensions.gap4),
            Text(
              label,
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
