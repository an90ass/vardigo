import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';

abstract class OfferEvent extends Equatable {
  const OfferEvent();

  @override
  List<Object?> get props => [];
}

class FetchOffers extends OfferEvent {
  final bool refresh;

  const FetchOffers({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class FetchOfferDetailEvent extends OfferEvent {
  final String offerId;

  const FetchOfferDetailEvent(this.offerId);

  @override
  List<Object?> get props => [offerId];
}

class ChangeOfferFilter extends OfferEvent {
  final OfferStatusFilter filter;

  const ChangeOfferFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

class AcceptOfferEvent extends OfferEvent {
  final String offerId;

  const AcceptOfferEvent(this.offerId);

  @override
  List<Object?> get props => [offerId];
}

class RejectOfferEvent extends OfferEvent {
  final String offerId;

  const RejectOfferEvent(this.offerId);

  @override
  List<Object?> get props => [offerId];
}

class ClearOfferMessages extends OfferEvent {
  const ClearOfferMessages();
}
