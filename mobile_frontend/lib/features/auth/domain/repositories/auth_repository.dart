import 'package:dartz/dartz.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_response_entity.dart';

abstract class AuthRepository {

  Future<Either<Failure, AuthResponseEntity>> login(UserRole role);
}
