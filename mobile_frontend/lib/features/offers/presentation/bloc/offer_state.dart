import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/offer_entity.dart';

enum OfferPageStatus {
  initial,
  loading,
  success,
  failure,
}


/* I used a single immutable state  because the offers screen manages concurrent filter tabs,
per-card asynchronous actions (accepting/rejecting an individual card while keeping the list visible),
and live countdown timers without full screen redraws or data loss.
*/
class OfferState extends Equatable {
  final OfferPageStatus status;
  final List<OfferEntity> offers;
  final int pendingCount;
  final OfferStatusFilter activeFilter;
  final Set<String> processingOfferIds;
  final String? errorMessage;
  final String? successMessage;

  const OfferState({
    this.status = OfferPageStatus.initial,
    this.offers = const [],
    this.pendingCount = 0,
    this.activeFilter = OfferStatusFilter.pending,
    this.processingOfferIds = const {},
    this.errorMessage,
    this.successMessage,
  });

  OfferState copyWith({
    OfferPageStatus? status,
    List<OfferEntity>? offers,
    int? pendingCount,
    OfferStatusFilter? activeFilter,
    Set<String>? processingOfferIds,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return OfferState(
      status: status ?? this.status,
      offers: offers ?? this.offers,
      pendingCount: pendingCount ?? this.pendingCount,
      activeFilter: activeFilter ?? this.activeFilter,
      processingOfferIds: processingOfferIds ?? this.processingOfferIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  bool isOfferProcessing(String offerId) => processingOfferIds.contains(offerId);

  @override
  List<Object?> get props => [
        status,
        offers,
        pendingCount,
        activeFilter,
        processingOfferIds,
        errorMessage,
        successMessage,
      ];
}
