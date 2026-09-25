import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final UserRole role;

  const LoginRequested(this.role);

  @override
  List<Object?> get props => [role];
}

// Switch active user role (from Employer to Worker For the Testing Purposes)
class SwitchRoleRequested extends AuthEvent {
  final UserRole role;

  const SwitchRoleRequested(this.role);

  @override
  List<Object?> get props => [role];
}

// Auto-initialize authentication with default role (employer).
class InitializeDefaultAuth extends AuthEvent {
  const InitializeDefaultAuth();
}
