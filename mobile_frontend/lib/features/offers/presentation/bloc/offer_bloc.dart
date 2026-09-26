import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/accept_offer_usecase.dart';
import '../../domain/usecases/get_offer_detail_usecase.dart';
import '../../domain/usecases/get_offers_usecase.dart';
import '../../domain/usecases/reject_offer_usecase.dart';
import 'offer_event.dart';
import 'offer_state.dart';

export 'offer_event.dart';
export 'offer_state.dart';

class OfferBloc extends Bloc<OfferEvent, OfferState> {
  final GetOffersUseCase getOffersUseCase;
  final GetOfferDetailUseCase getOfferDetailUseCase;
  final AcceptOfferUseCase acceptOfferUseCase;
  final RejectOfferUseCase rejectOfferUseCase;

  OfferBloc({
    required this.getOffersUseCase,
    required this.getOfferDetailUseCase,
    required this.acceptOfferUseCase,
    required this.rejectOfferUseCase,
  }) : super(const OfferState()) {
    on<FetchOffers>(_onFetchOffers);
    on<FetchOfferDetailEvent>(_onFetchOfferDetail);
    on<ChangeOfferFilter>(_onChangeOfferFilter);
    on<AcceptOfferEvent>(_onAcceptOffer);
    on<RejectOfferEvent>(_onRejectOffer);
    on<ClearOfferMessages>(_onClearOfferMessages);
  }

  Future<void> _onFetchOffers(
    FetchOffers event,
    Emitter<OfferState> emit,
  ) async {
    AppLogger.i('[OfferBloc] Fetching offers with filter: ${state.activeFilter.value}');
    emit(state.copyWith(
      status: event.refresh ? state.status : OfferPageStatus.loading,
      clearError: true,
    ));

    final result = await getOffersUseCase(filter: state.activeFilter);

    result.fold(
      (failure) {
        AppLogger.e('[OfferBloc] Failed to fetch offers: ${failure.message}');
        emit(state.copyWith(
          status: OfferPageStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (data) {
        AppLogger.i('[OfferBloc] Loaded ${data.offers.length} offers (Pending: ${data.pendingCount})');
        emit(state.copyWith(
          status: OfferPageStatus.success,
          offers: data.offers,
          pendingCount: data.pendingCount,
        ));
      },
    );
  }

  Future<void> _onFetchOfferDetail(
    FetchOfferDetailEvent event,
    Emitter<OfferState> emit,
  ) async {
    AppLogger.d('[OfferBloc] Fetching offer detail: ${event.offerId}');
    final result = await getOfferDetailUseCase(event.offerId);

    result.fold(
      (failure) {
        AppLogger.e('[OfferBloc] Fetch offer detail failed: ${failure.message}');
      },
      (detailedOffer) {
        AppLogger.i('[OfferBloc] Offer detail loaded for ${event.offerId}');
        final updatedOffers = state.offers.map((offer) {
          return offer.id == detailedOffer.id ? detailedOffer : offer;
        }).toList();

        emit(state.copyWith(offers: updatedOffers));
      },
    );
  }

  void _onChangeOfferFilter(
    ChangeOfferFilter event,
    Emitter<OfferState> emit,
  ) {
    if (event.filter == state.activeFilter) return;
    AppLogger.d('[OfferBloc] Offer filter changed to ${event.filter.value}');
    emit(state.copyWith(activeFilter: event.filter));
    add(const FetchOffers());
  }

  Future<void> _onAcceptOffer(
    AcceptOfferEvent event,
    Emitter<OfferState> emit,
  ) async {
    AppLogger.i('[OfferBloc] Accepting offer ${event.offerId}');
    final updatedProcessing = Set<String>.from(state.processingOfferIds)..add(event.offerId);
    emit(state.copyWith(processingOfferIds: updatedProcessing, clearError: true));

    final result = await acceptOfferUseCase(event.offerId);

    result.fold(
      (failure) {
        AppLogger.e('[OfferBloc] Accept offer failed: ${failure.message}');
        final cleanProcessing = Set<String>.from(state.processingOfferIds)..remove(event.offerId);
        emit(state.copyWith(
          processingOfferIds: cleanProcessing,
          errorMessage: failure.message,
        ));
      },
      (updatedOffer) {
        AppLogger.i('[OfferBloc] Offer ${event.offerId} accepted successfully');
        final cleanProcessing = Set<String>.from(state.processingOfferIds)..remove(event.offerId);
        emit(state.copyWith(
          processingOfferIds: cleanProcessing,
          successMessage: 'Tebrikler! Görüşme teklifini kabul ettiniz.',
        ));
        add(const FetchOffers(refresh: true));
      },
    );
  }

  Future<void> _onRejectOffer(
    RejectOfferEvent event,
    Emitter<OfferState> emit,
  ) async {
    AppLogger.i('[OfferBloc] Rejecting offer ${event.offerId}');
    final updatedProcessing = Set<String>.from(state.processingOfferIds)..add(event.offerId);
    emit(state.copyWith(processingOfferIds: updatedProcessing, clearError: true));

    final result = await rejectOfferUseCase(event.offerId);

    result.fold(
      (failure) {
        AppLogger.e('[OfferBloc] Reject offer failed: ${failure.message}');
        final cleanProcessing = Set<String>.from(state.processingOfferIds)..remove(event.offerId);
        emit(state.copyWith(
          processingOfferIds: cleanProcessing,
          errorMessage: failure.message,
        ));
      },
      (updatedOffer) {
        AppLogger.i('[OfferBloc] Offer ${event.offerId} rejected');
        final cleanProcessing = Set<String>.from(state.processingOfferIds)..remove(event.offerId);
        emit(state.copyWith(
          processingOfferIds: cleanProcessing,
          successMessage: 'Görüşme teklifi reddedildi.',
        ));
        add(const FetchOffers(refresh: true));
      },
    );
  }

  void _onClearOfferMessages(
    ClearOfferMessages event,
    Emitter<OfferState> emit,
  ) {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }
}
