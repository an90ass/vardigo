import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/theme_context_ext.dart';

class CandidatesBottomBar extends StatelessWidget {
  final int selectedCount;
  final bool isSubmitting;
  final VoidCallback? onSubmit;

  const CandidatesBottomBar({
    super.key,
    required this.selectedCount,
    this.isSubmitting = false,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFBFBFB),
        border: Border(
          top: BorderSide(
            color: Color(0xFFEBEBEB),
            width: AppDimensions.footerBorderWidth,
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.footerPaddingHorizontal,
        AppDimensions.footerPaddingTop,
        AppDimensions.footerPaddingHorizontal,
        bottomInset > 0 ? bottomInset + AppDimensions.ctaGap : AppDimensions.footerPaddingTop,
      ),
      child: SizedBox(
        width: double.infinity,
        height: AppDimensions.ctaHeight,
        child: ElevatedButton(
          onPressed: selectedCount > 0 && !isSubmitting ? onSubmit : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.45),
            disabledForegroundColor: colorScheme.onPrimary.withValues(alpha: 0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.ctaRadius),
            ),
            elevation: 0,
            padding: EdgeInsets.zero,
          ),
          child: isSubmitting
              ? _buildLoadingIndicator(context)
              : _buildButtonContent(context),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return SizedBox(
      width: AppDimensions.ctaIconSize,
      height: AppDimensions.ctaIconSize,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        color: context.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppIconEnum.send.svgPath,
          width: AppDimensions.ctaIconSize,
          height: AppDimensions.ctaIconSize,
          colorFilter: ColorFilter.mode(
            colorScheme.onPrimary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: AppDimensions.ctaGap),
        Text(
          'Görüşme Talebi Gönder ($selectedCount)',
          style: textTheme.labelLarge?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
