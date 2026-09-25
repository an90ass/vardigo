import 'package:dartz/dartz.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_response_entity.dart';
import '../repositories/auth_repository.dart';


class LoginUseCase {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call(UserRole role) async {
    return await repository.login(role);
  }
}
