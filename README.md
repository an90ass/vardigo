# VardiGO — Case Study (Mobile & Backend)

Monorepo içeren **VardiGO** mobil istemcisi (Flutter) ve REST API backend servisi (FastAPI).

---

## Proje Mimarisi ve Yapısı

```text
vardigo/
├── mobile_frontend/          # Flutter Mobil Uygulaması (Clean Architecture, BLoC)
│   ├── lib/
│   │   ├── core/             # Tasarım token'ları, ağ katmanı, tema, storage, utils
│   │   └── features/
│   │       ├── auth/         # Rol bazlı oturum ve kalıcı saklama
│   │       ├── candidates/   # Sayfa 1: Eşleşen Personeller (İşveren görünümü)
│   │       └── offers/       # Sayfa 2: Görüşme Talepleri (İş arayan görünümü)
│   └── test/                 # 36/36 Unit & BLoC Testleri
│
└── backend/                  # FastAPI REST Servisi (Eşleştirme motoru & Seed verisi)
    ├── app/
    │   ├── routes/           # Auth, Candidates, Offers endpoint'leri
    │   ├── services/         # Eşleştirme skoru & filtreleme iş mantığı
    └── data/             # Seed verisi ve kalıcı durum yönetimi
```

---

## Versiyonlar ve Geliştirme Ortamı (Environment)

| Teknoloji | Versiyon | Açıklama |
| :--- | :--- | :--- |
| **Flutter** | `3.44.4` (channel stable) | Mobil UI Framework |
| **Dart** | `3.12.2` (`sdk: '>=3.0.0 <4.0.0'`) | Programlama Dili |
| **Python** | `3.10+` | Backend Runtime |
| **FastAPI** | `0.110.0+` | REST API Framework |

---

## Hızlı Başlangıç (5 Dakikada Kurulum)

### 1. Backend Servisini Başlatma (FastAPI & Docker)

**Seçenek A — Docker Compose ile (Önerilen & Tek Komut):**
> *Önkoşul: Docker Desktop veya Docker daemon'un arka planda çalışıyor olduğundan emin olun.*
```bash
docker compose up --build
```

**Seçenek B — Manuel Python Ortamı ile:**
```bash
# Backend dizinine geçin
cd backend

# Bağımlılıkları yükleyin
pip install -r requirements.txt

# Sunucuyu başlatın (Port: 8000)
python run.py
# veya: uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```
> Backend API interaktif Swagger dokümantasyonu: `http://localhost:8000/docs`

---

### 2. Mobil Uygulamayı Başlatma (Flutter)

```bash
# Mobil dizinine geçin
cd mobile_frontend

# Bağımlılıkları yükleyin
flutter pub get

# Çevre değişkeni (.env) dosyasını oluşturun / kontrol edin
# Android Emülatör için: API_BASE_URL=http://10.0.2.2:8000
# iOS Simülatör için:    API_BASE_URL=http://localhost:8000

# Standart Native Mobil:
flutter run

# Referans Telefon Çerçevesi (390×844 Bezel + Dynamic Island) ile:
flutter run --dart-define=REFERENCE_FRAME=true
```

---

## Sabit Test Hesapları (Seed Giriş Bilgileri)

Uygulama açılışında tek dokunuşla rol seçilerek giriş yapılabilir:

| Rol | Kullanıcı Adı / Şirket | Rol Tipi | Açıklama |
| :--- | :--- | :--- | :--- |
| **İşveren** | Zarif Cheff Restaurant | `employer` | Adayları listeler, seçer ve toplu görüşme talebi gönderir. |
| **İş Arayan** | Merve Y. | `worker` | Gelen talepleri inceler, detayları görür, kabul veya ret eder. |

---

## API Uç Noktaları ve Örnek İstekler

### 1. Kimlik Doğrulama (Auth)
* **`POST /api/auth/login`**
```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"role": "employer"}'
```

### 2. Adaylar (Candidates - İşveren)
* **`GET /api/candidates?tab=perfect&sort=recommended`**
```bash
curl -X GET http://localhost:8000/api/candidates \
  -H "Authorization: Bearer <TOKEN>"
```

### 3. Görüşme Talepleri (Offers)
* **Teklif Oluşturma:** `POST /api/offers`
```bash
curl -X POST http://localhost:8000/api/offers \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{"workerIds": ["1", "2"]}'
```

* **Teklif Listesi (İş Arayan):** `GET /api/offers?status_filter=pending`
```bash
curl -X GET "http://localhost:8000/api/offers?status_filter=pending" \
  -H "Authorization: Bearer <TOKEN>"
```

* **Teklif Detayı:** `GET /api/offers/{id}`
```bash
curl -X GET "http://localhost:8000/api/offers/off-1" \
  -H "Authorization: Bearer <TOKEN>"
```

* **Kabul / Ret:** `POST /api/offers/{id}/accept` ve `POST /api/offers/{id}/reject`
```bash
curl -X POST "http://localhost:8000/api/offers/off-1/accept" \
  -H "Authorization: Bearer <TOKEN>"
```

---

## Testleri Çalıştırma (Mobil Otomatik Testler)

```bash
cd mobile_frontend
flutter test
```
* **Sonuç:** `36/36 tests passed` (ApiResponseParser, AuthBloc, CandidateBloc, CandidateEntity, OfferBloc, OfferEntity).
* **Statik Kod Analizi:** `flutter analyze` (0 issue).

---

## Detaylı Dokümantasyon
* Mobil mimari, tasarım token'ları ve QA detayları için: [`mobile_frontend/README.md`](mobile_frontend/README.md)
* Backend mimarisi ve eşleştirme motoru kuralları için: [`backend/README.md`](backend/README.md)
* Süreç notu için: [`SUREC.txt`](SUREC.txt)
* Test ve senaryo kılavuzu için: [`test_guide.txt`](test_guide.txt)