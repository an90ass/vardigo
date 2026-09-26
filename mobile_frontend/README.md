# Vardigo - Mobil Uygulama

Flutter Case Çalışması

---

##  Mimari ve Teknolojiler

Proje, **Feature-Based Clean Architecture** prensiplerine uygun olarak geliştirilmiştir.

* **Framework:** Flutter (Dart)
* **Durum Yönetimi (State Management):** `flutter_bloc`
* **Hata Yönetimi (Functional Error Handling):** `dartz` (`Either<Failure, T>`)
* **Servis Konumlandırıcı (Dependency Injection):** `get_it`
* **Ağ Katmanı (Networking):** `dio` (3x otomatik yeniden deneme destekli)
* **Güvenli Depolama (Storage):** `flutter_secure_storage`
* **Tasarım & Responsive:** `flutter_screenutil` (390×844 Figma token'ları, özel tema ve `Urbanist` tipografisi).
* **Log Sistemi:** `logger` tabanlı merkezi `AppLogger`.

> **Not (JSON Serileştirme):** Projede model sayısı yalın ve kontrollü olduğu için kod üretim araçları (`build_runner` / `json_serializable`) yerine manuel serileştirme (`fromJson` / `toJson` / `toEntity`) tercih edilmiştir. Bu sayede ekstra `.g.dart` kod karmaşası önlenmiş, tip dönüşümleri ve fallback mekanizmaları daha şeffaf tutulmuştur. İhtiyaç halinde `json_serializable` kolayca entegre edilebilir.

---

## Klasör Yapısı

```text
lib/
├── core/                   # Uygulama genelinde paylaşılan altyapı
│   ├── constants/          # Boyutlar, endpoint'ler, rota isimleri
│   ├── di/                 # Dependency Injection servis kayıtları
│   ├── enums/              # Ortak enum tanımları
│   ├── network/            # Dio istemcisi, hata yönetimi, interceptor'lar
│   ├── routes/             # Rota yapılandırması ve Bloc sağlayıcıları
│   ├── storage/            # Token ve kullanıcı oturumu depolama
│   ├── theme/              # Renkler, tipografi, gölgeler ve ThemeData
│   ├── utils/              # AppLogger ve yardımcı araçlar
│   └── widgets/            # Ortak bileşenler (Card, Checkbox, Switch vb.)
│
└── features/               # Özellik bazlı modüller (Clean Architecture)
    ├── auth/               # Giriş ve oturum yönetimi
    ├── candidates/         # Eşleşen personeller ekranı (İşveren görünümü)
    └── offers/             # Görüşme talepleri ekranı (İş arayan görünümü)
```
###  Modül İçi Katman Yapısı (Her Feature İçin)

Her modül, Clean Architecture prensiplerine göre kendi içinde 3 ana katmandan oluşur:

```text
feature_name/
├── domain/                 # İş Mantığı Katmanı (Saf Dart, bağımsız)
│   ├── entities/           # Temel iş nesneleri (Entity)
│   ├── repositories/       # Veri katmanı için arayüz sözleşmeleri (Abstract Repository)
│   └── usecases/           # Tek bir iş kuralını yürüten kullanım senaryoları (UseCase)
│
├── data/                   # Veri Katmanı
│   ├── datasources/        # Uzak (API) veya yerel veri kaynakları
│   ├── models/             # JSON dönüşümleri ve Entity eşleme (toEntity)
│   └── repositories/       # Domain arayüzlerinin somut uygulaması (Repository Impl)
│
└── presentation/           # Arayüz ve Durum Katmanı
    ├── bloc/               # Durum yönetimi (Bloc, Events, States)
    ├── views/              # Ana ekranlar (Screens / Pages)
    └── widgets/            # Ekrana özel alt bileşenler (Components)
```

---

## Mevcut Özellikler

### 1. Kimlik Doğrulama ve Kalıcı Oturum (Auth & Session Persistence)
* **Rol Bazlı Giriş:** İşveren (*Zarif Cheff Restoran*) veya İş Arayan (*Merve Y.*) olarak tek dokunuşla giriş yapabilme.
* **Kalıcı Oturum:** Kullanıcı çıkış yapmadığı sürece, uygulama kapatılıp açılsa bile oturum korunur ve kullanıcı doğrudan kendi ekranına yönlendirilir.
* **Akıcı Arayüz:** Oturum kontrolü sırasında ekran titremesini (flicker) önleyen yükleme durumu.

### 2. Ağ ve Log Altyapısı
* **DioClient:** Tüm isteklerde güvenli depolamadan alınan Bearer Token kullanımı.
* **AppLogger:** Ağ istekleri, yanıtlar ve oturum geçişlerini sade ve anlaşılır şekilde konsolda gösteren log altyapısı.

### 3. Eşleşen Personeller Ekranı (Screen 1 - İşveren Görünümü)
* **Temiz Mimari (Clean Architecture):** `CandidateEntity`, `GetCandidatesUseCase` ve `CandidateRepository` katmanları.
* **Segmented Tabs:** *Tam Eşleşen (26)* ve *Benzer Adaylar (16)* arasında dinamik geçiş ve API filtreleme.
* **Sıralama (Sort Filter):** *Önerilen*, *En Yakın* ve *Puanı En Yüksek* seçenekleri ile anlık liste güncelleme ve toggle-to-reset mekanizması.
* **Aday Kartı (Figma Uyumlu):** 56×56 avatar, online durum noktası, eşleşme yüzdesi rozeti (`%92`), puan, katılım oranı ve mesafe bilgileri.
* **Çoklu Seçim:** Checkbox ile aday seçimi ve yapışkan alt çubuktan (*Sticky Bottom Bar*) aday seçim kontrolü.

### 4. Görüşme Talepleri Modülü (Screen 2 - İş Arayan Görünümü)
* **Temiz Mimari (Clean Architecture):** `OfferEntity`, `GetOffersUseCase`, `GetOfferDetailUseCase`, `AcceptOfferUseCase`, `RejectOfferUseCase`, `CreateOffersUseCase` ve `OfferRepository` katmanları.
* **Durum Yönetimi (OfferBloc):** *Bekleyen (3)*, *Cevaplanan (1)* ve *Süresi Dolan (0)* filtreleri, kart bazında anlık kabul/ret işlem takibi (`processingOfferIds`), detay getirme yönetimi (`FetchOfferDetailEvent`) ve `AppLogger` entegrasyonu.
* **Sıralama Seçenekleri (Sort Bottom Sheet):** *Önerilen*, *Ücret (En Yüksek)* ve *Kalan Süre (En Acil)* sıralama seçenekleri. Seçilen seçeneğe tekrar dokunulduğunda varsayılan sıralamaya dönen toggle mekanizması.
* **Teklif Kartı (Figma Uyumlu):**
  * Şirket logosu gösterimi (SVG desteği ve güvenli fallback mekanizması).
  * Kalan süre sayacı (Son 24 saat kalan teklifler için kırmızı/turuncu aciliyet vurgusu).
  * Teklif aksiyonları (*İlgilenmiyorum* ve *İlgileniyorum* butonları).
  * Akıcı ve animasyonlu genişletilebilir detay alanı (`AnimatedCrossFade`) ile konum, şube, görüşme saati ve ek notların düzenli gösterimi.
* **Ağ Entegrasyonu:** `GET /api/offers`, `GET /api/offers/{id}`, `POST /api/offers/{id}/accept`, `POST /api/offers/{id}/reject` ve `POST /api/offers`.

### 5. Merkezi Tasarım Sistemi ve Metin Yönetimi (Design Tokens & Localization Ready)
* **AppDimensions:** Figma spellerine (390×844) birebir uyumlu merkezi padding, radius, ikon ve bileşen boyutları.
* **AppStrings:** Tüm UI metinlerinin tek bir kaynakta toplandığı ve gelecekte `flutter_localizations` (`.arb`) altyapısına kolayca taşınabilecek mimari yapı.
* **AppTheme & CustomColors:** `GoogleFonts.urbanist` tipografisi ve Figma renk paletini (`salaryBarBg`, `badgeGreen`, vb.) yöneten ThemeExtension altyapısı.


---

## Test ve Kalite Güvencesi (Testing & QA)

Projede iş mantığı, durum yönetimi ve veri ayrıştırma süreçleri için kapsamlı Unit ve BLoC testleri yazılmıştır (36/36 test başarılı).

* **Core & Network:** `ApiResponseParserTest` (API envelope ayrıştırma, hata fırlatma senaryoları).
* **Auth Modülü:** `AuthBlocTest` (Initial state, oturum kontrolü, başarılı/başarısız giriş ve çıkış senaryoları).
* **Candidates Modülü:** `CandidateBlocTest` ve `CandidateEntityTest` (Veri yükleme, sekme değiştirme, sıralama, çoklu seçim ve teklif gönderme senaryoları).
* **Offers Modülü:** `OfferBlocTest` ve `OfferEntityTest` (Teklif listeleme, filtreleme, detay getirme, kabul/ret işlemleri, model serileştirme ve metadata dönüşüm senaryoları).

Tüm testleri çalıştırmak için:
```bash
flutter test
```

---

## Sürekli Entegrasyon (CI/CD - GitHub Actions)

Projede `.github/workflows/flutter_ci.yml` üzerinden yapılandırılmış otomatik CI hattı bulunmaktadır:
* `main` / `master` dalına yapılan Push ve Pull Request'lerde otomatik tetiklenir.
* **Çift Katmanlı Caching:** Flutter SDK (`subosito/flutter-action`) ve Pub bağımlılıkları (`actions/cache`) önbelleğe alınarak hızlı derleme sağlanır.
* **Otomatik Kontroller:** `flutter analyze --no-fatal-infos` ve `flutter test --reporter expanded` adımları otomatik icra edilir.

---

## Kurulum ve Çalıştırma

### 1. Gereksinimler
* Flutter SDK (3.0.0 veya üzeri)
* Çalışan bir Vardigo backend servisi (FastAPI)

### 2. Bağımlılıkları Yükleyin
```bash
cd mobile_frontend
flutter pub get
```

### 3. Testleri Çalıştırın
```bash
flutter test
```

### 4. Çevre Değişkenleri (.env)
`mobile_frontend/` dizini altında bir `.env` dosyası oluşturun:
```env
API_BASE_URL=http://10.0.2.2:8000   # Android Emülatör için
# API_BASE_URL=http://localhost:8000 # iOS veya Web için
```

### 5. Uygulamayı Başlatın
```bash
flutter run
```
