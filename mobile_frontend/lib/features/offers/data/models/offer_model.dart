import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';
import '../../domain/entities/offer_entity.dart';

class OfferModel extends Equatable {
  final String id;
  final String workerId;
  final String title;
  final String place;
  final String pay;
  final int payValue;
  final String logo;
  final String district;
  final String when;
  final OfferStatus status;
  final String expiresAt;
  final String? remain;

  const OfferModel({
    required this.id,
    required this.workerId,
    required this.title,
    required this.place,
    required this.pay,
    required this.payValue,
    required this.logo,
    required this.district,
    required this.when,
    required this.status,
    required this.expiresAt,
    this.remain,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String? ?? '',
      workerId: json['workerId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      place: json['place'] as String? ?? '',
      pay: json['pay']?.toString() ?? '',
      payValue: (json['payValue'] as num?)?.toInt() ?? 0,
      logo: json['logo'] as String? ?? '',
      district: json['district'] as String? ?? '',
      when: json['when'] as String? ?? '',
      status: OfferStatus.fromString(json['status'] as String? ?? 'pending'),
      expiresAt: json['expiresAt'] as String? ?? '',
      remain: json['remain'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workerId': workerId,
      'title': title,
      'place': place,
      'pay': pay,
      'payValue': payValue,
      'logo': logo,
      'district': district,
      'when': when,
      'status': status.value,
      'expiresAt': expiresAt,
      if (remain != null) 'remain': remain,
    };
  }

  OfferEntity toEntity() {
    return OfferEntity(
      id: id,
      workerId: workerId,
      title: title,
      place: place,
      pay: pay,
      payValue: payValue,
      logo: logo,
      district: district,
      when: when,
      status: status,
      expiresAt: expiresAt,
      remain: remain,
    );
  }

  @override
  List<Object?> get props => [
        id,
        workerId,
        title,
        place,
        pay,
        payValue,
        logo,
        district,
        when,
        status,
        expiresAt,
        remain,
      ];
}
