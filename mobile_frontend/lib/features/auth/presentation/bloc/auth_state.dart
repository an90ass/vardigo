import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class Authenticated extends AuthState {
  final UserRole role;
  final String token;
  final UserEntity user;

  const Authenticated({
    required this.role,
    required this.token,
    required this.user,
  });

  @override
  List<Object?> get props => [role, token, user];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
