import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/offer_entity.dart';
import '../repositories/offer_repository.dart';

class CreateOffersUseCase {
  final OfferRepository repository;

  const CreateOffersUseCase(this.repository);

  Future<Either<Failure, List<OfferEntity>>> call(List<String> workerIds) async {
    return await repository.createOffers(workerIds);
  }
}
