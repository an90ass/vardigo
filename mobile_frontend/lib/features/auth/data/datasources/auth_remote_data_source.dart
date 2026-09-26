import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/network/api_response_parser.dart';
import '../../../../core/network/dio_client.dart';
import '../models/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> login(UserRole role);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  const AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<LoginResponseModel> login(UserRole role) async {
    final response = await dioClient.post(
      ApiEndpoints.login,
      data: {'role': role.value},
    );

    final data = ApiResponseParser.parseData(response.data);
    if (data is Map<String, dynamic>) {
      return LoginResponseModel.fromJson(data);
    }

    throw const FormatException('Geçersiz giriş yanıt verisi');
  }
}
