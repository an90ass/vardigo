import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const Failure({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, statusCode, errorCode];
}

/// Server or API response failure (400, 404, 409, 500)
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}

/// Network connectivity or timeout failure
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}

/// Authentication or authorization failure (401, 403)
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.statusCode,
    super.errorCode,
  });
}
