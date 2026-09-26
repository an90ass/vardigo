import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/network/dio_client.dart';
import '../models/candidate_list_model.dart';

abstract class CandidateRemoteDataSource {
  Future<CandidateListModel> getCandidates({
    CandidateTab? tab,
    CandidateSort? sort,
  });
}

class CandidateRemoteDataSourceImpl implements CandidateRemoteDataSource {
  final DioClient dioClient;

  CandidateRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<CandidateListModel> getCandidates({
    CandidateTab? tab,
    CandidateSort? sort,
  }) async {
    final queryParams = <String, dynamic>{};
    if (tab != null) {
      queryParams['tab'] = tab.value;
    }
    if (sort != null) {
      queryParams['sort'] = sort.value;
    }

    final response = await dioClient.get(
      ApiEndpoints.candidates,
      authType: ApiAuthType.bearerToken,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      final innerData = rawData['data'] as Map<String, dynamic>? ?? rawData;
      return CandidateListModel.fromJson(innerData);
    }

    throw const FormatException('Beklenmeyen sunucu yanıt biçimi');
  }
}
