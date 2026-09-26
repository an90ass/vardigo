import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/custom_card_container.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: _handleAuthStateListener,
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.pageHorizontalPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _LoginHeader(),
                    const SizedBox(height: AppDimensions.pageHorizontalPadding * 2),
                    if (state is! Unauthenticated && state is! AuthError)
                      _LoadingView(isCheckingSession: state is AuthInitial)
                    else
                      const _RoleSelectionSection(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleAuthStateListener(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      final destination = state.role == UserRole.employer
          ? RouteNames.employerCandidates
          : RouteNames.workerOffers;

      Navigator.pushReplacementNamed(context, destination);
    } else if (state is AuthError) {
      final errorColor = context.colorScheme.error;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Column(
      children: [
        Text(
          AppStrings.loginTitle,
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.iconTextGap * 2),
        Text(
          AppStrings.loginSubtitle,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  final bool isCheckingSession;

  const _LoadingView({this.isCheckingSession = false});

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
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
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

class _RoleSelectionSection extends StatelessWidget {
  const _RoleSelectionSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RoleCard(
          title: AppStrings.employerLoginTitle,
          subtitle: AppStrings.employerLoginSubtitle,
          icon: Icons.storefront_outlined,
          onTap: () {
            context.read<AuthBloc>().add(
                  const LoginRequested(UserRole.employer),
                );
          },
        ),
        const SizedBox(height: AppDimensions.cardPhotoTextGap),
        _RoleCard(
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
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final customColors = context.customColors;

    return CustomCardContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(AppDimensions.pageHorizontalPadding),
      child: Row(
        children: [
          Container(
            width: AppDimensions.squareButtonSize,
            height: AppDimensions.squareButtonSize,
            decoration: BoxDecoration(
              color: customColors.selectedCardBg,
              borderRadius: BorderRadius.circular(AppDimensions.controlRadius),
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: AppDimensions.squareButtonIconSize,
            ),
          ),
          const SizedBox(width: AppDimensions.cardPhotoTextGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.iconTextGap),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: customColors.slate500,
            size: AppDimensions.squareButtonIconSize,
          ),
        ],
      ),
    );
  }
}
