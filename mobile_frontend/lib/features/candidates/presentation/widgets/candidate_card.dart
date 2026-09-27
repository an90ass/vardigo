import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/widgets/custom_controls.dart';
import '../../domain/entities/candidate_entity.dart';

class CandidateCard extends StatelessWidget {
  final CandidateEntity candidate;
  final bool isSelected;
  final VoidCallback onToggleSelect;

  const CandidateCard({
    super.key,
    required this.candidate,
    required this.isSelected,
    required this.onToggleSelect,
  });

  String get _avatarAssetPath {
    if (candidate.photo.startsWith('assets/')) {
      return candidate.photo;
    }
    return 'assets/${candidate.photo}';
  }

  bool get _salaryMatches {
    if (candidate.id == 'w_derya' || candidate.id == 'w_ferhat') {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final customColors = context.customColors;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: onToggleSelect,
        behavior: HitTestBehavior.opaque,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.cardGap),
          decoration: BoxDecoration(
            color: isSelected ? customColors.selectedCardBg : colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            border: isSelected
                ? null
                : Border.all(
                    color: colorScheme.outline,
                    width: 1.0,
                  ),
            boxShadow: isSelected ? AppShadows.cardSelected : AppShadows.cardNormal,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              if (isSelected) _buildSelectionIndicator(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.cardPaddingHorizontal,
                  AppDimensions.cardPaddingVertical,
                  AppDimensions.cardPaddingHorizontal,
                  AppDimensions.cardPaddingVertical,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainRow(context),
                    const SizedBox(height: AppDimensions.cardPhotoTextGap),
                    _buildSalaryBanner(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      width: AppDimensions.cardSelectionBarWidth,
      child: Container(color: context.colorScheme.primary),
    );
  }

  Widget _buildMainRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(context),
        const SizedBox(width: AppDimensions.cardPhotoTextGap),
        Expanded(child: _buildDetails(context)),
        const SizedBox(width: AppDimensions.metaRowSectionGap),
        VardigoCheckbox(
          isChecked: isSelected,
          onChanged: (_) => onToggleSelect(),
        ),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: AppDimensions.avatarSize,
          height: AppDimensions.avatarSize,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            _avatarAssetPath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (_, __, ___) => Container(
              color: colorScheme.outline,
              alignment: Alignment.center,
              child: Text(
                candidate.name.isNotEmpty ? candidate.name[0] : '?',
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
        if (candidate.isOnline)
          Positioned(
            right: AppDimensions.onlineBadgeOffset,
            bottom: AppDimensions.onlineBadgeOffset,
            child: SvgPicture.asset(
              AppIconEnum.online.svgPath,
              width: AppDimensions.onlineBadgeSize,
              height: AppDimensions.onlineBadgeSize,
            ),
          ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context) {
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          candidate.name,
          style: textTheme.titleLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppDimensions.metaRowItemGap),
        _buildMetaRow(context),
      ],
    );
  }

  Widget _buildMetaRow(BuildContext context) {
    final customColors = context.customColors;

    return Row(
      children: [
        _buildMetaItem(
          context: context,
          svgPath: AppIconEnum.star.svgPath,
          iconColor: customColors.warning,
          iconSize: AppDimensions.metaStarIconSize,
          text: candidate.rating,
        ),
        const SizedBox(width: AppDimensions.metaRowSectionGap),
        _buildVerticalDivider(context),
        const SizedBox(width: AppDimensions.metaRowSectionGap),
        _buildMetaItem(
          context: context,
          svgPath: AppIconEnum.shield.svgPath,
          iconColor: customColors.green,
          iconSize: AppDimensions.metaShieldIconSize,
          text: candidate.attend,
        ),
        const SizedBox(width: AppDimensions.metaRowSectionGap),
        _buildVerticalDivider(context),
        const SizedBox(width: AppDimensions.metaRowSectionGap),
        _buildMetaItem(
          context: context,
          svgPath: AppIconEnum.pin.svgPath,
          iconColor: customColors.purple,
          iconSize: AppDimensions.metaPinIconSize,
          text: candidate.km,
        ),
      ],
    );
  }

  Widget _buildMetaItem({
    required BuildContext context,
    required String svgPath,
    required Color iconColor,
    required double iconSize,
    required String text,
  }) {
    final textTheme = context.textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          svgPath,
          width: iconSize,
          height: iconSize,
          colorFilter: ColorFilter.mode(
            iconColor,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: AppDimensions.metaRowItemGap),
        Text(
          text,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            height: 16 / 12,
            color: AppColors.slate700,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Container(
      width: AppDimensions.verticalDividerWidth,
      height: AppDimensions.verticalDividerHeight,
      color: context.colorScheme.outlineVariant,
    );
  }

  Widget _buildSalaryBanner(BuildContext context) {
    final textTheme = context.textTheme;
    final customColors = context.customColors;

    final bool salaryMatches = _salaryMatches;
    final Color salaryColor = salaryMatches ? customColors.green : customColors.warning;
    final Color salaryBg = customColors.salaryBarBg;
    final String salaryText = salaryMatches ? AppStrings.salaryMatches : AppStrings.salaryNoMatch;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.salaryBannerPaddingHorizontal,
        vertical: AppDimensions.salaryBannerPaddingVertical,
      ),
      decoration: BoxDecoration(
        color: salaryBg,
        borderRadius: BorderRadius.circular(AppDimensions.salaryBannerRadius),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppIconEnum.money.svgPath,
            width: AppDimensions.salaryBannerIconSize,
            height: AppDimensions.salaryBannerIconSize,
            colorFilter: ColorFilter.mode(
              salaryColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: AppDimensions.salaryBannerGap),
          Expanded(
            child: Text(
              salaryText,
              style: textTheme.bodySmall?.copyWith(
                color: salaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            AppStrings.defaultSalary,
            style: textTheme.bodySmall?.copyWith(
              color: salaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
