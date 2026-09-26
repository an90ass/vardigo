import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

export 'auth_event.dart';
export 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;

  AuthBloc({
    required this.loginUseCase,
  }) : super(const AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<SwitchRoleRequested>(_onSwitchRoleRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.i('[AuthBloc] Checking persistent session status');
    final token = await TokenStorage.getToken();
    final roleStr = await TokenStorage.getRole();

    if (token != null && token.isNotEmpty && roleStr != null) {
      final role = UserRole.fromString(roleStr);
      AppLogger.i('[AuthBloc] Found active persistent session for role: ${role.value}');
      final defaultName =
          role == UserRole.employer ? 'Zarif Cheff Restoran' : 'Merve Y.';
      final defaultEmail =
          role == UserRole.employer ? 'isveren@vardigo.com' : 'isci@vardigo.com';

      emit(Authenticated(
        role: role,
        token: token,
        user: UserEntity(
          id: role == UserRole.employer ? 1 : 2,
          name: defaultName,
          email: defaultEmail,
          role: role,
        ),
      ));
    } else {
      AppLogger.d('[AuthBloc] No existing session found.');
      emit(const Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.i('[AuthBloc] Login requested for role: ${event.role.value}');
    emit(const AuthLoading());

    final result = await loginUseCase(event.role);

    await result.fold(
      (failure) async {
        AppLogger.e('[AuthBloc] Login failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (loginData) async {
        // Persist token & role securely to TokenStorage (Single Source of Truth)
        await TokenStorage.saveToken(loginData.token);
        await TokenStorage.saveRole(loginData.role.value);
        AppLogger.i('[AuthBloc] Login success: authenticated as ${loginData.role.value}');

        emit(Authenticated(
          role: loginData.role,
          token: loginData.token,
          user: loginData.user,
        ));
      },
    );
  }

  Future<void> _onSwitchRoleRequested(
    SwitchRoleRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.i('[AuthBloc] Switching role to: ${event.role.value}');
    emit(const AuthLoading());

    final result = await loginUseCase(event.role);

    await result.fold(
      (failure) async {
        AppLogger.e('[AuthBloc] Switch role failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (loginData) async {
        await TokenStorage.saveToken(loginData.token);
        await TokenStorage.saveRole(loginData.role.value);
        AppLogger.i('[AuthBloc] Switched role successfully: ${loginData.role.value}');

        emit(Authenticated(
          role: loginData.role,
          token: loginData.token,
          user: loginData.user,
        ));
      },
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    AppLogger.i('[AuthBloc] Logout requested. Clearing session...');
    await TokenStorage.clear();
    emit(const Unauthenticated());
  }
}
