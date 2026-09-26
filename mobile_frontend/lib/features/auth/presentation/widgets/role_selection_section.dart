import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../bloc/auth_bloc.dart';
import 'role_card.dart';

class RoleSelectionSection extends StatefulWidget {
  const RoleSelectionSection({super.key});

  @override
  State<RoleSelectionSection> createState() => _RoleSelectionSectionState();
}

class _RoleSelectionSectionState extends State<RoleSelectionSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.10),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = context.customColors;
    final textTheme = context.textTheme;

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.gap14),
              child: Text(
                AppStrings.loginSubtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: customColors.slate600,
                  fontWeight: FontWeight.w600,
                  fontSize: AppDimensions.loginSubtitleFontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            RoleCard(
              title: AppStrings.employerLoginTitle,
              subtitle: AppStrings.employerLoginSubtitle,
              icon: Icons.storefront_outlined,
              isHighlighted: true,
              onTap: () {
                context.read<AuthBloc>().add(
                      const LoginRequested(UserRole.employer),
                    );
              },
            ),
            const SizedBox(height: AppDimensions.gap12),
            RoleCard(
              title: AppStrings.workerLoginTitle,
              subtitle: AppStrings.workerLoginSubtitle,
              icon: Icons.person_outline,
              onTap: () {
                context.read<AuthBloc>().add(
                      const LoginRequested(UserRole.worker),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
