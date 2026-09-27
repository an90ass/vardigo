# VardiGO — Case Study (Mobil & Backend Monorepo)

Bu depo, **VardiGO** vaka çalışması (Case Study) kapsamında geliştirilmiş modern **Flutter mobil istemcisi** ile **FastAPI REST API backend servisini** tek bir monorepo altında birleştiren kapsamlı teslimat dokümantasyonudur.

---

## İçindekiler
1. [Hızlı Başlangıç (Kurulum ve Çalıştırma)](#1-hızlı-başlangıç-kurulum-ve-çalıştırma)
2. [Versiyonlar ve Geliştirme Ortamı](#2-versiyonlar-ve-geliştirme-ortamı)
3. [Proje Mimarisi ve Monorepo Yapısı](#3-proje-mimarisi-ve-monorepo-yapısı)
4. [Minimum Test Senaryosu (Resmi 7 Adımlı Doğrulama)](#4-minimum-test-senaryosu-resmi-7-adımlı-doğrulama)
5. [Mobil Mimari ve Ekran Detayları](#5-mobil-mimari-ve-ekran-detayları)
6. [Backend Mimarisi ve Eşleştirme Motoru](#6-backend-mimarisi-ve-eşleştirme-motoru)
7. [Kimlik Doğrulama ve Test Hesapları](#7-kimlik-doğrulama-ve-test-hesapları)
8. [Ayrıntılı API Sözleşmesi ve Uç Noktalar](#8-ayrıntılı-api-sözleşmesi-ve-uç-noktalar)
9. [İş Kuralları ve Hata Yönetimi (Edge Cases)](#9-iş-kuralları-ve-hata-yönetimi-edge-cases)
10. [Test ve Kalite Güvencesi (QA Matrix)](#10-test-ve-kalite-güvencesi-qa-matrix)

---

## 1. Hızlı Başlangıç (Kurulum ve Çalıştırma)

Projeyi hem backend hem mobil tarafıyla hızlıca ayağa kaldırmak için aşağıdaki adımları takip edebilirsiniz:

### A) Backend Servisini Başlatma

#### Seçenek 1 — Docker Compose ile (Önerilen & Tek Komut):
> *Önkoşul: Docker Desktop veya Docker daemon servisinin arka planda çalışıyor olması gerekmektedir.*
```bash
# Proje ana dizininde (vardigo/):
docker compose up --build
```
* **API Adresi:** `http://localhost:8000`
* **İnteraktif Swagger Dokümantasyonu:** `http://localhost:8000/docs`

#### Seçenek 2 — Yerel Python Ortamı ile:
```bash
cd backend
python -m venv .venv

# Sanal ortamı aktif etme (Windows):
.\.venv\Scripts\activate
# (macOS / Linux):
# source .venv/bin/activate

# Bağımlılıkları yükleme ve başlatma
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

---

### B) Mobil Uygulamayı Başlatma (Flutter)

```bash
cd mobile_frontend
flutter pub get
```

#### 1. Referans Telefon Çerçevesi ile Çalıştırma (Web / Chrome veya Emülatör):
Figma referans tasarımındaki iPhone 390×844 boyutlarını, siyah çerçeveyi, Dynamic Island'ı ve 9:41 durum çubuğunu simüle etmek için:
```bash
# Web / Chrome üzerinde:
flutter run -d chrome --dart-define=REFERENCE_FRAME=true

# Emülatör veya cihaz üzerinde çerçeve ile:
flutter run --dart-define=REFERENCE_FRAME=true
```

#### 2. Standart Native Tam Ekran Olarak Çalıştırma (Android Emülatör / iOS Simülatör):
```bash
flutter run
```

> **Ağ Yapılandırması (`mobile_frontend/.env`):**
> * **Android Emülatör:** `API_BASE_URL=http://10.0.2.2:8000`
> * **iOS Simülatör / Web:** `API_BASE_URL=http://localhost:8000`
> * **Fiziksel Cihaz (Gerçek Telefon):** `API_BASE_URL=http://<BILGISAYAR_IP_ADRESI>:8000`

---

## 2. Versiyonlar ve Geliştirme Ortamı

| Teknoloji | Versiyon | Açıklama |
| :--- | :--- | :--- |
| **Flutter** | `3.44.4` (channel stable) | Mobil UI Framework |
| **Dart** | `3.12.2` (`sdk: '>=3.0.0 <4.0.0'`) | Programlama Dili |
| **Durum Yönetimi** | `flutter_bloc: ^8.1.6` | Reaktif BLoC Pattern |
| **Ağ Katmanı** | `dio: ^5.7.0` | HTTP Client (3x Retry, Token Interceptor) |
| **Bağımlılık Enjeksiyonu** | `get_it: ^8.0.3` | Service Locator & DI Container |
| **Hata Yönetimi** | `dartz: ^0.10.1` | Fonksiyonel Hata Yönetimi (`Either<Failure, T>`) |
| **Responsive Altyapı** | `flutter_screenutil: ^5.9.3` | Figma 390×844 Tasarım Ölçekleme |
| **Güvenli Depolama** | `flutter_secure_storage: ^9.2.2` | Şifrelenmiş Token ve Oturum Saklama |
| **Python** | `3.10+ / 3.11` | Backend Çalışma Zamanı |
| **FastAPI** | `0.110.0+` | Asenkron REST API Framework |
| **Veritabanı ORM** | `SQLAlchemy 2.0+` | SQLite (Varsayılan) / PostgreSQL Desteği |
| **Veri Doğrulama** | `Pydantic v2` | Tip Güvenliği & DTO Şemaları |

---

## 3. Proje Mimarisi ve Monorepo Yapısı

<p align="center">
  <img src="https://github.com/user-attachments/assets/a8ae1051-4ae6-4007-a514-d27016ec41ed" alt="VardiGO Sistem ve Katman Mimarisi" width="650" />
</p>

```text
vardigo/
├── mobile_frontend/                # Flutter Mobil Uygulaması (Feature-Based Clean Architecture)
│   ├── assets/                     # SVG İkonlar, Şirket Logoları ve Aday Avatarları
│   ├── lib/
│   │   ├── core/                   # Ortak Tasarım Token'ları, Ağ, Tema, Depolama
│   │   │   ├── constants/          # AppDimensions, AppStrings, RouteNames, ApiEndpoints
│   │   │   ├── di/                 # GetIt Bağımlılık Enjeksiyonu (Service Locator)
│   │   │   ├── enums/              # AppIconEnum, UserRole, OfferStatus
│   │   │   ├── network/            # DioClient (3x Retry, Token Interceptor, ApiUrl)
│   │   │   ├── routes/             # AppRoutes & Sayfa Yönlendirme
│   │   │   ├── storage/            # FlutterSecureStorage Oturum ve Token Kalıcılığı
│   │   │   ├── theme/              # Urbanist Tipografi, Figma Renk Paleti, Gölgeler
│   │   │   └── widgets/            # PhoneFrame (iPhone 390×844), Custom Controls
│   │   └── features/               # Feature-Based Modüler Katmanlar (Clean Architecture)
│   │       ├── auth/               # Kimlik Doğrulama ve Rol Yönetimi
│   │       │   ├── data/           # [DATA] Auth DataSource, Login Models & Repositories
│   │       │   ├── domain/         # [DOMAIN] User Entity & Login UseCase
│   │       │   └── presentation/   # [PRESENTATION] AuthBloc, LoginPage & Widgets
│   │       ├── candidates/         # Sayfa 1: Eşleşen Personeller (İşveren Görünümü)
│   │       │   ├── data/           # [DATA] Candidate DataSource, DTOs & Repository Impl
│   │       │   ├── domain/         # [DOMAIN] Candidate Entity & GetCandidatesUseCase
│   │       │   └── presentation/   # [PRESENTATION] CandidateBloc, CandidateViews & CandidateCard
│   │       └── offers/             # Sayfa 2: Görüşme Talepleri (İş Arayan Görünümü)
│   │           ├── data/           # [DATA] Offer DataSource, DTOs & Repository Impl
│   │           ├── domain/         # [DOMAIN] Offer Entity, Accept/Reject/Detail UseCases
│   │           └── presentation/   # [PRESENTATION] OfferBloc, OfferViews & OfferCard
│   └── test/                       # 36/36 Unit & BLoC Test Paketi
│
├── backend/                        # FastAPI REST Servisi (MVC Mimarisi)
│   ├── app/
│   │   ├── config/                 # Veritabanı ve Ortam Ayarları (SQLite / PostgreSQL)
│   │   ├── data/                   # Sabit Seed Verileri (Candidates & Offers JSON)
│   │   ├── dependencies/           # Rol Yetkilendirme & Servis Enjeksiyonları
│   │   ├── models/                 # [MODEL] SQLAlchemy ORM Varlıkları (User, Candidate, Offer)
│   │   ├── repositories/           # [REPOSITORY] Base & Entity CRUD Sorgu Katmanları
│   │   ├── routes/                 # [CONTROLLER] Auth, Candidates, Offers Router'ları
│   │   ├── schemas/                # [DTO] Pydantic v2 Tip Güvenli Veri Şemaları
│   │   ├── services/               # [İŞ MANTIĞI] Eşleştirme Motoru, Teklif & Seed Servisleri
│   │   └── main.py                 # FastAPI Uygulama Girişi & CORS Yapılandırması
│   ├── Dockerfile                  # Backend Konteyner İmaj Yapılandırması
│   └── requirements.txt            # Python Bağımlılıkları
│
├── codemagic.yaml                  # Codemagic Mac M2 CI/CD ve iOS Simulator Derleme Yapılandırması
├── docker-compose.yml              # Tek Komutla Servis Başlatma Yapılandırması
├── SUREC.txt                       # Geliştirme Süreci ve Karşılaşılan Zorluklar Notu
└── test_guide.txt                  # Adım Adım Doğrulama ve Test Kılavuzu
```

---

## 4. Minimum Test Senaryosu (Resmi 7 Adımlı Doğrulama)

Değerlendirme sürecinde uçtan uca akışı doğrulamak için aşağıdaki adımları sırasıyla uygulayabilirsiniz:

* **ADIM 1: İşveren Girişi ve Aday Listesi (`GET /api/candidates`)**
  * Giriş ekranında "İşveren Girişi (Zarif Cheff Restoran)" butonuna dokunun.
  * Sayfa 1 açılır, 4 aday başarıyla listelenir; sekmeler ve sıralama filtreleri test edilebilir.

* **ADIM 2: Çoklu Aday Seçimi ve Teklif Gönderme (`POST /api/offers`)**
  * Listeden 2 adayı (Örn: "Merve Aydın" ve "Derya Şen") seçin.
  * "Görüşme Talebi Gönder (2)" butonuna dokunun. Teklifler oluşturulur ve yeşil SnackBar gösterilir.

* **ADIM 3: İş Arayan Girişi ve Bekleyen Teklifler (`GET /api/offers?status=pending`)**
  * Çıkış yapıp "İş Arayan Girişi (Aday Demo Profili)" ile giriş yapın.
  * Sayfa 2 "Bekleyen" sekmesinde açılır; gönderilen 2 yeni teklif + seed teklifleri eksiksiz listelenir.

* **ADIM 4: Teklif Detayını İnceleme (`GET /api/offers/{id}`)**
  * Teklif kartındaki "Detayları Gör" butonuna dokunun. Şube ve lokasyon bilgisi animasyonla (`AnimatedCrossFade`) açılır.

* **ADIM 5: Teklifleri Yanıtlama (`POST /api/offers/{id}/accept & reject`)**
  * Tekliflerden birinde "İlgileniyorum" (Kabul), diğerinde "İlgilenmiyorum" (Ret) butonuna dokunun.
  * İşlem sırasında butonlar devre dışı kalır (Opacity 0.5) ve listeden kaldırılır.

* **ADIM 6: Cevaplanan Teklifleri Doğrulama (`GET /api/offers?status=answered`)**
  * "Cevaplanan" sekmesine geçin. Kabul edilen teklif yeşil rozetle, reddedilen kırmızı rozetle listelenir (2 kayıt).

* **ADIM 7: Sayfa Yenileme ve Durum Kalıcılığı (Persistence)**
  * Sayfayı yenileyin (Pull-to-Refresh); tüm durumların veritabanında korunduğu doğrulanır.

---

## 5. Mobil Mimari ve Ekran Detayları

Proje, **Feature-Based Clean Architecture** prensiplerine göre inşa edilmiştir.

### Neden Feature-Based Clean Architecture & BLoC?
1. **Çift Rol ve Alan İzolasyonu (Dual-Role Domain Boundary):** İşveren ve İş Arayan modülleri birbirinden tamamen izole edilmiştir.
2. **Neden BLoC Durum Yönetimi (Finite State Machine):** Çift rollü akışta ve kritik iş kurallarında (çoklu seçim, dinamik aciliyet geri sayımı, kabul/ret idempotency kilidi); durum geçişlerini deterministik kılan, UI'dan bağımsız saf Event/State ayrımı sunan ve kurumsal Flutter standartlarına en uygun BLoC deseni tercih edilmiştir.
3. **Saf İş Mantığı & 100% Test Edilebilirlik:** `domain/` katmanında hiçbir UI veya üçüncü parti kütüphane bağımlılığı bulunmaz; tüm use case'ler ve BLoC durumları saf Dart testleriyle (`36/36 passed`) doğrulanmıştır.
4. **Modüler Genişleyebilirlik:** Yeni eklenecek özellikler mevcut kod tabanına dokunmadan tak-çıkar mantığıyla eklenebilir.




### Ekranlar ve Fonksiyonlar
<p align="center">
  <video src="https://github.com/user-attachments/assets/39bf9407-70d5-4445-a69a-7305c5bb6e82" width="390" controls></video>
  <br>
  <em><strong>Uçtan Uca Demo Akışı:</strong> İşveren ekranında aday filtreleme, çoklu seçim ve bekleyen teklifi olmayan adaylara toplu teklif gönderimi &rarr; İş arayan profilinde bekleyen tekliflerin incelenmesi ve kabul/ret yanıtlarının verilmesi. (Not: Genişletilebilir "Detayları Gör" alanı bu kısa kayıtta yer almamaktadır.)</em>
</p>

#### 1. Sayfa 1 — Eşleşen Personeller (İşveren Görünümü — `/candidates`)
* **Segmented Tabs:** *%100 Eşleşme* ve *Benzer Personeller* sekmeleri arasında backend filtrelemesi (`tab=perfect` / `tab=similar`).
* **Sıralama Filtreleri:** *Önerilen*, *En Yakın* ve *Puana Göre* filtreleri; aynı filtreye tekrar tıklandığında varsayılana dönen *Toggle-to-Reset* mekanizması.
* **Aday Kartı:** 56×56 avatar, online durum göstergesi, puan, katılım oranı, unvan ve mesafe bilgileri.
* **Çoklu Seçim & Sticky Bottom Bar:** Checkbox ile birden fazla aday seçebilme, seçilen kişi sayısını gösteren yapışkan alt bar ve toplu *Görüşme Talebi Gönder* aksiyonu.

#### 2. Sayfa 2 — Görüşme Talepleri (İş Arayan Görünümü — `/offers`)
* **3 Sekmeli Durum Filtreleme:** *Bekleyen*, *Cevaplanan* ve *Süresi Dolan* sekmeleri.
* **Dinamik SVG Logo:** Backend'den gelen SVG logo URL'lerini render eden, fallback monogramlı görsel altyapı.
* **Acil Durum Geri Sayım Sayacı:** Kalan süresi 24 saatin altındaki tekliflerde kırmızı/turuncu aciliyet etiketi ve anlık geri sayım.
* **Genişletilebilir Detay (`AnimatedCrossFade`):** "Detayları Gör" butonuna basıldığında `GET /api/offers/{id}` ile şube, lokasyon ve ek notların akıcı animasyonla açılması.
* **Kabul / Ret Aksiyonları:** *İlgilenmiyorum* (Ret) ve *İlgileniyorum* (Kabul) butonları; işlem sırasında Opacity 0.5 ile buton deaktivasyonu (Çift tıklama / Idempotency koruması).

---

## 6. Backend Mimarisi ve Eşleştirme Motoru

Backend servisi, sorumlulukların net ayrıldığı **MVC (Model-View-Controller)** ve Servis Katmanı mimarisiyle inşa edilmiştir:

* **Model (M):** SQLAlchemy ORM varlıkları (`UserORM`, `CandidateORM`, `OfferORM`) ve Pydantic v2 DTO şemaları.
* **View (V):** Standart JSON API Zarfı (`ApiResponse<T>`) ve interaktif `/docs` Swagger arayüzü.
* **Controller (C) & Services:** HTTP isteklerini karşılayan Router'lar (`routes/`) ve eşleştirme motoru/iş mantığı katmanı (`services/`).

### Eşleştirme Motoru Puanlama Algoritması (Matching Engine)

Adaylar ile açık iş pozisyonu arasındaki eşleşme skoru (`match_score`), 100 puan üzerinden ağırlıklı kurallarla hesaplanır:

| Kriter | Ağırlık | Kural Açıklaması |
| :--- | :---: | :--- |
| **Unvan Uyumu (Title Match)** | **35 Puan** | Adayın unvanı ile iş pozisyonu tam eşleşiyorsa 35, kısmi eşleşiyorsa 20 puan. |
| **Konum & Mesafe (Location)** | **25 Puan** | Aynı ilçe/şehirde ise 25 puan, komşu lokasyon kademeli puanlama. |
| **Çalışma Tipi (Employment Type)** | **20 Puan** | Tam zamanlı, yarı zamanlı veya vardiyalı çalışma tercihi uyumu. |
| **Sektör & Deneyim (Industry)** | **20 Puan** | Hizmet/Restoran sektörü deneyimi ve geçmiş çalışma uyumu. |

* **%100 Eşleşen Sekmesi:** `match_score >= 80` olan adaylar.
* **Benzer Personeller Sekmesi:** `match_score < 80` olan adaylar.

### Veritabanı ve PostgreSQL Geçişi
* **SQLite (Varsayılan):** Zero-config ve taşınabilirlik için SQLite (`sqlite_vardigo.db`) kullanılır; veriler `SeedService` ile otomatik tohumlanır ve durum kalıcıdır.
* **PostgreSQL Geçişi:** `app/config/database.py` dinamik `DATABASE_URL` ortam değişkenini destekler. PostgreSQL URL'i verildiğinde otomatik bağlantı havuzu (`pool_size=10`, `pool_pre_ping=True`) devreye girer.

---

## 7. Kimlik Doğrulama ve Test Hesapları

Sistem, sözleşmede belirtilen Mock Kimlik Doğrulama (Mock Auth) mekanizmasını kullanır:

| Rol | Giriş Başlığı / Profil | Bearer Token | Erişim Alanı |
| :--- | :--- | :--- | :--- |
| **İşveren (Employer)** | `İşveren Girişi (Zarif Cheff Restoran)` | `Bearer dev-employer` | Aday listesi, filtreleme, toplu teklif gönderme. |
| **İş Arayan (Worker)** | `İş Arayan Girişi (Aday Demo Profili)` | `Bearer dev-worker` | Gelen teklifler, detay inceleme, kabul/ret aksiyonları. |

---

## 8. Ayrıntılı API Sözleşmesi ve Uç Noktalar

Tüm yanıtlar standart API Zarfı formatındadır:
```json
{
  "ok": true,
  "data": { ... },
  "error": null
}
```

### Uç Noktalar Listesi:

1. **Aday Listesi (İşveren):**
   * `GET /api/candidates?tab=perfect&sort=recommended`
   * *Yetki:* `Bearer dev-employer`

2. **Toplu Teklif Oluşturma (İşveren):**
   * `POST /api/offers`
   * *Gövde:* `{"workerIds": ["w_merve", "w_derya"]}`
   * *Yetki:* `Bearer dev-employer`
   * *Yanıt (200):* `{"ok": true, "data": {"created": [...]}}`

3. **Görüşme Talepleri Listesi (İş Arayan):**
   * `GET /api/offers?status_filter=pending` (`pending`, `answered`, `expired`)
   * *Yetki:* `Bearer dev-worker`

4. **Teklif Detayı (İş Arayan):**
   * `GET /api/offers/{id}`
   * *Yetki:* `Bearer dev-worker`
   * *Yanıt:* Şube (`note`), şehir (`city`) ve tam restoran lokasyon bilgileri.

5. **Teklifi Kabul Etme:**
   * `POST /api/offers/{id}/accept`
   * *Yetki:* `Bearer dev-worker`

6. **Teklifi Reddetme:**
   * `POST /api/offers/{id}/reject`
   * *Yetki:* `Bearer dev-worker`

---

## 9. İş Kuralları ve Hata Yönetimi (Edge Cases)

* **409 Conflict (Açık Teklif Çakışması):**
  * Bekleyen açık bir teklifi olan adaya tekrar teklif gönderildiğinde sistem mükerrer teklifi engeller:
  * `{"ok": false, "error": {"code": "OFFER_CONFLICT", "message": "Merve Aydın adlı adaya zaten açık bir görüşme talebi bulunmaktadır."}}`
* **400 Bad Request (Boş Seçim):**
  * Hiçbir aday seçilmeden teklif gönderilmek istendiğinde `400 EMPTY_SELECTION` hatası döner.
* **404 Not Found (Bilinmeyen Kayıt):**
  * Sistemde olmayan bir aday veya teklif ID'si ile istek yapıldığında `404 CANDIDATE_NOT_FOUND` / `OFFER_NOT_FOUND` döner.
* **Idempotency & Çift Tıklama Koruması:**
  * Mobilde BLoC `isProcessing` kilidi ile buton devre dışı bırakılır; backend'de atomik veritabanı kontrolü ile mükerrer istekler engellenir.
* **Zaman Dilimi (Timezone) & Otomatik Süre Aşımı:**
  * Tüm tarihler ISO-8601 UTC olarak işlenir; süresi dolan teklifler otomatik olarak "Süresi Dolan" sekmesine taşınır.

---

## 10. Test ve Kalite Güvencesi (QA Matrix)

İş kuralları, BLoC durum geçişleri ve JSON serileştirme süreçleri için **36 adet otomatik test** yazılmıştır.

| Test Paketi | Kapsanan Alanlar | Test Sayısı | Durum |
| :--- | :--- | :---: | :---: |
| **`ApiResponseParserTest`** | Standart API zarfı (envelope) ayrıştırma, hata yakalama | 3 | Geçti |
| **`AuthBlocTest`** | Oturum kontrolü, giriş, çıkış ve hata durumları | 5 | Geçti |
| **`CandidateBlocTest`** | Aday listesi yükleme, sekme filtreleme, sıralama, çoklu seçim | 7 | Geçti |
| **`CandidateEntityTest`** | JSON serileştirme, entity dönüşümü, eşitlik kontrolleri | 5 | Geçti |
| **`OfferBlocTest`** | Talep listeleme, detay açma, kabul/ret işlemleri, filtreleme | 8 | Geçti |
| **`OfferEntityTest`** | Talep modeli ayrıştırma, metadata işleme, format kontrolleri | 7 | Geçti |
| **`Widget & Smoke Test`** | Temel bileşen ve uygulama başlatma testi | 1 | Geçti |
| **TOPLAM** | **Birim ve Durum Yönetimi Testleri** | **36/36** | **%100 Başarılı** |

### Test Komutları:
```bash
# Tüm birim ve BLoC testlerini koşturun:
cd mobile_frontend
flutter test

# Statik kod analizi (0 issue / Clean Architecture):
flutter analyze
```

### CI/CD ve iOS Bulut Doğrulaması (Codemagic & Appetize.io)

Projenin yalnızca yerel emülatörde değil, bulut CI/CD ortamında da eksiksiz derlendiği ve çalıştığı doğrulanmıştır:
* **Codemagic (Apple Silicon Mac M2):** CI/CD pipeline'ı üzerinde otomatik testler ve iOS Simulator (`Runner.app`) derlemesi başarıyla tamamlandı.
* **Appetize.io:** Web tabanlı gerçek iOS 18.2 (iPhone 14 Pro) simülatöründe arayüz render'ı ve ekran akışı doğrulandı.

<p align="center">
  <img src="https://github.com/user-attachments/assets/d2d53998-2d43-427d-881f-ff2d8a4881c6" alt="Codemagic CI/CD Build" width="49%" />
  <img src="https://github.com/user-attachments/assets/eab31031-ffe6-453e-8e46-788c0e753698" alt="Appetize iOS 18.2 Simulator" width="49%" />
  <br>
  <em><strong>Solda:</strong> Codemagic (Mac M2) CI/CD derleme ve test pipeline'ı &bull; <strong>Sağda:</strong> Appetize.io üzerinde iOS 18.2 (iPhone 14 Pro) canlı simülatör doğrulaması</em>
</p>

---

## Dokümantasyon Dosyaları
* **Geliştirme Süreci & Karşılaşılan Zorluklar:** [`SUREC.txt`](SUREC.txt)
* **Adım Adım Test Kılavuzu:** [`test_guide.txt`](test_guide.txt)
