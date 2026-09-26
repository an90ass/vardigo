import 'package:dartz/dartz.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/repositories/offer_repository.dart';
import '../datasources/offer_remote_data_source.dart';

class OfferRepositoryImpl implements OfferRepository {
  final OfferRemoteDataSource remoteDataSource;

  const OfferRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OfferListEntity>> getOffers({
    OfferStatusFilter? filter,
  }) async {
    try {
      final model = await remoteDataSource.getOffers(filter: filter);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(_mapApiException(e));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Teklifler getirilirken beklenmeyen bir hata oluştu: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, OfferEntity>> acceptOffer(String offerId) async {
    try {
      final model = await remoteDataSource.acceptOffer(offerId);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(_mapApiException(e));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Teklif onaylanırken beklenmeyen bir hata oluştu: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, OfferEntity>> rejectOffer(String offerId) async {
    try {
      final model = await remoteDataSource.rejectOffer(offerId);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      return Left(_mapApiException(e));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Teklif reddedilirken beklenmeyen bir hata oluştu: $e',
      ));
    }
  }

  @override
  Future<Either<Failure, List<OfferEntity>>> createOffers(List<String> workerIds) async {
    try {
      final models = await remoteDataSource.createOffers(workerIds);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(_mapApiException(e));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Teklifler oluşturulurken bir hata oluştu: $e',
      ));
    }
  }

  Failure _mapApiException(ApiException e) {
    if (e.isConnectionError) {
      return NetworkFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
      );
    }
    if (e.isUnauthorized || e.isForbidden) {
      return AuthFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
      );
    }
    return ServerFailure(
      message: e.message,
      statusCode: e.statusCode,
      errorCode: e.errorCode,
    );
  }
}
