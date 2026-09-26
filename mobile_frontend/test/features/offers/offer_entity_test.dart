import 'package:flutter_test/flutter_test.dart';
import 'package:vardigo/core/enums/app_enums.dart';
import 'package:vardigo/features/offers/data/models/offer_model.dart';
import 'package:vardigo/features/offers/domain/entities/offer_entity.dart';

void main() {
  group('OfferModel and OfferEntity', () {
    final offerJson = {
      'id': 'off-1',
      'workerId': '1',
      'title': 'Garson',
      'place': 'Zarif Cheff Restaurant',
      'pay': '45.000',
      'payValue': 45000,
      'logo': 'assets/logos/zarif.svg',
      'district': 'Kadıköy',
      'when': '16 Ağu · 12:00 - 16:00',
      'status': 'pending',
      'expiresAt': '2026-08-16T23:59:59Z',
      'remain': '21 saat 32 dakika',
    };

    test('should deserialize OfferModel correctly from JSON', () {
      final model = OfferModel.fromJson(offerJson);

      expect(model.id, 'off-1');
      expect(model.workerId, '1');
      expect(model.title, 'Garson');
      expect(model.place, 'Zarif Cheff Restaurant');
      expect(model.pay, '45.000');
      expect(model.payValue, 45000);
      expect(model.logo, 'assets/logos/zarif.svg');
      expect(model.district, 'Kadıköy');
      expect(model.when, '16 Ağu · 12:00 - 16:00');
      expect(model.status, OfferStatus.pending);
      expect(model.expiresAt, '2026-08-16T23:59:59Z');
      expect(model.remain, '21 saat 32 dakika');
    });

    test('should serialize OfferModel correctly to JSON', () {
      final model = OfferModel.fromJson(offerJson);
      final jsonMap = model.toJson();

      expect(jsonMap['id'], 'off-1');
      expect(jsonMap['title'], 'Garson');
      expect(jsonMap['status'], 'pending');
      expect(jsonMap['remain'], '21 saat 32 dakika');
    });

    test('should map OfferModel to OfferEntity properly', () {
      final model = OfferModel.fromJson(offerJson);
      final entity = model.toEntity();

      expect(entity, isA<OfferEntity>());
      expect(entity.id, model.id);
      expect(entity.title, model.title);
      expect(entity.isPending, isTrue);
      expect(entity.isAccepted, isFalse);
      expect(entity.isRejected, isFalse);
    });

    test('OfferEntity equality should hold for identical values', () {
      const entity1 = OfferEntity(
        id: '1',
        workerId: '1',
        title: 'Barista',
        place: 'Horizon Cafe',
        pay: '38.000',
        payValue: 38000,
        logo: 'assets/logos/horizon.svg',
        district: 'Kadıköy',
        when: '16 Ağu',
        status: OfferStatus.pending,
        expiresAt: '2026-08-16',
      );

      const entity2 = OfferEntity(
        id: '1',
        workerId: '1',
        title: 'Barista',
        place: 'Horizon Cafe',
        pay: '38.000',
        payValue: 38000,
        logo: 'assets/logos/horizon.svg',
        district: 'Kadıköy',
        when: '16 Ağu',
        status: OfferStatus.pending,
        expiresAt: '2026-08-16',
      );

      expect(entity1, equals(entity2));
    });
  });
}
