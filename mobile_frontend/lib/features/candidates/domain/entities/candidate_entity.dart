import 'package:equatable/equatable.dart';

class CandidateEntity extends Equatable {
  final String id;
  final String name;
  final String rating;
  final String attend;
  final String km;
  final double kmValue;
  final String photo;
  final bool isOnline;
  final bool isPerfect;
  final int score;

  const CandidateEntity({
    required this.id,
    required this.name,
    required this.rating,
    required this.attend,
    required this.km,
    required this.kmValue,
    required this.photo,
    required this.isOnline,
    required this.isPerfect,
    required this.score,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        rating,
        attend,
        km,
        kmValue,
        photo,
        isOnline,
        isPerfect,
        score,
      ];
}

class CandidateListEntity extends Equatable {
  final int totalPerfect;
  final int totalSimilar;
  final int selectedHint;
  final List<CandidateEntity> candidates;

  const CandidateListEntity({
    required this.totalPerfect,
    required this.totalSimilar,
    required this.selectedHint,
    required this.candidates,
  });

  @override
  List<Object?> get props => [
        totalPerfect,
        totalSimilar,
        selectedHint,
        candidates,
      ];
}
