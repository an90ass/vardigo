import 'package:equatable/equatable.dart';
import '../../domain/entities/candidate_entity.dart';

class CandidateModel extends Equatable {
  final String id;
  final String name;
  final String rating;
  final String attend;
  final String km;
  final double kmValue;
  final String photo;
  final bool online;
  final bool perfect;
  final int score;

  const CandidateModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.attend,
    required this.km,
    required this.kmValue,
    required this.photo,
    required this.online,
    required this.perfect,
    required this.score,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      rating: json['rating']?.toString() ?? '0.0',
      attend: json['attend'] as String? ?? '',
      km: json['km'] as String? ?? '',
      kmValue: (json['kmValue'] as num?)?.toDouble() ?? 0.0,
      photo: json['photo'] as String? ?? '',
      online: json['online'] as bool? ?? false,
      perfect: json['perfect'] as bool? ?? false,
      score: (json['score'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'attend': attend,
      'km': km,
      'kmValue': kmValue,
      'photo': photo,
      'online': online,
      'perfect': perfect,
      'score': score,
    };
  }

  CandidateEntity toEntity() {
    return CandidateEntity(
      id: id,
      name: name,
      rating: rating,
      attend: attend,
      km: km,
      kmValue: kmValue,
      photo: photo,
      isOnline: online,
      isPerfect: perfect,
      score: score,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        rating,
        attend,
        km,
        kmValue,
        photo,
        online,
        perfect,
        score,
      ];
}
