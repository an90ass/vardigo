import 'package:dartz/dartz.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/candidate_entity.dart';
import '../../domain/repositories/candidate_repository.dart';
import '../datasources/candidate_remote_data_source.dart';

class CandidateRepositoryImpl implements CandidateRepository {
  final CandidateRemoteDataSource remoteDataSource;

  const CandidateRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CandidateListEntity>> getCandidates({
    CandidateTab? tab,
    CandidateSort? sort,
  }) async {
    try {
      final model = await remoteDataSource.getCandidates(tab: tab, sort: sort);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      if (e.isConnectionError) {
        return Left(NetworkFailure(
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
      if (e.isUnauthorized || e.isForbidden) {
        return Left(AuthFailure(
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Adaylar getirilirken beklenmeyen bir hata oluştu: $e',
      ));
    }
  }
}
