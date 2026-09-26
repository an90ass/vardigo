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

### 3. Çevre Değişkenleri (.env)
`mobile_frontend/` dizini altında bir `.env` dosyası oluşturun:
```env
API_BASE_URL=http://10.0.2.2:8000   # Android Emülatör için
# API_BASE_URL=http://localhost:8000 # iOS veya Web için
```

### 4. Uygulamayı Başlatın
```bash
flutter run
```
