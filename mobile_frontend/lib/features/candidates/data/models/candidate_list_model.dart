import 'package:equatable/equatable.dart';
import '../../domain/entities/candidate_entity.dart';
import 'candidate_model.dart';

class CandidateListModel extends Equatable {
  final int totalPerfect;
  final int totalSimilar;
  final int selectedHint;
  final List<CandidateModel> candidates;

  const CandidateListModel({
    required this.totalPerfect,
    required this.totalSimilar,
    required this.selectedHint,
    required this.candidates,
  });

  factory CandidateListModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['candidates'] as List<dynamic>? ?? [];
    final parsedCandidates = rawList
        .whereType<Map<String, dynamic>>()
        .map(CandidateModel.fromJson)
        .toList();

    return CandidateListModel(
      totalPerfect: (json['totalPerfect'] as num?)?.toInt() ?? 0,
      totalSimilar: (json['totalSimilar'] as num?)?.toInt() ?? 0,
      selectedHint: (json['selectedHint'] as num?)?.toInt() ?? 1,
      candidates: parsedCandidates,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPerfect': totalPerfect,
      'totalSimilar': totalSimilar,
      'selectedHint': selectedHint,
      'candidates': candidates.map((c) => c.toJson()).toList(),
    };
  }

  CandidateListEntity toEntity() {
    return CandidateListEntity(
      totalPerfect: totalPerfect,
      totalSimilar: totalSimilar,
      selectedHint: selectedHint,
      candidates: candidates.map((c) => c.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
        totalPerfect,
        totalSimilar,
        selectedHint,
        candidates,
      ];
}
