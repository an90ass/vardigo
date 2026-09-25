// This is Centralized API endpoint constants matching the backend specification.
abstract final class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';

  // Candidates (İşveren)
  static const String candidates = '/candidates';

  // Offers (İşveren & İş Arayan)
  static const String offers = '/offers';
  static String offerAccept(String id) => '/offers/$id/accept';
  static String offerReject(String id) => '/offers/$id/reject';
  static String offerDetail(String id) => '/offers/$id';
}
