enum ApiAuthType {
  bearerToken,
  none,
}

enum UserRole {
  employer('employer'),
  worker('worker');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String role) {
    return role == 'worker' ? UserRole.worker : UserRole.employer;
  }
}

enum CandidateTab {
  perfect('perfect'),
  similar('similar');

  final String value;
  const CandidateTab(this.value);
}

enum CandidateSort {
  recommended('recommended'),
  near('near'),
  rating('rating');

  final String value;
  const CandidateSort(this.value);
}

enum OfferStatus {
  pending('pending'),
  accepted('accepted'),
  rejected('rejected'),
  expired('expired');

  final String value;
  const OfferStatus(this.value);

  static OfferStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return OfferStatus.accepted;
      case 'rejected':
        return OfferStatus.rejected;
      case 'expired':
        return OfferStatus.expired;
      case 'pending':
      default:
        return OfferStatus.pending;
    }
  }
}

enum OfferStatusFilter {
  pending('pending'),
  answered('answered'),
  expired('expired');

  final String value;
  const OfferStatusFilter(this.value);
}

enum OfferSortOption {
  recommended('recommended'),
  pay('pay'),
  urgent('urgent');

  final String value;
  const OfferSortOption(this.value);
}

enum AppIconEnum {
  alarm('alarm'),
  back('back'),
  check('check'),
  close('close'),
  date('date'),
  eye('eye'),
  help('help'),
  levels('levels'),
  money('money'),
  online('online'),
  pin('pin'),
  send('send'),
  shield('shield'),
  sort('sort'),
  star('star');

  final String value;
  const AppIconEnum(this.value);
  String get svgPath => 'assets/icons/$value.svg';
}
