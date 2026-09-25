import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_response_entity.dart';
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
    on<LoginRequested>(_onLoginRequested);
    on<SwitchRoleRequested>(_onSwitchRoleRequested);
    on<InitializeDefaultAuth>(_onInitializeDefaultAuth);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginUseCase(event.role);

    await result.fold(
      (failure) async => emit(AuthError(failure.message)),
      (loginData) async {
        await saveTokenAndRole(loginData);

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
    emit(const AuthLoading());

    final result = await loginUseCase(event.role);

    await result.fold(
      (failure) async => emit(AuthError(failure.message)),
      (loginData) async {
        await saveTokenAndRole(loginData);

        emit(Authenticated(
          role: loginData.role,
          token: loginData.token,
          user: loginData.user,
        ));
      },
    );
  }

  Future<void> _onInitializeDefaultAuth(
    InitializeDefaultAuth event,
    Emitter<AuthState> emit,
  ) async {
    // Check if a role was previously saved in secure storage
    final savedRoleStr = await TokenStorage.getRole();
    final role = savedRoleStr != null
        ? UserRole.fromString(savedRoleStr)
        : UserRole.employer;

    add(LoginRequested(role));
  }

  Future<void> saveTokenAndRole(AuthResponseEntity loginData) async {
    await TokenStorage.saveToken(loginData.token);
    await TokenStorage.saveRole(loginData.role.value);
  }
}
