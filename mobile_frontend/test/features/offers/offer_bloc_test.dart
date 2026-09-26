import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vardigo/core/enums/app_enums.dart';
import 'package:vardigo/core/error/failures.dart';
import 'package:vardigo/features/offers/domain/entities/offer_entity.dart';
import 'package:vardigo/features/offers/domain/repositories/offer_repository.dart';
import 'package:vardigo/features/offers/domain/usecases/accept_offer_usecase.dart';
import 'package:vardigo/features/offers/domain/usecases/get_offers_usecase.dart';
import 'package:vardigo/features/offers/domain/usecases/reject_offer_usecase.dart';
import 'package:vardigo/features/offers/presentation/bloc/offer_bloc.dart';

class FakeOfferRepository implements OfferRepository {
  bool shouldFail = false;

  final sampleOffer = const OfferEntity(
    id: 'off-1',
    workerId: '1',
    title: 'Garson',
    place: 'Zarif Cheff Restaurant',
    pay: '45.000',
    payValue: 45000,
    logo: 'assets/logos/zarif.svg',
    district: 'Kadıköy',
    when: '16 Ağu · 12:00 - 16:00',
    status: OfferStatus.pending,
    expiresAt: '2026-08-16T23:59:59Z',
    remain: '21 saat 32 dakika',
  );

  @override
  Future<Either<Failure, OfferListEntity>> getOffers({
    OfferStatusFilter? filter,
  }) async {
    if (shouldFail) {
      return const Left(ServerFailure(message: 'Talepler yüklenemedi'));
    }

    return Right(
      OfferListEntity(
        pendingCount: 1,
        offers: [sampleOffer],
      ),
    );
  }

  @override
  Future<Either<Failure, OfferEntity>> acceptOffer(String offerId) async {
    if (shouldFail) {
      return const Left(ServerFailure(message: 'İşlem başarısız oldu'));
    }
    return Right(sampleOffer);
  }

  @override
  Future<Either<Failure, OfferEntity>> rejectOffer(String offerId) async {
    if (shouldFail) {
      return const Left(ServerFailure(message: 'İşlem başarısız oldu'));
    }
    return Right(sampleOffer);
  }

  @override
  Future<Either<Failure, List<OfferEntity>>> createOffers(List<String> workerIds) async {
    return const Right([]);
  }
}

void main() {
  late FakeOfferRepository fakeRepository;
  late GetOffersUseCase getOffersUseCase;
  late AcceptOfferUseCase acceptOfferUseCase;
  late RejectOfferUseCase rejectOfferUseCase;
  late OfferBloc offerBloc;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    fakeRepository = FakeOfferRepository();
    getOffersUseCase = GetOffersUseCase(fakeRepository);
    acceptOfferUseCase = AcceptOfferUseCase(fakeRepository);
    rejectOfferUseCase = RejectOfferUseCase(fakeRepository);

    offerBloc = OfferBloc(
      getOffersUseCase: getOffersUseCase,
      acceptOfferUseCase: acceptOfferUseCase,
      rejectOfferUseCase: rejectOfferUseCase,
    );
  });

  tearDown(() {
    offerBloc.close();
  });

  group('OfferBloc', () {
    test('initial state has correct default values', () {
      expect(offerBloc.state.status, equals(OfferPageStatus.initial));
      expect(offerBloc.state.activeFilter, equals(OfferStatusFilter.pending));
      expect(offerBloc.state.offers, isEmpty);
      expect(offerBloc.state.pendingCount, 0);
    });

    test('should emit loading and success on FetchOffers', () async {
      offerBloc.add(const FetchOffers());

      await expectLater(
        offerBloc.stream,
        emitsInOrder([
          isA<OfferState>().having((s) => s.status, 'status', OfferPageStatus.loading),
          isA<OfferState>()
              .having((s) => s.status, 'status', OfferPageStatus.success)
              .having((s) => s.offers.length, 'offers.length', 1)
              .having((s) => s.pendingCount, 'pendingCount', 1),
        ]),
      );
    });

    test('should emit failure on FetchOffers error', () async {
      fakeRepository.shouldFail = true;
      offerBloc.add(const FetchOffers());

      await expectLater(
        offerBloc.stream,
        emitsInOrder([
          isA<OfferState>().having((s) => s.status, 'status', OfferPageStatus.loading),
          isA<OfferState>()
              .having((s) => s.status, 'status', OfferPageStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', 'Talepler yüklenemedi'),
        ]),
      );
    });

    test('should change active filter on ChangeOfferFilter', () async {
      offerBloc.add(const ChangeOfferFilter(OfferStatusFilter.answered));

      await expectLater(
        offerBloc.stream,
        emitsInOrder([
          isA<OfferState>().having((s) => s.activeFilter, 'activeFilter', OfferStatusFilter.answered),
          isA<OfferState>().having((s) => s.status, 'status', OfferPageStatus.loading),
          isA<OfferState>().having((s) => s.status, 'status', OfferPageStatus.success),
        ]),
      );
    });

    test('should emit successMessage on AcceptOfferEvent', () async {
      offerBloc.add(const AcceptOfferEvent('off-1'));

      await expectLater(
        offerBloc.stream,
        emitsInOrder([
          isA<OfferState>().having((s) => s.processingOfferIds, 'processing', {'off-1'}),
          isA<OfferState>()
              .having((s) => s.processingOfferIds, 'processing', isEmpty)
              .having((s) => s.successMessage, 'successMessage', isNotNull),
          isA<OfferState>().having((s) => s.status, 'status', OfferPageStatus.success),
        ]),
      );
    });

    test('should emit successMessage on RejectOfferEvent', () async {
      offerBloc.add(const RejectOfferEvent('off-1'));

      await expectLater(
        offerBloc.stream,
        emitsInOrder([
          isA<OfferState>().having((s) => s.processingOfferIds, 'processing', {'off-1'}),
          isA<OfferState>()
              .having((s) => s.processingOfferIds, 'processing', isEmpty)
              .having((s) => s.successMessage, 'successMessage', isNotNull),
          isA<OfferState>().having((s) => s.status, 'status', OfferPageStatus.success),
        ]),
      );
    });

    test('should clear messages on ClearOfferMessages', () async {
      fakeRepository.shouldFail = true;
      offerBloc.add(const FetchOffers());

      await expectLater(
        offerBloc.stream,
        emitsInOrder([
          isA<OfferState>(),
          isA<OfferState>().having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ]),
      );

      offerBloc.add(const ClearOfferMessages());

      await expectLater(
        offerBloc.stream,
        emits(
          isA<OfferState>()
              .having((s) => s.errorMessage, 'errorMessage', isNull)
              .having((s) => s.successMessage, 'successMessage', isNull),
        ),
      );
    });
  });
}
