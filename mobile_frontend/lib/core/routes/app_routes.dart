import 'package:flutter/material.dart';

import '../../features/candidates/presentation/views/employer_candidates_page.dart';
import '../../features/offers/presentation/views/worker_offers_page.dart';
import 'route_names.dart';

/// Centralized Application Routing configuration.
abstract final class AppRoutes {
  static const String initial = RouteNames.employerCandidates;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.initial:
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
