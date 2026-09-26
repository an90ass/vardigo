import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/network/api_response_parser.dart';
import '../../../../core/network/dio_client.dart';
import '../models/offer_list_model.dart';
import '../models/offer_model.dart';

abstract class OfferRemoteDataSource {
  Future<OfferListModel> getOffers({OfferStatusFilter? filter});
  Future<OfferModel> getOfferDetail(String offerId);
  Future<OfferModel> acceptOffer(String offerId);
  Future<OfferModel> rejectOffer(String offerId);
  Future<List<OfferModel>> createOffers(List<String> workerIds);
}

class OfferRemoteDataSourceImpl implements OfferRemoteDataSource {
  final DioClient dioClient;

  OfferRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<OfferListModel> getOffers({OfferStatusFilter? filter}) async {
    final queryParams = <String, dynamic>{};
    if (filter != null) {
      queryParams['status_filter'] = filter.value;
    }

    final response = await dioClient.get(
      ApiEndpoints.offers,
      authType: ApiAuthType.bearerToken,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    final data = ApiResponseParser.parseData(response.data);
    if (data is Map<String, dynamic>) {
      return OfferListModel.fromJson(data);
    }

    throw const FormatException('Geçersiz teklif listesi verisi');
  }

  @override
  Future<OfferModel> getOfferDetail(String offerId) async {
    final response = await dioClient.get(
      ApiEndpoints.offerDetail(offerId),
      authType: ApiAuthType.bearerToken,
    );

    final data = ApiResponseParser.parseData(response.data);
    if (data is Map<String, dynamic>) {
      return OfferModel.fromJson(data);
    }

    throw const FormatException('Geçersiz teklif detay verisi');
  }

  @override
  Future<OfferModel> acceptOffer(String offerId) async {
    final response = await dioClient.post(
      ApiEndpoints.offerAccept(offerId),
      authType: ApiAuthType.bearerToken,
    );

    final data = ApiResponseParser.parseData(response.data);
    if (data is Map<String, dynamic>) {
      return OfferModel.fromJson(data);
    }

    throw const FormatException('Geçersiz teklif kabul verisi');
  }

  @override
  Future<OfferModel> rejectOffer(String offerId) async {
    final response = await dioClient.post(
      ApiEndpoints.offerReject(offerId),
      authType: ApiAuthType.bearerToken,
    );

    final data = ApiResponseParser.parseData(response.data);
    if (data is Map<String, dynamic>) {
      return OfferModel.fromJson(data);
    }

    throw const FormatException('Geçersiz teklif ret verisi');
  }

  @override
  Future<List<OfferModel>> createOffers(List<String> workerIds) async {
    final response = await dioClient.post(
      ApiEndpoints.offers,
      authType: ApiAuthType.bearerToken,
      data: {'workerIds': workerIds},
    );

    final data = ApiResponseParser.parseData(response.data);
    if (data is Map<String, dynamic>) {
      final createdList = data['created'] as List<dynamic>? ?? [];
      return createdList
          .whereType<Map<String, dynamic>>()
          .map(OfferModel.fromJson)
          .toList();
    }

    return [];
  }
}
