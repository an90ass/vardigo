import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/views/login_page.dart';
import '../../features/candidates/presentation/views/employer_candidates_page.dart';
import '../../features/offers/presentation/views/worker_offers_page.dart';
import '../constants/route_names.dart';
import '../di/injection.dart';

export '../constants/route_names.dart' show RouteNames;


abstract final class AppRoutes {
  static const String initial = RouteNames.login;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.initial:
      case RouteNames.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider<AuthBloc>(
            create: (_) => getIt<AuthBloc>(),
            child: const LoginPage(),
          ),
        );

      case RouteNames.employerCandidates:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const EmployerCandidatesPage(),
        );

      case RouteNames.workerOffers:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const WorkerOffersPage(),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Sayfa bulunamadı: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
