import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/theme_context_ext.dart';
import '../../../../core/utils/time_utils.dart';
import '../../domain/entities/offer_entity.dart';

class OfferCard extends StatefulWidget {
  final OfferEntity offer;
  final bool isProcessing;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onFetchDetail;

  const OfferCard({
    super.key,
    required this.offer,
    this.isProcessing = false,
    this.onAccept,
    this.onReject,
    this.onFetchDetail,
  });

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        border: Border.all(color: AppColors.stroke, width: 1.0),
        boxShadow: AppShadows.cardNormal,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTopRow(context),
          if (widget.offer.isPending) ...[
            const SizedBox(height: AppDimensions.gap12),
            _buildActionButtons(context),
          ] else ...[
            const SizedBox(height: AppDimensions.gap12),
            _buildStatusBadge(context),
          ],
          const SizedBox(height: AppDimensions.gap12),
          _buildDetailsButton(context),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedDetails(context),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          if (widget.offer.isPending) ...[
            const SizedBox(height: AppDimensions.gap10),
            _buildCountdownRow(context),
          ],
        ],
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    final textTheme = context.textTheme;
    final displayPay = widget.offer.pay.startsWith('₺')
        ? widget.offer.pay
        : '₺${widget.offer.pay}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(widget.offer.logo, widget.offer.place),
        const SizedBox(width: AppDimensions.gap12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.offer.title,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.27,
                        color: AppColors.strong,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.gap8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppIconEnum.money.svgPath,
                        width: AppDimensions.iconSize24,
                        height: AppDimensions.iconSize24,
                        colorFilter: const ColorFilter.mode(
                          AppColors.green,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.gap4),
                      Text(
                        displayPay,
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.27,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                widget.offer.place,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.gray500,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimensions.gap8),
              Row(
                children: [
                  SvgPicture.asset(
                    AppIconEnum.pin.svgPath,
                    width: AppDimensions.iconSize14,
                    height: AppDimensions.iconSize14,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.gap4),
                  Text(
                    widget.offer.district,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.slate700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.gap12),
                  SvgPicture.asset(
                    AppIconEnum.date.svgPath,
                    width: AppDimensions.iconSize16,
                    height: AppDimensions.iconSize16,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.gap4),
                  Expanded(
                    child: Text(
                      widget.offer.when,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.slate700,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogo(String logoPath, String fallbackName) {
    String filename = logoPath.split('/').last.trim();
    if (filename.isEmpty) {
      filename = 'zarif.svg';
    }
    if (!filename.endsWith('.svg')) {
      filename = '$filename.svg';
    }
    final resolvedPath = 'assets/logos/$filename';

    return SizedBox(
      width: AppDimensions.avatarSize,
      height: AppDimensions.avatarSize,
      child: SvgPicture.asset(
        resolvedPath,
        width: AppDimensions.avatarSize,
        height: AppDimensions.avatarSize,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final textTheme = context.textTheme;

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: widget.isProcessing ? null : widget.onReject,
            borderRadius: BorderRadius.circular(AppDimensions.radius8),
            child: Container(
              height: AppDimensions.buttonHeight36,
              decoration: BoxDecoration(
                color: const Color(0xFFFEECEE),
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIconEnum.close.svgPath,
                    width: AppDimensions.iconSize16,
                    height: AppDimensions.iconSize16,
                    colorFilter: const ColorFilter.mode(
                      AppColors.error,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.gap6),
                  Text(
                    AppStrings.notInterestedButton,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.gap12),
        Expanded(
          child: InkWell(
            onTap: widget.isProcessing ? null : widget.onAccept,
            borderRadius: BorderRadius.circular(AppDimensions.radius8),
            child: Container(
              height: AppDimensions.buttonHeight36,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(AppDimensions.radius8),
              ),
              alignment: Alignment.center,
              child: widget.isProcessing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppIconEnum.check.svgPath,
                          width: AppDimensions.iconSize16,
                          height: AppDimensions.iconSize16,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.gap6),
                        Text(
                          AppStrings.interestedButton,
                          style: textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final textTheme = context.textTheme;
    Color bgColor;
    Color textColor;
    String label;
    String iconPath;

    if (widget.offer.isAccepted) {
      bgColor = AppColors.greenLighter;
      textColor = AppColors.green;
      label = AppStrings.acceptedBadge;
      iconPath = AppIconEnum.check.svgPath;
    } else if (widget.offer.isRejected) {
      bgColor = const Color(0xFFFEECEE);
      textColor = AppColors.error;
      label = AppStrings.rejectedBadge;
      iconPath = AppIconEnum.close.svgPath;
    } else {
      bgColor = const Color(0xFFF7F7F7);
      textColor = AppColors.gray500;
      label = AppStrings.expiredBadge;
      iconPath = AppIconEnum.alarm.svgPath;
    }

    return Container(
      width: double.infinity,
      height: AppDimensions.buttonHeight36,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            width: AppDimensions.iconSize16,
            height: AppDimensions.iconSize16,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          const SizedBox(width: AppDimensions.gap6),
          Text(
            label,
            style: textTheme.bodyLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsButton(BuildContext context) {
    final textTheme = context.textTheme;

    return InkWell(
      onTap: () {
        final nextState = !_isExpanded;
        if (nextState && (widget.offer.city == null || widget.offer.note == null)) {
          widget.onFetchDetail?.call();
        }
        setState(() {
          _isExpanded = nextState;
        });
      },
      borderRadius: BorderRadius.circular(AppDimensions.radius8),
      child: Container(
        width: double.infinity,
        height: AppDimensions.buttonHeight36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radius8),
          border: Border.all(color: AppColors.stroke, width: 1.0),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIconEnum.eye.svgPath,
              width: AppDimensions.iconSize20,
              height: AppDimensions.iconSize20,
              colorFilter: const ColorFilter.mode(
                AppColors.sub,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppDimensions.gap6),
            Text(
              _isExpanded ? AppStrings.hideDetails : AppStrings.viewDetails,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.sub,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedDetails(BuildContext context) {
    final textTheme = context.textTheme;
    final city = widget.offer.city ?? 'İstanbul';
    final note = widget.offer.note ?? 'Şube: Sinanpaşa Mah.';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: AppDimensions.gap10),
      padding: const EdgeInsets.all(AppDimensions.gap12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(AppDimensions.radius8),
        border: Border.all(color: AppColors.stroke, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                AppIconEnum.pin.svgPath,
                width: AppDimensions.iconSize16,
                height: AppDimensions.iconSize16,
                colorFilter: const ColorFilter.mode(
                  AppColors.gray500,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: AppDimensions.gap6),
              Expanded(
                child: Text(
                  '${widget.offer.place} · ${widget.offer.district}, $city',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.strong,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.gap6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                AppIconEnum.shield.svgPath,
                width: AppDimensions.iconSize16,
                height: AppDimensions.iconSize16,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: AppDimensions.gap6),
              Expanded(
                child: Text(
                  note,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.gap6),
          Row(
            children: [
              SvgPicture.asset(
                AppIconEnum.date.svgPath,
                width: AppDimensions.iconSize16,
                height: AppDimensions.iconSize16,
                colorFilter: const ColorFilter.mode(
                  AppColors.gray500,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: AppDimensions.gap6),
              Expanded(
                child: Text(
                  'Görüşme Zamanı: ${widget.offer.when}',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.sub,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownRow(BuildContext context) {
    final textTheme = context.textTheme;
    final remainingFormatted = TimeUtils.formatRemaining(
      widget.offer.expiresAt,
      widget.offer.remain,
    );

    final bool isUrgent = remainingFormatted.contains('5 saat') ||
        remainingFormatted.contains('dakika') && !remainingFormatted.contains('gün');
    final Color alarmColor = isUrgent ? AppColors.error : AppColors.warning;
    final Color timeTextColor = isUrgent ? AppColors.error : AppColors.strong;

    return Row(
      children: [
        SvgPicture.asset(
          AppIconEnum.alarm.svgPath,
          width: AppDimensions.iconSize16,
          height: AppDimensions.iconSize16,
          colorFilter: ColorFilter.mode(
            alarmColor,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: AppDimensions.gap6),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.strong,
                fontSize: 12,
              ),
              children: [
                TextSpan(text: AppStrings.offerRemainingPrefix),
                TextSpan(
                  text: remainingFormatted,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: timeTextColor,
                  ),
                ),
                TextSpan(text: AppStrings.offerRemainingSuffix),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
