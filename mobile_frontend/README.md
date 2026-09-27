# VardiGO — Mobil Uygulama (Flutter Client)

VardiGO vaka çalışması (Case Study) kapsamında geliştirilmiş, **Feature-Based Clean Architecture** ve **BLoC** durum yönetimi prensiplerini temel alan modern Flutter mobil istemcisi.

---

## Hızlı Başlangıç ve Çalıştırma (Quick Start)

### 1. Bağımlılıkları İndirin
```bash
cd mobile_frontend
flutter pub get
```

### 2. Backend Bağlantısını Ayarlayın (.env)
`mobile_frontend/` dizini içinde `.env` dosyasını oluşturun veya düzenleyin:
```env
# Android Emülatör için:
API_BASE_URL=http://10.0.2.2:8000

# iOS Simülatör / Web için:
# API_BASE_URL=http://localhost:8000

# Fiziksel Cihaz (Gerçek Telefon) için:
# API_BASE_URL=http://<BILGISAYAR_IP_ADRESI>:8000
```

| Platform | Varsayılan Adres | Açıklama |
| :--- | :--- | :--- |
| **Android Emülatör** | `http://10.0.2.2:8000` | Host makinenin `localhost:8000` servisine erişim köprüsü. |
| **iOS Simülatör** | `http://localhost:8000` | Simülatör doğrudan host makinenin yerel ağını paylaşır. |
| **Fiziksel Cihaz** | `http://<YEREL_IP>:8000` | Telefon ve bilgisayar aynı Wi-Fi ağındayken yerel IP. |
| **Web / Masaüstü** | `http://localhost:8000` | Standart yerel port. |

### 3. Uygulamayı Başlatın

* **Seçenek 1: Referans Telefon Çerçevesi ile (Web / Chrome veya Emülatör):**
  Figma referans tasarımındaki iPhone 390×844 boyutlarını, siyah çerçeveyi, Dynamic Island'ı ve 9:41 durum çubuğunu simüle etmek için:
  ```bash
  # Web / Chrome üzerinde:
  flutter run -d chrome --dart-define=REFERENCE_FRAME=true

  # Emülatör üzerinde çerçeve ile:
  flutter run --dart-define=REFERENCE_FRAME=true
  ```

* **Seçenek 2: Standart Native Tam Ekran Olarak (Android Emülatör / iOS Simülatör):**
  ```bash
  flutter run
  ```

---

> [!TIP]
> ### Giriş ve Rol Seçimi (Test Hesapları)
> Uygulama açılış ekranında tek dokunuşla rol seçilerek anında ilgili ekrana geçiş yapılır:
> * **İşveren (Employer):** *Zarif Cheff Restoran* rolü seçilerek **Sayfa 1 — Eşleşen Personeller** ekranına girilir. Adaylar listelenir, filtrelenir ve çoklu seçimle görüşme talebi gönderilebilir.
> * **İş Arayan (Worker):** *Aday Demo Profili* rolü seçilerek **Sayfa 2 — Görüşme Talepleri** ekranına girilir. Gelen talepler incelenir, detayları açılır ve kabul/ret aksiyonları verilebilir.
> * **Oturum Kalıcılığı:** Seçilen rol `FlutterSecureStorage` ile kalıcı olarak saklanır. Çıkış yapmak veya rol değiştirmek için ekranın üst kısmındaki çıkış butonuna dokunabilirsiniz.

---

## Versiyonlar ve Sistem Gereksinimleri

| Teknoloji | Versiyon | Açıklama |
| :--- | :--- | :--- |
| **Flutter** | `3.44.4` (channel stable) | Mobil UI Framework |
| **Dart** | `3.12.2` (`sdk: '>=3.0.0 <4.0.0'`) | Programlama Dili |
| **Durum Yönetimi** | `flutter_bloc: ^8.1.6` | Reactive State Management |
| **Ağ Katmanı** | `dio: ^5.7.0` | HTTP Client (3x retry & token interceptor) |
| **Bağımlılık Enjeksiyonu** | `get_it: ^8.0.3` | Service Locator & DI Container |
| **Hata Yönetimi** | `dartz: ^0.10.1` | Fonksiyonel Hata Yönetimi (`Either<Failure, T>`) |
| **Responsive Altyapı** | `flutter_screenutil: ^5.9.3` | Figma 390×844 tabanlı tasarım ölçekleme |
| **Güvenli Depolama** | `flutter_secure_storage: ^9.2.2` | Şifrelenmiş token ve oturum saklama |

> **Not (JSON Serileştirme):** Projede model sayısı yalın ve kontrollü olduğu için ekstra kod üretim bağımlılıkları (`build_runner` / `json_serializable` / `.g.dart`) yerine temiz manuel serileştirme (`fromJson` / `toJson` / `toEntity`) tercih edilmiştir. Tip dönüşümleri ve fallback mekanizmaları şeffaf tutulmuştur.

---

## Ekranlar ve İş Mantığı (Screens & Features)

Uygulama, Figma referans tasarımlarına (390×844) ve vaka kurallarına tam uyumlu olarak 2 ana ekran ve 1 kimlik doğrulama modülünden oluşur:

### 1. Sayfa 1 — Eşleşen Personeller (İşveren Görünümü)
İşverenlerin açık pozisyonlarına başvuran veya eşleşen adayları incelediği ekrandır (`/candidates`).

| Özellik | Açıklama |
| :--- | :--- |
| **Segmented Tabs** | *Tam Eşleşen (26)* ve *Benzer Adaylar (16)* sekmeleri arasında yumuşak geçiş ve backend filtrelemesi (`tab=perfect` / `tab=similar`). |
| **Sıralama (Sort Filter)** | *Önerilen*, *En Yakın* ve *Puanı En Yüksek* filtreleri. Seçili filtreye tekrar dokunulduğunda varsayılana dönen toggle-to-reset mantığı. |
| **Aday Kartı Tasarımı** | 56×56 avatar, online durum göstergesi, eşleşme yüzdesi rozeti (`%92`), aday puanı, katılım oranı, unvan ve mesafe bilgileri. |
| **Çoklu Seçim & Bottom Bar** | Checkbox ile birden fazla aday seçebilme, seçilen aday sayısını gösteren yapışkan alt çubuk (*Sticky Bottom Bar*) ve toplu "Görüşme Talebi Gönder" aksiyonu. |

> **Sayaç Bütünlüğü (26 / 16):** Sekmelerdeki `(26)` ve `(16)` sayıları, Figma tasarımındaki toplam havuz meta verisini (`totalPerfect`, `totalSimilar`) temsil eder. İncelemeyi yormamak adına onlarca kopya aday yerine Figma'daki profiller sunulmuş; sayaçlar API meta yanıtından dinamik beslenmiştir.

---

### 2. Sayfa 2 — Görüşme Talepleri (İş Arayan Görünümü)
İş arayan personellerin şirketlerden gelen görüşme taleplerini yönettiği ekrandır (`/offers`).

| Özellik | Açıklama |
| :--- | :--- |
| **3 Sekmeli Durum Filtreleme** | *Bekleyen (3)*, *Cevaplanan (1)* ve *Süresi Dolan (0)* sekmeleri ile anlık talep durumu listeleme. |
| **Dinamik SVG Şirket Logoları** | Backend'den gelen SVG logo URL'lerini render eden, hata durumunda şirket baş harfiyle güvenli fallback sağlayan görsel altyapı. |
| **Acil Durum Geri Sayım Sayacı** | Kalan süresi 24 saatin altında olan taleplerde kırmızı/turuncu aciliyet etiketi ve dinamik kalan süre gösterimi. |
| **Genişletilebilir Detay (`AnimatedCrossFade`)** | Karta dokunulduğunda akıcı animasyonla açılan detay alanı: Şube/konum, randevu saati, pozisyon bilgileri ve şirket ek notları. |
| **Kabul / Ret Aksiyonları** | *İlgilenmiyorum* (Ret) ve *İlgileniyorum* (Kabul) butonları. Kart bazında bağımsız yükleme durumu ve SnackBar geri bildirimi. |
| **Sıralama Modalı (Sort Bottom Sheet)** | *Önerilen*, *Ücret (En Yüksek)* ve *Kalan Süre (En Acil)* seçenekleri içeren alt sayfa menüsü. |

---

## Mimari ve Klasör Yapısı

Proje, **Feature-Based Clean Architecture** (Özellik Bazlı Temiz Mimari) prensiplerine göre yapılandırılmıştır:

```text
lib/
├── core/                           # Uygulama genelinde paylaşılan ortak altyapı
│   ├── constants/                  # Boyutlar (AppDimensions), endpoint'ler, metinler (AppStrings)
│   ├── di/                         # GetIt bağımlılık enjeksiyon kayıtları
│   ├── enums/                      # Ortak enum tanımları
│   ├── network/                    # Dio istemcisi, interceptor'lar ve hata modelleri
│   ├── routes/                     # Rota yönetimi ve BLoC sağlayıcıları
│   ├── storage/                    # Token ve kullanıcı oturumu güvenli depolama
│   ├── theme/                      # Figma renk paleti, tipografi (Urbanist) ve tema
│   ├── utils/                      # AppLogger merkezi log sistemi
│   └── widgets/                    # Ortak bileşenler, PhoneFrame (iPhone 390×844 çerçevesi)
│
└── features/                       # Modüler özellik paketleri
    ├── auth/                       # Giriş ve oturum yönetimi (Data, Domain, Presentation)
    ├── candidates/                 # Sayfa 1: Eşleşen personeller modülü
    └── offers/                     # Sayfa 2: Görüşme talepleri modülü
```

Her özellik (`feature`) kendi içinde 3 bağımsız katmana ayrılır:
* **`domain/`:** Saf Dart iş kuralları, Entity modelleri ve UseCase'ler (Dış dünyadan tamamen bağımsız).
* **`data/`:** API veri kaynakları (`DataSources`), DTO modelleri (`fromJson/toEntity`) ve Repository uygulamaları.
* **`presentation/`:** BLoC durum yönetimi (`Bloc`, `Event`, `State`), sayfalar (`Views`) ve alt bileşenler (`Widgets`).

### Neden Feature-Based Clean Architecture? (Mimari Tercih Gerekçesi)

VardiGO vaka çalışmasında ekran sayısı sınırlı olsa dahi **Feature-Based Clean Architecture** tercih edilmesinin temel mühendislik gerekçeleri şunlardır:

1. **Çift Rol ve Alan İzolasyonu (Dual-Role & Domain Boundary):**
   Uygulama iki taban tabana zıt kullanıcı personası barındırır: **İşveren** (aday listeleme, eşleşme puanı, toplu teklif gönderme) ve **İş Arayan** (gelen teklifler, kabul/ret, aciliyet geri sayımı). Katman bazlı (*Layer-First: tüm bloc'ların veya modellerin tek bir global klasörde toplanması*) yaklaşım, bu iki iş akışının zamanla birbirine sıkı sıkıya bağlanmasına (*tight coupling*) yol açar. Özellik bazlı modüler yapı (`candidates/` ve `offers/`), alan sınırlarını (*Bounded Context*) kesin çizgilerle izole eder.

2. **Dış Bağımlılıklardan Arındırılmış Saf İş Mantığı (Pure Domain & 100% Testability):**
   `domain/` katmanında hiçbir Flutter UI veya üçüncü parti kütüphane bağımlılığı bulunmaz. Bu sayede `GetCandidatesUseCase`, `AcceptOfferUseCase` veya `RejectOfferUseCase` gibi iş kuralları, UI veya ağ katmanından bağımsız olarak saf Dart birim testleriyle (`36/36 passed`) %100 güvenilirlikle doğrulanabilir.

3. **Genişleyebilirlik ve Düşük Bilişsel Yük (Scalability & Low Cognitive Load):**
   Gelecekte sisteme eklenecek yeni modüller (örn: `messaging/`, `contracts/`, `profile/`), mevcut kod tabanına dokunmadan tak-çıkar (*plug-and-play*) mantığıyla entegre edilebilir. Geliştirici sadece ilgili özelliğin klasörüne odaklanarak bakım maliyetini ve bilişsel yükü minimuma indirir.

### Neden BLoC (Business Logic Component) Durum Yönetimi?

1. **Katı Durum Makinesi ve Tek Yönlü Veri Akışı (Unidirectional Data Flow):**
   VardiGO'daki çoklu aday seçimi, anlık filtreleme, aciliyet geri sayımı ve kabul/ret butonlarının kilitlenmesi gibi eşzamanlı UI durumları, BLoC'un `Event -> State` akışı sayesinde deterministik ve öngörülebilir şekilde yönetilir.
2. **UI'dan Bağımsız 100% Test Edilebilirlik:**
   State mantığı Widget ağacına doğrudan bağlı olmadığı için, `bloc_test` ile tüm durum geçişleri ve hata senaryoları saf Dart testleriyle saniyeler içinde doğrulanır (`36/36 passed`).
3. **Kurumsal Ölçeklenebilirlik ve Ekip Standardı:**
   Kurumsal Flutter projelerinde en yaygın ve olgun standart olan BLoC, kodun okunabilirliğini ve ekip içi sürdürülebilirliğini maksimize eder.

---

## Test ve Kalite Güvencesi (QA Matrix)

İş kuralları, BLoC durum geçişleri ve JSON ayrıştırma süreçleri için **36 adet otomatik test** yazılmıştır.

| Test Paketi | Kapsanan Alanlar | Test Sayısı | Durum |
| :--- | :--- | :---: | :---: |
| **`ApiResponseParserTest`** | Standart API zarfı (envelope) ayrıştırma, hata yakalama | 3 | Geçti |
| **`AuthBlocTest`** | Oturum kontrolü, giriş, çıkış ve hata durumları | 5 | Geçti |
| **`CandidateBlocTest`** | Aday listesi yükleme, sekme filtreleme, sıralama, çoklu seçim | 7 | Geçti |
| **`CandidateEntityTest`** | JSON serileştirme, entity dönüşümü, eşitlik kontrolleri | 5 | Geçti |
| **`OfferBlocTest`** | Talep listeleme, detay açma, kabul/ret işlemleri, filtreleme | 8 | Geçti |
| **`OfferEntityTest`** | Talep modeli ayrıştırma, metadata işleme, format kontrolleri | 7 | Geçti |
| **Widget & Smoke Test** | Temel bileşen ve uygulama başlatma testi | 1 | Geçti |
| **TOPLAM** | **Birim ve Durum Yönetimi Testleri** | **36/36** | **%100 Başarılı** |

### Testleri Çalıştırma:
```bash
# Tüm testleri koşturun:
flutter test

# Statik kod analizini çalıştırın:
flutter analyze
```

---

## CI/CD ve iOS Bulut Doğrulaması (Codemagic & Appetize.io)

Mobil uygulamanın bağımsız Apple macOS bulut ortamında hatasız derlendiği ve iOS 18.2 üzerinde çalıştığı kanıtlanmıştır:
* **Codemagic (Apple Silicon Mac M2):** CI/CD pipeline'ı üzerinde otomatik testler ve iOS Simulator (`Runner.app`) paketi başarıyla derlendi.
* **Appetize.io:** Web tabanlı gerçek iOS 18.2 (iPhone 14 Pro) simülatöründe arayüz render'ı ve ekran akışı doğrulandı.

<p align="center">
  <img src="https://github.com/user-attachments/assets/d2d53998-2d43-427d-881f-ff2d8a4881c6" alt="Codemagic CI/CD Build" width="49%" />
  <img src="https://github.com/user-attachments/assets/eab31031-ffe6-453e-8e46-788c0e753698" alt="Appetize iOS 18.2 Simulator" width="49%" />
  <br>
  <em><strong>Solda:</strong> Codemagic (Mac M2) CI/CD derleme ve test pipeline'ı &bull; <strong>Sağda:</strong> Appetize.io üzerinde iOS 18.2 (iPhone 14 Pro) canlı simülatör doğrulaması</em>
</p>

