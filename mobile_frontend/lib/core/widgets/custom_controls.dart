import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_shadows.dart';


class SquareControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const SquareControlButton({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.squareButtonSize,
        height: AppDimensions.squareButtonSize,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.controlRadius),
          border: Border.all(color: colorScheme.outline, width: 1.0),
          boxShadow: AppShadows.squareButton,
        ),
        child: Icon(
          icon,
          size: AppDimensions.squareButtonIconSize,
          color: colorScheme.onSurfaceVariant, // #525866
        ),
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
        decoration: BoxDecoration(
          color: isChecked ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.checkboxRadius),
          border: Border.all(
            color: isChecked ? colorScheme.primary : colorScheme.outlineVariant, // #CACFD8
            width: 1.0,
          ),
        ),
        child: isChecked
            ? Icon(
                Icons.check,
                size: 14,
                color: colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }
}


class SortChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const SortChip({
    super.key,
    required this.label,
    this.icon = Icons.unfold_more,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
          borderRadius: BorderRadius.circular(AppDimensions.controlRadius),
          border: Border.all(color: colorScheme.outline, width: 1.0),
          boxShadow: AppShadows.sortChip,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: AppDimensions.sortChipGap),
            Icon(
              icon,
              size: AppDimensions.sortChipIconSize,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
