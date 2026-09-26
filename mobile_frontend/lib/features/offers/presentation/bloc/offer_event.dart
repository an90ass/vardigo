import 'package:equatable/equatable.dart';
import '../../../../core/enums/app_enums.dart';

abstract class OfferEvent extends Equatable {
  const OfferEvent();

  @override
  List<Object?> get props => [];
}

// Initial or refresh load of offers
class FetchOffers extends OfferEvent {
  final bool refresh;

  const FetchOffers({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

// Changes the active offer filter tab (Bekleyenler, Cevaplananlar, Süresi Dolanlar)
class ChangeOfferFilter extends OfferEvent {
  final OfferStatusFilter filter;

  const ChangeOfferFilter(this.filter);

  @override
  List<Object?> get props => [filter];
}

// Worker accepts an interview offer
class AcceptOfferEvent extends OfferEvent {
  final String offerId;

  const AcceptOfferEvent(this.offerId);

  @override
  List<Object?> get props => [offerId];
}

// Worker rejects an interview offer
class RejectOfferEvent extends OfferEvent {
  final String offerId;

  const RejectOfferEvent(this.offerId);

  @override
  List<Object?> get props => [offerId];
}

// Clears transient snackbar messages
class ClearOfferMessages extends OfferEvent {
  const ClearOfferMessages();
}
