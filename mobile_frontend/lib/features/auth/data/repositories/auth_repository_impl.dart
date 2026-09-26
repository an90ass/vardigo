import 'package:dartz/dartz.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/auth_response_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthResponseEntity>> login(UserRole role) async {
    try {
      final model = await remoteDataSource.login(role);
      return Right(model.toEntity());
    } on ApiException catch (e) {
      if (e.isConnectionError) {
        return Left(NetworkFailure(
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
      if (e.isUnauthorized || e.isForbidden) {
        return Left(AuthFailure(
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
      return Left(ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
        errorCode: e.errorCode,
      ));
    } catch (e) {
      return Left(ServerFailure(
        message: 'Beklenmeyen bir kimlik doğrulama hatası oluştu: $e',
      ));
    }
  }
}
