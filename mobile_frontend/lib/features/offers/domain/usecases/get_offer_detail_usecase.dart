import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/offer_entity.dart';
import '../repositories/offer_repository.dart';

class GetOfferDetailUseCase {
  final OfferRepository repository;

  const GetOfferDetailUseCase(this.repository);

  Future<Either<Failure, OfferEntity>> call(String offerId) async {
    return await repository.getOfferDetail(offerId);
  }
}
