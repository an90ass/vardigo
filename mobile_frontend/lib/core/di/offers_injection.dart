import 'package:get_it/get_it.dart';
import '../../features/offers/data/datasources/offer_remote_data_source.dart';
import '../../features/offers/data/repositories/offer_repository_impl.dart';
import '../../features/offers/domain/repositories/offer_repository.dart';
import '../../features/offers/domain/usecases/accept_offer_usecase.dart';
import '../../features/offers/domain/usecases/create_offers_usecase.dart';
import '../../features/offers/domain/usecases/get_offers_usecase.dart';
import '../../features/offers/domain/usecases/reject_offer_usecase.dart';
import '../../features/offers/presentation/bloc/offer_bloc.dart';
import '../network/dio_client.dart';

void initOffersInjection(GetIt sl) {
  // Data Source
  sl.registerLazySingleton<OfferRemoteDataSource>(
    () => OfferRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // Repository
  sl.registerLazySingleton<OfferRepository>(
    () => OfferRepositoryImpl(remoteDataSource: sl<OfferRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton<GetOffersUseCase>(
    () => GetOffersUseCase(sl<OfferRepository>()),
  );
  sl.registerLazySingleton<AcceptOfferUseCase>(
    () => AcceptOfferUseCase(sl<OfferRepository>()),
  );
  sl.registerLazySingleton<RejectOfferUseCase>(
    () => RejectOfferUseCase(sl<OfferRepository>()),
  );
  sl.registerLazySingleton<CreateOffersUseCase>(
    () => CreateOffersUseCase(sl<OfferRepository>()),
  );

  // Presentation (Factory)
  sl.registerFactory<OfferBloc>(
    () => OfferBloc(
      getOffersUseCase: sl<GetOffersUseCase>(),
      acceptOfferUseCase: sl<AcceptOfferUseCase>(),
      rejectOfferUseCase: sl<RejectOfferUseCase>(),
    ),
  );
}
