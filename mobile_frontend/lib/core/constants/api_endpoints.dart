abstract final class ApiEndpoints {
  static const String login = '/auth/login';
  static const String candidates = '/candidates';
  static const String offers = '/offers';
  static String offerAccept(String id) => '/offers/$id/accept';
  static String offerReject(String id) => '/offers/$id/reject';
  static String offerDetail(String id) => '/offers/$id';
}
