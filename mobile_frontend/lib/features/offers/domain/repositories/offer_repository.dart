import 'package:dartz/dartz.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/error/failures.dart';
import '../entities/offer_entity.dart';

abstract class OfferRepository {
  Future<Either<Failure, OfferListEntity>> getOffers({
    OfferStatusFilter? filter,
  });

  Future<Either<Failure, OfferEntity>> getOfferDetail(String offerId);

  Future<Either<Failure, OfferEntity>> acceptOffer(String offerId);

  Future<Either<Failure, OfferEntity>> rejectOffer(String offerId);

  Future<Either<Failure, List<OfferEntity>>> createOffers(List<String> workerIds);
}
