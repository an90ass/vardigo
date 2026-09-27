import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/custom_card_container.dart';

class RoleCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isHighlighted;

  const RoleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.975).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final customColors = context.customColors;

    final cardBg = widget.isHighlighted
        ? colorScheme.primary.withValues(alpha: 0.07)
        : null;
    final iconContainerColor = widget.isHighlighted
        ? colorScheme.primary
        : customColors.selectedCardBg;
    final iconColor = widget.isHighlighted ? Colors.white : colorScheme.primary;
    final titleColor = widget.isHighlighted
        ? colorScheme.primary
        : colorScheme.onSurface;
    final borderColor = widget.isHighlighted
        ? colorScheme.primary.withValues(alpha: 0.25)
        : Colors.transparent;

    return GestureDetector(
      onTapDown: (_) => _pressController.forward(),
      onTapUp: (_) {
        _pressController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _pressController.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: CustomCardContainer(
          padding: const EdgeInsets.all(AppDimensions.pageHorizontalPadding),
          color: cardBg,
          border: Border.all(
            color: borderColor,
            width: AppDimensions.loginCardBorderWidth,
          ),
          child: Row(
            children: [
              Container(
                width: AppDimensions.squareButtonSize,
                height: AppDimensions.squareButtonSize,
                decoration: BoxDecoration(
                  color: iconContainerColor,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.controlRadius),
                  boxShadow: widget.isHighlighted
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.30),
                            blurRadius: AppDimensions.loginIconShadowBlur,
                            offset: const Offset(
                              0,
                              AppDimensions.loginIconShadowOffsetY,
                            ),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  widget.icon,
                  color: iconColor,
                  size: AppDimensions.squareButtonIconSize,
                ),
              ),
              const SizedBox(width: AppDimensions.cardPhotoTextGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.iconTextGap),
                    Text(
                      widget.subtitle,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: widget.isHighlighted
                    ? colorScheme.primary.withValues(alpha: 0.6)
                    : customColors.slate500,
                size: AppDimensions.squareButtonIconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
