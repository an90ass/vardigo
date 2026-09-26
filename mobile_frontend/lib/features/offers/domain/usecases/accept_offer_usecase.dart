import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/offer_entity.dart';
import '../repositories/offer_repository.dart';

/// UseCase responsible for accepting an interview offer.
class AcceptOfferUseCase {
  final OfferRepository repository;

  const AcceptOfferUseCase(this.repository);

  Future<Either<Failure, OfferEntity>> call(String offerId) async {
    return await repository.acceptOffer(offerId);
  }
}
