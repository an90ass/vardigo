import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../offers/domain/usecases/create_offers_usecase.dart';
import '../../domain/usecases/get_candidates_usecase.dart';
import 'candidate_event.dart';
import 'candidate_state.dart';

export 'candidate_event.dart';
export 'candidate_state.dart';

class CandidateBloc extends Bloc<CandidateEvent, CandidateState> {
  final GetCandidatesUseCase getCandidatesUseCase;
  final CreateOffersUseCase? createOffersUseCase;

  CandidateBloc({
    required this.getCandidatesUseCase,
    this.createOffersUseCase,
  }) : super(const CandidateState()) {
    on<FetchCandidates>(_onFetchCandidates);
    on<ChangeTab>(_onChangeTab);
    on<ChangeSort>(_onChangeSort);
    on<ToggleCandidateSelection>(_onToggleCandidateSelection);
    on<ClearSelection>(_onClearSelection);
    on<SubmitOffers>(_onSubmitOffers);
    on<ClearCandidateMessages>(_onClearCandidateMessages);
  }

  Future<void> _onFetchCandidates(
    FetchCandidates event,
    Emitter<CandidateState> emit,
  ) async {
    if (state.candidates.isEmpty) {
      emit(state.copyWith(status: CandidateStatus.loading, clearError: true));
    }
    await _loadData(emit, tab: state.activeTab, sort: state.activeSort);
  }

  Future<void> _onChangeTab(
    ChangeTab event,
    Emitter<CandidateState> emit,
  ) async {
    if (event.tab == state.activeTab) return;
    AppLogger.d('[CandidateBloc] Tab changed to ${event.tab.value}');
    emit(state.copyWith(
      activeTab: event.tab,
      selectedCandidateIds: const {},
    ));
    await _loadData(emit, tab: event.tab, sort: state.activeSort);
  }

  Future<void> _onChangeSort(
    ChangeSort event,
    Emitter<CandidateState> emit,
  ) async {
    if (event.sort == state.activeSort) return;
    AppLogger.d('[CandidateBloc] Sort changed to ${event.sort.value}');
    emit(state.copyWith(activeSort: event.sort));
    await _loadData(emit, tab: state.activeTab, sort: event.sort);
  }

  Future<void> _loadData(
    Emitter<CandidateState> emit, {
    required CandidateTab tab,
    required CandidateSort sort,
  }) async {
    final result = await getCandidatesUseCase(tab: tab, sort: sort);

    result.fold(
      (failure) {
        AppLogger.e('[CandidateBloc] Failed to fetch candidates: ${failure.message}');
        emit(state.copyWith(
          status: CandidateStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (data) {
        final initialSelection = tab == CandidateTab.perfect && data.candidates.isNotEmpty
            ? {data.candidates.first.id}
            : state.selectedCandidateIds;

        emit(state.copyWith(
          status: CandidateStatus.success,
          candidates: data.candidates,
          totalPerfect: data.totalPerfect,
          totalSimilar: data.totalSimilar,
          selectedHint: data.selectedHint,
          selectedCandidateIds: initialSelection,
        ));
      },
    );
  }

  void _onToggleCandidateSelection(
    ToggleCandidateSelection event,
    Emitter<CandidateState> emit,
  ) {
    final updated = Set<String>.from(state.selectedCandidateIds);
    if (updated.contains(event.candidateId)) {
      updated.remove(event.candidateId);
      AppLogger.d('[CandidateBloc] Unselected candidate ${event.candidateId}');
    } else {
      updated.add(event.candidateId);
      AppLogger.d('[CandidateBloc] Selected candidate ${event.candidateId}');
    }
    emit(state.copyWith(selectedCandidateIds: updated));
  }

  void _onClearSelection(
    ClearSelection event,
    Emitter<CandidateState> emit,
  ) {
    emit(state.copyWith(selectedCandidateIds: const {}));
  }

  Future<void> _onSubmitOffers(
    SubmitOffers event,
    Emitter<CandidateState> emit,
  ) async {
    final selectedIds = state.selectedCandidateIds.toList();
    if (selectedIds.isEmpty) return;

    AppLogger.i('[CandidateBloc] Submitting interview offers for ${selectedIds.length} candidate(s): $selectedIds');

    if (createOffersUseCase != null) {
      final result = await createOffersUseCase!(selectedIds);
      result.fold(
        (failure) {
          AppLogger.e('[CandidateBloc] Failed to submit offers: ${failure.message}');
          emit(state.copyWith(
            errorMessage: failure.message,
          ));
        },
        (_) {
          AppLogger.i('[CandidateBloc] Successfully sent offers to $selectedIds');
          emit(state.copyWith(
            selectedCandidateIds: const {},
            successMessage: AppStrings.offersSelectedSuccess(selectedIds.length),
          ));
        },
      );
    } else {
      emit(state.copyWith(
        selectedCandidateIds: const {},
        successMessage: AppStrings.offersSelectedSuccess(selectedIds.length),
      ));
    }
  }

  void _onClearCandidateMessages(
    ClearCandidateMessages event,
    Emitter<CandidateState> emit,
  ) {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }
}
