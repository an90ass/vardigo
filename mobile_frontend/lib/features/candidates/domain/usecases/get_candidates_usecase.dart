import 'package:dartz/dartz.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/error/failures.dart';
import '../entities/candidate_entity.dart';
import '../repositories/candidate_repository.dart';

class GetCandidatesUseCase {
  final CandidateRepository repository;

  const GetCandidatesUseCase(this.repository);

  Future<Either<Failure, CandidateListEntity>> call({
    CandidateTab? tab,
    CandidateSort? sort,
  }) async {
    return await repository.getCandidates(tab: tab, sort: sort);
  }
}
