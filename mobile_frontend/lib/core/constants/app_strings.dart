abstract final class AppStrings {
  /* Note for Future Localization (l10n / i18n):

   All UI strings are centralized in this class to serve as a Single Source of Truth.
  To migrate to Flutter's native localization (`flutter_localizations` with `.arb` files):
  1. Add `flutter_localizations` to pubspec.yaml and set `generate: true`.
  2. Convert these static keys to `lib/l10n/app_tr.arb` and `app_en.arb`.
  3. Replace `AppStrings.key` references with `AppLocalizations.of(context)!.key`.

*/

  // Global / Common
  static const String appName = 'VardiGo';
  static const String retry = 'Tekrar Dene';
  static const String generalError = 'Bir hata oluştu.';
  static const String pageNotFound = 'Sayfa bulunamadı';

  // Auth / Login
  static const String loginTitle = 'VardiGo';
  static const String loginTitleSubtitle = 'İş Teklifi Al. Personel Bul.';
  static const String loginSubtitle = 'Devam etmek için profilinizi seçin';
  static const String employerLoginTitle = 'İşveren Girişi';
  static const String employerLoginSubtitle = 'Zarif Cheff Restoran';
  static const String workerLoginTitle = 'İş Arayan Girişi';
  static const String workerLoginSubtitle = 'Aday Demo Profili';
  static const String checkingSession = 'Oturum kontrol ediliyor...';
  static const String loggingIn = 'Giriş yapılıyor, lütfen bekleyin...';
  static const String sessionVerifying = 'Kayıtlı oturumunuz doğrulanıyor';
  static const String profilePreparing = 'Profiliniz ve oturumunuz hazırlanıyor';
  static const String developerCredit = 'Developed by Anas';

  // Screen 1: Eşleşen Personeller (Candidates)
  static const String matchingCandidatesTitle = 'Eşleşen Personeller';
  static String personnelFound(int count) => '$count personel bulundu';
  static String perfectMatchTab(int count) => '%100 Eşleşme ($count)';
  static String similarMatchTab(int count) => 'Benzer Personeller ($count)';
  static String personSelected(int count) => '$count kişi seçildi';

  static const String sortRecommended = 'Sırala: Önerilen';
  static const String sortNear = 'Sırala: En Yakın';
  static const String sortRating = 'Sırala: Puan';
  static const String sortBottomSheetTitle = 'Adayları Sırala';
  static const String sortOptionRecommended = 'Önerilen';
  static const String sortOptionNear = 'En Yakın';
  static const String sortOptionRating = 'Puana Göre';

  static const String salaryMatches = 'Ücret beklentisi uyuşuyor';
  static const String salaryNoMatch = 'Ücret beklentisi uyuşmuyor';
  static const String defaultSalary = '₺25.000 / ay';

  static String sendOfferButton(int count) => 'Görüşme Talebi Gönder ($count)';
  static const String helpCenterNotice = 'Yardım merkezi yakında aktif olacaktır.';
  static const String noCandidatesFound = 'Uygun aday bulunamadı.';
  static const String candidatesLoadError = 'Adaylar yüklenirken bir hata oluştu.';
  static String offersSelectedSuccess(int count) => '$count adaya teklif seçildi (Offers modülüne bağlanacak)';

  // Screen 2: Görüşme Talepleri (Offers)
  static const String interviewOffersTitle = 'Görüşme Talepleri';
  static String pendingOffersSubtitle(int count) => '$count talep yanıt bekliyor';
  static const String answeredOffersSubtitle = 'Cevaplanan talepler';
  static const String expiredOffersSubtitle = 'Süresi dolan talepler';

  static const String tabPending = 'Bekleyen';
  static const String tabAnswered = 'Cevaplanan';
  static const String tabExpired = 'Süresi Dolan';

  static const String emptyPendingOffers = 'Bekleyen talep yok';
  static const String emptyAnsweredOffers = 'Kabul veya red ettiğin talepler burada listelenir';
  static const String emptyExpiredOffers = 'Süresi dolan talep yok';

  static const String viewDetails = 'Detayları Gör';
  static const String hideDetails = 'Detayları Gizle';
  static const String interestedButton = 'İlgileniyorum';
  static const String notInterestedButton = 'İlgilenmiyorum';
  static const String acceptedBadge = 'Kabul Edildi';
  static const String rejectedBadge = 'Reddedildi';
  static const String expiredBadge = 'Süresi Doldu';

  static String offerRemainingPrefix = 'Teklifin sonlanmasına ';
  static String offerRemainingSuffix = ' kaldı.';
  static const String offerAcceptSuccess = 'Tebrikler! Görüşme teklifini kabul ettiniz.';
  static const String offerRejectSuccess = 'Görüşme teklifi reddedildi.';
}
