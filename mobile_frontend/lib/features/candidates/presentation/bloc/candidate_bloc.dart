import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/usecases/get_candidates_usecase.dart';
import 'candidate_event.dart';
import 'candidate_state.dart';

export 'candidate_event.dart';
export 'candidate_state.dart';

class CandidateBloc extends Bloc<CandidateEvent, CandidateState> {
  final GetCandidatesUseCase getCandidatesUseCase;

  CandidateBloc({
    required this.getCandidatesUseCase,
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
    AppLogger.i('[CandidateBloc] Fetching candidates: tab=${state.activeTab.value}, sort=${state.activeSort.value}');
    emit(state.copyWith(status: CandidateStatus.loading, clearError: true));

    final result = await getCandidatesUseCase(
      tab: state.activeTab,
      sort: state.activeSort,
    );

    result.fold(
      (failure) {
        AppLogger.e('[CandidateBloc] Failed to fetch candidates: ${failure.message}');
        emit(state.copyWith(
          status: CandidateStatus.failure,
          errorMessage: failure.message,
        ));
      },
      (data) {
        AppLogger.i('[CandidateBloc] Loaded ${data.candidates.length} candidates (Perfect: ${data.totalPerfect}, Similar: ${data.totalSimilar})');
        final initialSelection = state.selectedCandidateIds.isEmpty && data.candidates.isNotEmpty
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

  void _onChangeTab(
    ChangeTab event,
    Emitter<CandidateState> emit,
  ) {
    if (event.tab == state.activeTab) return;
    AppLogger.d('[CandidateBloc] Tab changed to ${event.tab.value}');
    emit(state.copyWith(
      activeTab: event.tab,
      selectedCandidateIds: const {},
    ));
    add(const FetchCandidates());
  }

  void _onChangeSort(
    ChangeSort event,
    Emitter<CandidateState> emit,
  ) {
    if (event.sort == state.activeSort) return;
    AppLogger.d('[CandidateBloc] Sort changed to ${event.sort.value}');
    emit(state.copyWith(activeSort: event.sort));
    add(const FetchCandidates());
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

  void _onSubmitOffers(
    SubmitOffers event,
    Emitter<CandidateState> emit,
  ) {
    final selectedIds = state.selectedCandidateIds.toList();
    if (selectedIds.isEmpty) return;

    AppLogger.i('[CandidateBloc] Selected ${selectedIds.length} candidate(s) for interview offers');
    emit(state.copyWith(
      selectedCandidateIds: const {},
      successMessage: '${selectedIds.length} adaya teklif seçildi (Offers modülüne bağlanacak)',
    ));
  }

  void _onClearCandidateMessages(
    ClearCandidateMessages event,
    Emitter<CandidateState> emit,
  ) {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }
}
