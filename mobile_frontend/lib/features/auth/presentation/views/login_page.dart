import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/login_header.dart';
import '../widgets/login_loading_view.dart';
import '../widgets/role_selection_section.dart';

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
        return CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false, 
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.pageHorizontalPadding,
                  vertical: AppDimensions.gap16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    const LoginHeader(),
                    
                    if (state is! Unauthenticated && state is! AuthError)
                      Center(
                        child: LoginLoadingView(
                          isCheckingSession: state is AuthInitial,
                        ),
                      )
                    else
                      const RoleSelectionSection(),
                    const  SizedBox(height: AppDimensions.gap16),
                    const _LoginFooter(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  ),
); }

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

class _LoginFooter extends StatelessWidget {
  const _LoginFooter();

  @override
  Widget build(BuildContext context) {
    final customColors = context.customColors;
    final textTheme = context.textTheme;

    return Text(
      AppStrings.appCopyright,
      style: textTheme.bodySmall?.copyWith(
        color: customColors.slate500,
        fontWeight: FontWeight.w600,
        letterSpacing: AppDimensions.loginFooterLetterSpacing,
      ),
      textAlign: TextAlign.center,
    );
  }
}
