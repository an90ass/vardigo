import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../bloc/candidate_bloc.dart';
import '../widgets/candidate_card.dart';
import '../widgets/candidates_app_bar.dart';
import '../widgets/candidates_bottom_bar.dart';
import '../widgets/candidates_sub_header.dart';
import '../widgets/candidates_tab_bar.dart';

class EmployerCandidatesPage extends StatelessWidget {
  const EmployerCandidatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CandidateBloc, CandidateState>(
      listener: _handleMessages,
      builder: _buildScaffold,
    );
  }

  void _handleMessages(BuildContext context, CandidateState state) {
    final colorScheme = context.colorScheme;
    final customColors = context.customColors;

    if (state.errorMessage != null) {
      _showSnackbar(
        context: context,
        message: state.errorMessage!,
        backgroundColor: colorScheme.error,
      );
      context.read<CandidateBloc>().add(const ClearCandidateMessages());
    }

    if (state.successMessage != null) {
      _showSnackbar(
        context: context,
        message: state.successMessage!,
        backgroundColor: customColors.green,
      );
      context.read<CandidateBloc>().add(const ClearCandidateMessages());
    }
  }

  void _showSnackbar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, CandidateState state) {
    final int displayCount = state.totalPerfect > 0
        ? state.totalPerfect
        : state.candidates.length;

    return Scaffold(
      appBar: CandidatesAppBar(
        totalCount: displayCount,
        onBackTap: () => _onBackPressed(context),
        onHelpTap: () => _onHelpPressed(context),
      ),
      bottomNavigationBar: CandidatesBottomBar(
        selectedCount: state.selectedCount,
        isSubmitting: state.isSubmittingOffers,
        onSubmit: () => _onSubmitPressed(context),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTabBar(context, state),
            _buildSubHeader(context, state),
            Expanded(child: _buildBody(context, state)),
          ],
        ),
      ),
    );
  }

  void _onBackPressed(BuildContext context) async {
    await TokenStorage.clear();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteNames.login,
        (route) => false,
      );
    }
  }

  void _onHelpPressed(BuildContext context) {
    _showSnackbar(
      context: context,
      message: 'Yardım merkezi yakında aktif olacaktır.',
      backgroundColor: context.colorScheme.onSurface,
    );
  }

  void _onSubmitPressed(BuildContext context) {
    context.read<CandidateBloc>().add(const SubmitOffers());
  }

  Widget _buildTabBar(BuildContext context, CandidateState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.pageHorizontalPadding,
        AppDimensions.tabBarTopMargin,
        AppDimensions.pageHorizontalPadding,
        0,
      ),
      child: CandidatesTabBar(
        activeTab: state.activeTab,
        totalPerfect: state.totalPerfect > 0 ? state.totalPerfect : 26,
        totalSimilar: state.totalSimilar > 0 ? state.totalSimilar : 16,
        onTabChanged: (tab) {
          context.read<CandidateBloc>().add(ChangeTab(tab));
        },
      ),
    );
  }

  Widget _buildSubHeader(BuildContext context, CandidateState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.pageHorizontalPadding,
      ),
      child: CandidatesSubHeader(
        selectedCount: state.selectedCount,
        activeSort: state.activeSort,
        onSortChanged: (sort) {
          context.read<CandidateBloc>().add(ChangeSort(sort));
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, CandidateState state) {
    if (state.status == CandidateStatus.loading && state.candidates.isEmpty) {
      return _buildLoadingView(context);
    }

    if (state.status == CandidateStatus.failure && state.candidates.isEmpty) {
      return _buildErrorView(context, state);
    }

    if (state.candidates.isEmpty) {
      return _buildEmptyView(context);
    }

    return _buildCandidateList(context, state);
  }

  Widget _buildLoadingView(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.colorScheme.primary,
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, CandidateState state) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.footerPaddingHorizontal,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: AppDimensions.errorIconSize,
              color: colorScheme.error,
            ),
            const SizedBox(height: AppDimensions.errorSpacingVertical),
            Text(
              state.errorMessage ?? 'Adaylar yüklenirken bir hata oluştu.',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.errorButtonSpacing),
            ElevatedButton(
              onPressed: () {
                context.read<CandidateBloc>().add(const FetchCandidates());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.controlRadius),
                ),
              ),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Text(
        'Uygun aday bulunamadı.',
        style: context.textTheme.titleMedium?.copyWith(
          color: context.customColors.slate500,
        ),
      ),
    );
  }

  Widget _buildCandidateList(BuildContext context, CandidateState state) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.pageHorizontalPadding,
        0.0,
        AppDimensions.pageHorizontalPadding,
        AppDimensions.listBottomPadding,
      ),
      itemCount: state.candidates.length,
      itemBuilder: (context, index) {
        final candidate = state.candidates[index];
        final bool isSelected = state.isCandidateSelected(candidate.id);

        return CandidateCard(
          candidate: candidate,
          isSelected: isSelected,
          onToggleSelect: () {
            context
                .read<CandidateBloc>()
                .add(ToggleCandidateSelection(candidate.id));
          },
        );
      },
    );
  }
}
