import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/theme_context_ext.dart';

class LoginHeader extends StatefulWidget {
  const LoginHeader({super.key});

  @override
  State<LoginHeader> createState() => _LoginHeaderState();
}

class _LoginHeaderState extends State<LoginHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final customColors = context.customColors;

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: Column(
          children: [
            Container(
              width: AppDimensions.loginLogoSize,
              height: AppDimensions.loginLogoSize,
              padding: const EdgeInsets.all(AppDimensions.loginLogoPadding),
              child: Image.asset(
                AppImageEnum.vardigoLogo.path,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: AppDimensions.gap4),
            Text(
              AppStrings.appName,
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: AppDimensions.loginTitleFontSize,
                letterSpacing: AppDimensions.loginTitleLetterSpacing,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.gap6),
            Text(
              AppStrings.loginTitleSubtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: customColors.slate500,
                fontWeight: FontWeight.w400,
                fontSize: AppDimensions.loginTaglineFontSize,
                letterSpacing: AppDimensions.loginTaglineLetterSpacing,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
