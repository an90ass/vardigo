import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/candidate_entity.dart';

enum CandidateStatus {
  initial,
  loading,
  success,
  failure,
}

/*
 NOTE: I used a single immutable state with copyWith and CandidateStatus instead of multiple state classes
because the screen has several independent states such as tabs, sorting, checkboxes, counters, and pagination. This allows each value to update independently
 without "losing existing data" or causing unnecessary screen flickering.
*/
class CandidateState extends Equatable {
  final CandidateStatus status;
  final List<CandidateEntity> candidates;
  final int totalPerfect;
  final int totalSimilar;
  final int selectedHint;
  final CandidateTab activeTab;
  final CandidateSort activeSort;
  final Set<String> selectedCandidateIds;
  final bool isSubmittingOffers;
  final String? errorMessage;
  final String? successMessage;

  const CandidateState({
    this.status = CandidateStatus.initial,
    this.candidates = const [],
    this.totalPerfect = 0,
    this.totalSimilar = 0,
    this.selectedHint = 1,
    this.activeTab = CandidateTab.perfect,
    this.activeSort = CandidateSort.recommended,
    this.selectedCandidateIds = const {},
    this.isSubmittingOffers = false,
    this.errorMessage,
    this.successMessage,
  });

  CandidateState copyWith({
    CandidateStatus? status,
    List<CandidateEntity>? candidates,
    int? totalPerfect,
    int? totalSimilar,
    int? selectedHint,
    CandidateTab? activeTab,
    CandidateSort? activeSort,
    Set<String>? selectedCandidateIds,
    bool? isSubmittingOffers,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return CandidateState(
      status: status ?? this.status,
      candidates: candidates ?? this.candidates,
      totalPerfect: totalPerfect ?? this.totalPerfect,
      totalSimilar: totalSimilar ?? this.totalSimilar,
      selectedHint: selectedHint ?? this.selectedHint,
      activeTab: activeTab ?? this.activeTab,
      activeSort: activeSort ?? this.activeSort,
      selectedCandidateIds: selectedCandidateIds ?? this.selectedCandidateIds,
      isSubmittingOffers: isSubmittingOffers ?? this.isSubmittingOffers,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  int get selectedCount => selectedCandidateIds.length;
  bool isCandidateSelected(String id) => selectedCandidateIds.contains(id);

  @override
  List<Object?> get props => [
        status,
        candidates,
        totalPerfect,
        totalSimilar,
        selectedHint,
        activeTab,
        activeSort,
        selectedCandidateIds,
        isSubmittingOffers,
        errorMessage,
        successMessage,
      ];
}
