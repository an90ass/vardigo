import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vardigo/core/enums/app_enums.dart';
import 'package:vardigo/core/error/failures.dart';
import 'package:vardigo/features/candidates/domain/entities/candidate_entity.dart';
import 'package:vardigo/features/candidates/domain/repositories/candidate_repository.dart';
import 'package:vardigo/features/candidates/domain/usecases/get_candidates_usecase.dart';
import 'package:vardigo/features/candidates/presentation/bloc/candidate_bloc.dart';

class FakeCandidateRepository implements CandidateRepository {
  bool shouldFail = false;
  CandidateListEntity? mockData;

  @override
  Future<Either<Failure, CandidateListEntity>> getCandidates({
    CandidateTab? tab,
    CandidateSort? sort,
  }) async {
    if (shouldFail) {
      return const Left(ServerFailure(message: 'Adaylar yüklenemedi'));
    }

    return Right(
      mockData ??
          const CandidateListEntity(
            totalPerfect: 26,
            totalSimilar: 16,
            selectedHint: 1,
            candidates: [
              CandidateEntity(
                id: '1',
                name: 'Kıvanç D.',
                rating: '4.9',
                attend: '99%',
                km: '1.2 km',
                kmValue: 1.2,
                photo: 'assets/photos/cand1.png',
                isOnline: true,
                isPerfect: true,
                score: 98,
              ),
              CandidateEntity(
                id: '2',
                name: 'Büşra T.',
                rating: '4.7',
                attend: '95%',
                km: '3.4 km',
                kmValue: 3.4,
                photo: 'assets/photos/cand2.png',
                isOnline: false,
                isPerfect: true,
                score: 92,
              ),
            ],
          ),
    );
  }
}

void main() {
  late FakeCandidateRepository fakeRepository;
  late GetCandidatesUseCase getCandidatesUseCase;
  late CandidateBloc candidateBloc;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    fakeRepository = FakeCandidateRepository();
    getCandidatesUseCase = GetCandidatesUseCase(fakeRepository);
    candidateBloc = CandidateBloc(getCandidatesUseCase: getCandidatesUseCase);
  });

  tearDown(() {
    candidateBloc.close();
  });

  group('CandidateBloc', () {
    test('initial state has correct default values', () {
      expect(candidateBloc.state.status, equals(CandidateStatus.initial));
      expect(candidateBloc.state.activeTab, equals(CandidateTab.perfect));
      expect(candidateBloc.state.activeSort, equals(CandidateSort.recommended));
      expect(candidateBloc.state.candidates, isEmpty);
      expect(candidateBloc.state.selectedCandidateIds, isEmpty);
    });

    test('should emit loading and success when FetchCandidates succeeds', () async {
      candidateBloc.add(const FetchCandidates());

      await expectLater(
        candidateBloc.stream,
        emitsInOrder([
          isA<CandidateState>().having((s) => s.status, 'status', CandidateStatus.loading),
          isA<CandidateState>()
              .having((s) => s.status, 'status', CandidateStatus.success)
              .having((s) => s.candidates.length, 'candidates.length', 2)
              .having((s) => s.totalPerfect, 'totalPerfect', 26)
              .having((s) => s.selectedCandidateIds, 'selectedCandidateIds', {'1'}),
        ]),
      );
    });

    test('should emit loading and failure when FetchCandidates fails', () async {
      fakeRepository.shouldFail = true;
      candidateBloc.add(const FetchCandidates());

      await expectLater(
        candidateBloc.stream,
        emitsInOrder([
          isA<CandidateState>().having((s) => s.status, 'status', CandidateStatus.loading),
          isA<CandidateState>()
              .having((s) => s.status, 'status', CandidateStatus.failure)
              .having((s) => s.errorMessage, 'errorMessage', 'Adaylar yüklenemedi'),
        ]),
      );
    });

    test('should change tab and reload candidates on ChangeTab', () async {
      candidateBloc.add(const ChangeTab(CandidateTab.similar));

      await expectLater(
        candidateBloc.stream,
        emitsInOrder([
          isA<CandidateState>().having((s) => s.activeTab, 'activeTab', CandidateTab.similar),
          isA<CandidateState>()
              .having((s) => s.status, 'status', CandidateStatus.success)
              .having((s) => s.activeTab, 'activeTab', CandidateTab.similar),
        ]),
      );
    });

    test('should change sort and reload candidates on ChangeSort', () async {
      candidateBloc.add(const ChangeSort(CandidateSort.near));

      await expectLater(
        candidateBloc.stream,
        emitsInOrder([
          isA<CandidateState>().having((s) => s.activeSort, 'activeSort', CandidateSort.near),
          isA<CandidateState>()
              .having((s) => s.status, 'status', CandidateStatus.success)
              .having((s) => s.activeSort, 'activeSort', CandidateSort.near),
        ]),
      );
    });

    test('should toggle candidate selection correctly', () async {
      candidateBloc.add(const ToggleCandidateSelection('cand-10'));
      await expectLater(
        candidateBloc.stream,
        emits(
          isA<CandidateState>().having(
            (s) => s.selectedCandidateIds,
            'selectedCandidateIds',
            {'cand-10'},
          ),
        ),
      );

      candidateBloc.add(const ToggleCandidateSelection('cand-10'));
      await expectLater(
        candidateBloc.stream,
        emits(
          isA<CandidateState>().having(
            (s) => s.selectedCandidateIds,
            'selectedCandidateIds',
            isEmpty,
          ),
        ),
      );
    });

    test('should clear selection on ClearSelection', () async {
      candidateBloc.add(const ToggleCandidateSelection('cand-1'));
      await expectLater(
        candidateBloc.stream,
        emits(isA<CandidateState>().having((s) => s.selectedCandidateIds.length, 'length', 1)),
      );

      candidateBloc.add(const ClearSelection());
      await expectLater(
        candidateBloc.stream,
        emits(isA<CandidateState>().having((s) => s.selectedCandidateIds, 'selectedCandidateIds', isEmpty)),
      );
    });

    test('should emit successMessage on SubmitOffers when candidates are selected', () async {
      candidateBloc.add(const ToggleCandidateSelection('1'));
      await expectLater(
        candidateBloc.stream,
        emits(isA<CandidateState>().having((s) => s.selectedCandidateIds, 'selectedIds', {'1'})),
      );

      candidateBloc.add(const SubmitOffers());
      await expectLater(
        candidateBloc.stream,
        emits(
          isA<CandidateState>()
              .having((s) => s.selectedCandidateIds, 'selectedCandidateIds', isEmpty)
              .having((s) => s.successMessage, 'successMessage', isNotNull),
        ),
      );
    });

    test('should clear messages on ClearCandidateMessages', () async {
      fakeRepository.shouldFail = true;
      candidateBloc.add(const FetchCandidates());

      await expectLater(
        candidateBloc.stream,
        emitsInOrder([
          isA<CandidateState>(),
          isA<CandidateState>().having((s) => s.errorMessage, 'errorMessage', isNotNull),
        ]),
      );

      candidateBloc.add(const ClearCandidateMessages());
      await expectLater(
        candidateBloc.stream,
        emits(
          isA<CandidateState>()
              .having((s) => s.errorMessage, 'errorMessage', isNull)
              .having((s) => s.successMessage, 'successMessage', isNull),
        ),
      );
    });
  });
}
