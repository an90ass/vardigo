import 'package:dartz/dartz.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/error/failures.dart';
import '../entities/offer_entity.dart';
import '../repositories/offer_repository.dart';

class GetOffersUseCase {
  final OfferRepository repository;

  const GetOffersUseCase(this.repository);

  Future<Either<Failure, OfferListEntity>> call({
    OfferStatusFilter? filter,
  }) async {
    return await repository.getOffers(filter: filter);
  }
}
