import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check if a persisted session exists in TokenStorage.
class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

/// Request authentication for a selected role.
class LoginRequested extends AuthEvent {
  final UserRole role;

  const LoginRequested(this.role);

  @override
  List<Object?> get props => [role];
}

/// Switch active user role (e.g. from Employer to Worker).
class SwitchRoleRequested extends AuthEvent {
  final UserRole role;

  const SwitchRoleRequested(this.role);

  @override
  List<Object?> get props => [role];
}

/// Logout and clear persisted session from TokenStorage.
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
