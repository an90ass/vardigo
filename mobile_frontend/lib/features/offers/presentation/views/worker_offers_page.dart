import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/custom_controls.dart';
import '../../domain/entities/offer_entity.dart';
import '../bloc/offer_bloc.dart';
import '../widgets/offer_card.dart';
import '../widgets/offers_app_bar.dart';
import '../widgets/offers_empty_view.dart';
import '../widgets/offers_tab_bar.dart';

class WorkerOffersPage extends StatefulWidget {
  const WorkerOffersPage({super.key});

  @override
  State<WorkerOffersPage> createState() => _WorkerOffersPageState();
}

class _WorkerOffersPageState extends State<WorkerOffersPage> {
  OfferSortOption _selectedSort = OfferSortOption.recommended;

  String get _sortLabel {
    switch (_selectedSort) {
      case OfferSortOption.recommended:
        return AppStrings.sortRecommended;
      case OfferSortOption.pay:
        return 'Sırala: Ücret';
      case OfferSortOption.urgent:
        return 'Sırala: En Acil';
    }
  }

  List<OfferEntity> _sortOffers(List<OfferEntity> offers) {
    final list = List<OfferEntity>.from(offers);
    switch (_selectedSort) {
      case OfferSortOption.recommended:
        return list;
      case OfferSortOption.pay:
        list.sort((a, b) => b.payValue.compareTo(a.payValue));
        return list;
      case OfferSortOption.urgent:
        list.sort((a, b) => a.expiresAt.compareTo(b.expiresAt));
        return list;
    }
  }

  void _showSortBottomSheet(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.bottomSheetRadius),
        ),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.bottomSheetHandleMargin,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: AppDimensions.bottomSheetHandleWidth,
                  height: AppDimensions.bottomSheetHandleHeight,
                  margin: const EdgeInsets.only(
                    bottom: AppDimensions.bottomSheetHandleMargin,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.bottomSheetHandleHeight / 2,
                    ),
                  ),
                ),
                Text(
                  'Talepleri Sırala',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimensions.cardPhotoTextGap),
                _buildSortOption(ctx, AppStrings.sortOptionRecommended, OfferSortOption.recommended),
                _buildSortOption(ctx, 'Ücrete Göre (En Yüksek)', OfferSortOption.pay),
                _buildSortOption(ctx, 'Süreye Göre (En Acil)', OfferSortOption.urgent),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String label,
    OfferSortOption sort,
  ) {
    final isSelected = _selectedSort == sort;
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    return ListTile(
      title: Text(
        label,
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_rounded,
              color: colorScheme.primary,
              size: AppDimensions.squareButtonIconSize,
            )
          : null,
      onTap: () {
        Navigator.pop(context);
        setState(() {
          if (_selectedSort == sort) {
            _selectedSort = OfferSortOption.recommended;
          } else {
            _selectedSort = sort;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OfferBloc, OfferState>(
      listener: _handleMessages,
      builder: _buildScaffold,
    );
  }

  void _handleMessages(BuildContext context, OfferState state) {
    final colorScheme = context.colorScheme;
    final customColors = context.customColors;

    if (state.errorMessage != null) {
      _showSnackbar(
        context: context,
        message: state.errorMessage!,
        backgroundColor: colorScheme.error,
      );
      context.read<OfferBloc>().add(const ClearOfferMessages());
    }

    if (state.successMessage != null) {
      _showSnackbar(
        context: context,
        message: state.successMessage!,
        backgroundColor: customColors.green,
      );
      context.read<OfferBloc>().add(const ClearOfferMessages());
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

  Widget _buildScaffold(BuildContext context, OfferState state) {
    return Scaffold(
      appBar: OffersAppBar(
        pendingCount: state.pendingCount,
        activeFilter: state.activeFilter,
        onBackTap: () => _onBackPressed(context),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTabBar(context, state),
            _buildSortRow(context),
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

  Widget _buildTabBar(BuildContext context, OfferState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.pageHorizontalPadding,
        AppDimensions.tabBarTopMargin,
        AppDimensions.pageHorizontalPadding,
        0,
      ),
      child: OffersTabBar(
        activeFilter: state.activeFilter,
        onFilterChanged: (filter) {
          context.read<OfferBloc>().add(ChangeOfferFilter(filter));
        },
      ),
    );
  }

  Widget _buildSortRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.pageHorizontalPadding,
        AppDimensions.gap8,
        AppDimensions.pageHorizontalPadding,
        AppDimensions.gap8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SortChip(
            label: _sortLabel,
            svgPath: AppIconEnum.sort.svgPath,
            onTap: () => _showSortBottomSheet(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, OfferState state) {
    if (state.status == OfferPageStatus.loading && state.offers.isEmpty) {
      return _buildLoadingView(context);
    }

    if (state.status == OfferPageStatus.failure && state.offers.isEmpty) {
      return _buildErrorView(context, state);
    }

    if (state.offers.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<OfferBloc>().add(const FetchOffers(refresh: true));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: OffersEmptyView(filter: state.activeFilter),
        ),
      );
    }

    return _buildOffersList(context, state);
  }

  Widget _buildLoadingView(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.colorScheme.primary,
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, OfferState state) {
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
              state.errorMessage ?? AppStrings.generalError,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium,
            ),
            const SizedBox(height: AppDimensions.errorButtonSpacing),
            ElevatedButton(
              onPressed: () {
                context.read<OfferBloc>().add(const FetchOffers());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.controlRadius),
                ),
              ),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersList(BuildContext context, OfferState state) {
    final displayedOffers = _sortOffers(state.offers);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<OfferBloc>().add(const FetchOffers(refresh: true));
      },
      child: ListView.separated(
        key: ValueKey('${state.activeFilter}_$_selectedSort'),
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.pageHorizontalPadding,
          0.0,
          AppDimensions.pageHorizontalPadding,
          AppDimensions.listBottomPadding,
        ),
        itemCount: displayedOffers.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.gap12),
        itemBuilder: (context, index) {
          final offer = displayedOffers[index];
          final bool isProcessing = state.isOfferProcessing(offer.id);

          return OfferCard(
            key: ValueKey(offer.id),
            offer: offer,
            isProcessing: isProcessing,
            onFetchDetail: () {
              context.read<OfferBloc>().add(FetchOfferDetailEvent(offer.id));
            },
            onAccept: () {
              context.read<OfferBloc>().add(AcceptOfferEvent(offer.id));
            },
            onReject: () {
              context.read<OfferBloc>().add(RejectOfferEvent(offer.id));
            },
          );
        },
      ),
    );
  }
}
