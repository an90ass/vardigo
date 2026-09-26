import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/network/api_response_parser.dart';
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

    final data = ApiResponseParser.parseData(response.data);
    if (data is Map<String, dynamic>) {
      return CandidateListModel.fromJson(data);
    }

    throw const FormatException('Geçersiz aday listesi verisi');
  }
}
