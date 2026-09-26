import 'package:equatable/equatable.dart';
import '../../domain/entities/offer_entity.dart';
import 'offer_model.dart';

class OfferListModel extends Equatable {
  final int pendingCount;
  final List<OfferModel> offers;

  const OfferListModel({
    required this.pendingCount,
    required this.offers,
  });

  factory OfferListModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['offers'] as List<dynamic>? ?? [];
    final parsedOffers = rawList
        .whereType<Map<String, dynamic>>()
        .map(OfferModel.fromJson)
        .toList();

    return OfferListModel(
      pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
      offers: parsedOffers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pendingCount': pendingCount,
      'offers': offers.map((o) => o.toJson()).toList(),
    };
  }

  OfferListEntity toEntity() {
    return OfferListEntity(
      pendingCount: pendingCount,
      offers: offers.map((o) => o.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [pendingCount, offers];
}
