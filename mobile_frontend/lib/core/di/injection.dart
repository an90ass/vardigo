import 'package:get_it/get_it.dart';
import 'auth_injection.dart';
import 'candidates_injection.dart';
import 'offers_injection.dart';
import '../network/api_interface.dart';
import '../network/dio_client.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core Network Layer
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  getIt.registerLazySingleton<API>(() => getIt<DioClient>());

  // Feature Modules DI
  initAuthInjection(getIt);
  initCandidatesInjection(getIt);
  initOffersInjection(getIt);
}
