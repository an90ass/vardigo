import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_shadows.dart';


class CustomCardContainer extends StatelessWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Border? border;

  const CustomCardContainer({
    super.key,
    required this.child,
    this.isSelected = false,
    this.onTap,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const radius = BorderRadius.all(Radius.circular(AppDimensions.cardRadius));

    final effectiveColor = color ??
        (isSelected ? colorScheme.primaryContainer : colorScheme.surface);
    final effectiveBorder = border ??
        (isSelected
            ? null
            : Border.all(color: colorScheme.outline, width: 1.0));

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: effectiveColor,
            borderRadius: radius,
            border: effectiveBorder,
            boxShadow: isSelected
                ? AppShadows.cardSelected
                : AppShadows.cardNormal,
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              children: [
         
                if (isSelected)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: 4.0,
                    child: Container(
                      color: colorScheme.primary,
                    ),
                  ),

                // Card Content Body
                Padding(
                  padding: padding,
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
