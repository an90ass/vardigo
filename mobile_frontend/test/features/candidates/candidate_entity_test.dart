import 'package:flutter_test/flutter_test.dart';
import 'package:vardigo/features/candidates/data/models/candidate_model.dart';
import 'package:vardigo/features/candidates/domain/entities/candidate_entity.dart';

void main() {
  group('CandidateModel and CandidateEntity', () {
    final candidateJson = {
      'id': 'cand-1',
      'name': 'Ahmet Y.',
      'rating': '4.8',
      'attend': '98%',
      'km': '3.2 km',
      'kmValue': 3.2,
      'photo': 'assets/photos/cand1.png',
      'online': true,
      'perfect': true,
      'score': 95,
    };

    test('should parse CandidateModel correctly from JSON', () {
      final model = CandidateModel.fromJson(candidateJson);

      expect(model.id, 'cand-1');
      expect(model.name, 'Ahmet Y.');
      expect(model.rating, '4.8');
      expect(model.attend, '98%');
      expect(model.km, '3.2 km');
      expect(model.kmValue, 3.2);
      expect(model.photo, 'assets/photos/cand1.png');
      expect(model.online, true);
      expect(model.perfect, true);
      expect(model.score, 95);
    });

    test('should convert CandidateModel to JSON correctly', () {
      final model = CandidateModel.fromJson(candidateJson);
      final jsonMap = model.toJson();

      expect(jsonMap['id'], 'cand-1');
      expect(jsonMap['name'], 'Ahmet Y.');
      expect(jsonMap['online'], true);
      expect(jsonMap['score'], 95);
    });

    test('should map CandidateModel to CandidateEntity accurately', () {
      final model = CandidateModel.fromJson(candidateJson);
      final entity = model.toEntity();

      expect(entity, isA<CandidateEntity>());
      expect(entity.id, model.id);
      expect(entity.name, model.name);
      expect(entity.isOnline, model.online);
      expect(entity.isPerfect, model.perfect);
      expect(entity.score, model.score);
    });

    test('CandidateEntity equality should hold for identical values', () {
      const entity1 = CandidateEntity(
        id: '1',
        name: 'Ali',
        rating: '5.0',
        attend: '100%',
        km: '1 km',
        kmValue: 1.0,
        photo: 'photo.png',
        isOnline: true,
        isPerfect: true,
        score: 100,
      );

      const entity2 = CandidateEntity(
        id: '1',
        name: 'Ali',
        rating: '5.0',
        attend: '100%',
        km: '1 km',
        kmValue: 1.0,
        photo: 'photo.png',
        isOnline: true,
        isPerfect: true,
        score: 100,
      );

      expect(entity1, equals(entity2));
    });

    test('CandidateListEntity equality should hold for identical values', () {
      const list1 = CandidateListEntity(
        totalPerfect: 10,
        totalSimilar: 5,
        selectedHint: 1,
        candidates: [],
      );

      const list2 = CandidateListEntity(
        totalPerfect: 10,
        totalSimilar: 5,
        selectedHint: 1,
        candidates: [],
      );

      expect(list1, equals(list2));
    });
  });
}
