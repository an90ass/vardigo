import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_context_ext.dart';

class LoginLoadingView extends StatelessWidget {
  final bool isCheckingSession;

  const LoginLoadingView({
    super.key,
    this.isCheckingSession = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final customColors = context.customColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.pageHorizontalPadding * 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: AppDimensions.loginLoadingIndicatorSize,
              height: AppDimensions.loginLoadingIndicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: AppDimensions.loginLoadingStrokeWidth,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.cardPhotoTextGap),
            Text(
              isCheckingSession
                  ? AppStrings.checkingSession
                  : AppStrings.loggingIn,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.iconTextGap),
            Text(
              isCheckingSession
                  ? AppStrings.sessionVerifying
                  : AppStrings.profilePreparing,
              style: textTheme.bodySmall?.copyWith(
                color: customColors.slate500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
