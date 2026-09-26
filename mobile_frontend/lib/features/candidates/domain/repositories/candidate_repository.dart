import 'package:dartz/dartz.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/error/failures.dart';
import '../entities/candidate_entity.dart';


abstract class CandidateRepository {
  Future<Either<Failure, CandidateListEntity>> getCandidates({
    CandidateTab? tab,
    CandidateSort? sort,
  });
}
