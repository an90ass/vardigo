import 'package:get_it/get_it.dart';
import '../../features/candidates/data/datasources/candidate_remote_data_source.dart';
import '../../features/candidates/data/repositories/candidate_repository_impl.dart';
import '../../features/candidates/domain/repositories/candidate_repository.dart';
import '../../features/candidates/domain/usecases/get_candidates_usecase.dart';
import '../../features/candidates/presentation/bloc/candidate_bloc.dart';
import '../../features/offers/domain/usecases/create_offers_usecase.dart';
import '../network/dio_client.dart';

void initCandidatesInjection(GetIt sl) {
  // Data Source
  sl.registerLazySingleton<CandidateRemoteDataSource>(
    () => CandidateRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // Repository
  sl.registerLazySingleton<CandidateRepository>(
    () => CandidateRepositoryImpl(remoteDataSource: sl<CandidateRemoteDataSource>()),
  );

  // Use Case
  sl.registerLazySingleton<GetCandidatesUseCase>(
    () => GetCandidatesUseCase(sl<CandidateRepository>()),
  );

  // Presentation (Factory)
  sl.registerFactory<CandidateBloc>(
    () => CandidateBloc(
      getCandidatesUseCase: sl<GetCandidatesUseCase>(),
      createOffersUseCase: sl.isRegistered<CreateOffersUseCase>() ? sl<CreateOffersUseCase>() : null,
    ),
  );
}
