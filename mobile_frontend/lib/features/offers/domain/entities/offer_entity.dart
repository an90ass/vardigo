import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';

class OfferEntity extends Equatable {
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
  final String? city;
  final String? note;

  const OfferEntity({
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
    this.city,
    this.note,
  });

  bool get isPending => status == OfferStatus.pending;
  bool get isAccepted => status == OfferStatus.accepted;
  bool get isRejected => status == OfferStatus.rejected;
  bool get isExpired => status == OfferStatus.expired;

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
        city,
        note,
      ];
}

class OfferListEntity extends Equatable {
  final int pendingCount;
  final List<OfferEntity> offers;

  const OfferListEntity({
    required this.pendingCount,
    required this.offers,
  });

  @override
  List<Object?> get props => [pendingCount, offers];
}
