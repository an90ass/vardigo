import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';

abstract class CandidateEvent extends Equatable {
  const CandidateEvent();

  @override
  List<Object?> get props => [];
}

// Initial or refresh load of candidates
class FetchCandidates extends CandidateEvent {
  final bool refresh;

  const FetchCandidates({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

// Changes the active candidate tab (Tam Eşleşen vs Benzer Adaylar)
class ChangeTab extends CandidateEvent {
  final CandidateTab tab;

  const ChangeTab(this.tab);

  @override
  List<Object?> get props => [tab];
}

// Changes the sort option (Önerilen, En Yakın, Puan)
class ChangeSort extends CandidateEvent {
  final CandidateSort sort;

  const ChangeSort(this.sort);

  @override
  List<Object?> get props => [sort];
}

// Toggles selection of an individual candidate by ID
class ToggleCandidateSelection extends CandidateEvent {
  final String candidateId;

  const ToggleCandidateSelection(this.candidateId);

  @override
  List<Object?> get props => [candidateId];
}

// Clears all selected candidate checkboxes
class ClearSelection extends CandidateEvent {
  const ClearSelection();
}

// Submits interview offers to all currently selected candidates
class SubmitOffers extends CandidateEvent {
  const SubmitOffers();
}

// Clears transient snackbar messages
class ClearCandidateMessages extends CandidateEvent {
  const ClearCandidateMessages();
}
