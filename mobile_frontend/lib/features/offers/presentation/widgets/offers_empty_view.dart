import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/theme_context_ext.dart';

class OffersEmptyView extends StatelessWidget {
  final OfferStatusFilter filter;

  const OffersEmptyView({
    super.key,
    required this.filter,
  });

  String _getMessage() {
    switch (filter) {
      case OfferStatusFilter.pending:
        return AppStrings.emptyPendingOffers;
      case OfferStatusFilter.answered:
        return AppStrings.emptyAnsweredOffers;
      case OfferStatusFilter.expired:
        return AppStrings.emptyExpiredOffers;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final customColors = context.customColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.pageHorizontalPadding,
          vertical: AppDimensions.gap40,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFF7F7F7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inbox_outlined,
                size: 32,
                color: customColors.slate500,
              ),
            ),
            const SizedBox(height: AppDimensions.gap16),
            Text(
              _getMessage(),
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: customColors.slate600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
