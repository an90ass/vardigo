import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vardigo/core/enums/app_enums.dart';
import 'package:vardigo/core/error/failures.dart';
import 'package:vardigo/core/storage/token_storage.dart';
import 'package:vardigo/features/auth/domain/entities/auth_response_entity.dart';
import 'package:vardigo/features/auth/domain/entities/user_entity.dart';
import 'package:vardigo/features/auth/domain/repositories/auth_repository.dart';
import 'package:vardigo/features/auth/domain/usecases/login_usecase.dart';
import 'package:vardigo/features/auth/presentation/bloc/auth_bloc.dart';

class FakeAuthRepository implements AuthRepository {
  bool shouldFail = false;

  @override
  Future<Either<Failure, AuthResponseEntity>> login(UserRole role) async {
    if (shouldFail) {
      return const Left(ServerFailure(message: 'Giriş başarısız oldu'));
    }

    return Right(
      AuthResponseEntity(
        token: 'dev-${role.value}',
        role: role,
        user: UserEntity(
          id: role == UserRole.employer ? 1 : 2,
          name: role == UserRole.employer ? 'Zarif Cheff' : 'Merve Y.',
          email: '${role.value}@vardigo.com',
          role: role,
        ),
      ),
    );
  }
}

void main() {
  late FakeAuthRepository fakeRepository;
  late LoginUseCase loginUseCase;
  late AuthBloc authBloc;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await TokenStorage.clear();
    fakeRepository = FakeAuthRepository();
    loginUseCase = LoginUseCase(fakeRepository);
    authBloc = AuthBloc(loginUseCase: loginUseCase);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      expect(authBloc.state, equals(const AuthInitial()));
    });

    test('should emit Unauthenticated when no token exists in storage', () async {
      authBloc.add(const CheckAuthStatus());

      await expectLater(
        authBloc.stream,
        emits(isA<Unauthenticated>()),
      );
    });

    test('should emit Authenticated on successful LoginRequested', () async {
      authBloc.add(const LoginRequested(UserRole.employer));

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<Authenticated>()
              .having((s) => s.role, 'role', UserRole.employer)
              .having((s) => s.token, 'token', 'dev-employer'),
        ]),
      );
    });

    test('should emit AuthError on failed LoginRequested', () async {
      fakeRepository.shouldFail = true;
      authBloc.add(const LoginRequested(UserRole.employer));

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthError>().having(
            (s) => s.message,
            'message',
            'Giriş başarısız oldu',
          ),
        ]),
      );
    });

    test('should emit Unauthenticated on LogoutRequested', () async {
      authBloc.add(const LogoutRequested());

      await expectLater(
        authBloc.stream,
        emits(isA<Unauthenticated>()),
      );
    });
  });
}
