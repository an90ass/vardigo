# VardiGO — Backend Servisi (FastAPI)

VardiGO çalışması için geliştirilmiş, **MVC (Model-View-Controller)** mimarisini temel alan, gelişmiş eşleştirme motoru (Matching Engine), otomatik veri tohumlama (Seed Data), kalıcı durum yönetimi ve Docker konteyner desteği sunan FastAPI REST API servisi.

---

## Mimari Yapı (MVC / Katmanlı Mimari)

Backend servisi, sorumlulukların net ayrıldığı **MVC (Model-View-Controller)** ve Servis Katmanı mimarisiyle inşa edilmiştir:

```text
backend/
├── app/
│   ├── config/             # Veritabanı ve ortam yapılandırması (Database & Settings)
│   ├── data/               # Sabit seed verisi (Candidates & Offers JSON)
│   ├── models/             # [MODEL] SQLAlchemy ORM veritabanı varlıkları
│   ├── routes/             # [CONTROLLER] HTTP Router'ları & İstek Yönlendirme
│   │   ├── auth_routes.py
│   │   ├── candidate_routes.py
│   │   └── offer_routes.py
│   ├── schemas/            # [MODEL / DTO] Pydantic v2 veri doğrulama ve transfer şemaları
│   ├── services/           # [İŞ MANTIĞI] Eşleştirme motoru, tohumlama ve durum yönetimi
│   │   ├── auth_service.py
│   │   ├── matching_service.py
│   │   └── seed_service.py
│   └── main.py             # FastAPI uygulama başlangıcı ve CORS yapılandırması
│
├── tests/                  # Pytest birim ve entegrasyon testleri
├── run.py                  # Kolay başlatıcı script (Entrypoint)
├── Dockerfile              # Docker konteyner yapılandırması
├── .dockerignore           # Konteyner harici bırakılan dosyalar
└── requirements.txt        # Python bağımlılıkları
```

### MVC Katman Rolleri:
1. **Model (M):**
   * `app/models/`: Veritabanı tablolarını tanımlayan SQLAlchemy modelleri.
   * `app/schemas/`: Giriş ve çıkış verilerinin tip güvenliğini ve doğrulamasını sağlayan Pydantic V2 şemaları.
2. **View (V):**
   * Mobil istemcinin tükettiği standart JSON API Zarfı (`ApiResponse<T>`).
   * `/docs` ve `/redoc` üzerinden otomatik üretilen interaktif Swagger dokümantasyonu.
3. **Controller (C) & Services:**
   * `app/routes/`: Gelen HTTP isteklerini karşılayan, parametreleri doğrulayan Controller uç noktaları.
   * `app/services/`: Eşleştirme skoru hesaplama, filtreleme, puanlama ve teklif durum geçişlerini yöneten iş mantığı katmanı.

---

## Eşleştirme Motoru Puanlama Algoritması (Matching Engine)

İşveren kriterleri ile aday özellikleri arasındaki eşleşme puanı (`match_score`), 100 puan üzerinden aşağıdaki ağırlıklı kurallarla hesaplanır:

| Kriter | Ağırlık | Kural Açıklaması |
| :--- | :---: | :--- |
| **Unvan Uyumu (Title Match)** | **35 Puan** | Adayın unvanı ile pozisyon unvanı tam eşleşiyorsa 35, kısmi eşleşiyorsa 20 puan. |
| **Konum & Mesafe (Location)** | **25 Puan** | Aynı şehirde ise 25 puan, komşu/yakın mesafe kademeli puanlama. |
| **Çalışma Tipi (Employment Type)** | **20 Puan** | Tam zamanlı, yarı zamanlı veya vardiyalı çalışma tercihi uyumu. |
| **Sektör & Deneyim (Industry)** | **20 Puan** | Hizmet/Restoran sektörü deneyimi ve geçmiş çalışma uyumu. |

---

## Veritabanı Mimarisi ve PostgreSQL Geçişi (Database & Migration)

Projede veritabanı soyutlaması için endüstri standardı **SQLAlchemy ORM** kullanılmıştır.

### 1. SQLite Tercih Nedeni (Zero-Config & Taşınabilirlik)
Vaka değerlendirme sürecinde harici bir veritabanı sunucusu (PostgreSQL, MySQL vb.) kurma zorunluluğunu ortadan kaldırmak için varsayılan olarak **SQLite** (`sqlite_vardigo.db`) tercih edilmiştir. Uygulama başlatıldığında `SeedService` aracılığıyla veriler (adaylar ve teklifler) otomatik olarak tohumlanır ve durum kalıcı olarak saklanır.

### 2. PostgreSQL'e 2 Adımda Kolay Geçiş (Production-Ready)
SQLAlchemy ORM katmanı sayesinde veritabanı motoru kod tabanından tamamen soyutlanmıştır. PostgreSQL'e geçmek için tek yapılması gereken:

1. **Sürücüyü Yükleyin:**
   ```bash
   pip install psycopg2-binary
   ```

2. **Ortam Değişkenini (.env) Tanımlayın:**
   ```env
   DATABASE_URL=postgresql://kullanici_adi:sifre@localhost:5432/vardigo_db
   ```

`app/config/database.py` modülü `DATABASE_URL` değişkenini dinamik olarak algılar; PostgreSQL algılandığında otomatik olarak bağlantı havuzu (`connection pool`, `pool_size=10`, `pool_pre_ping=True`) yapılandırmasını devreye alır. Hiçbir model veya servis kodunu değiştirmeye gerek kalmaz.

---

## Docker ile Kurulum ve Çalıştırma (Önerilen)

Backend servisi, tüm bağımlılıkları ve Python ortamını izole eden Docker konteyneri ile paketlenmiştir.

### 1. Docker Compose ile Tek Komutla Başlatma
> *Önkoşul: Docker Desktop veya Docker daemon servisinin arka planda çalışıyor olması gerekmektedir.*

Proje kök dizininde (`vardigo/`):
```bash
docker compose up --build
```
* Servis `http://localhost:8000` adresinde çalışmaya başlar.
* Kaynak kod değişiklikleri anında senkronize olur (`hot-reload`).

### 2. Standart Docker CLI ile Çalıştırma
```bash
# Backend dizinine geçin
cd backend

# Docker imajını oluşturun
docker build -t vardigo-backend .

# Konteyneri başlatın
docker run -d -p 8000:8000 --name vardigo_backend_container vardigo-backend
```

### 3. Konteyneri Durdurma
```bash
docker compose down
# veya
docker stop vardigo_backend_container
```

---

## Manuel (Yerel) Kurulum

Docker kullanmadan doğrudan yerel Python ortamında çalıştırmak için:

### 1. Sanal Ortam Oluşturun ve Bağımlılıkları Yükleyin
```bash
cd backend

# Sanal ortam oluşturma
python -m venv venv

# Sanal ortamı aktif etme (Windows):
.\venv\Scripts\activate
# (macOS/Linux):
# source venv/bin/activate

# Bağımlılıkları yükleme
pip install -r requirements.txt
```

### 2. Sunucuyu Başlatın
```bash
# Seçenek 1: Kolay başlatıcı script ile (Önerilen)
python run.py

# Seçenek 2: Uvicorn CLI ile doğrudan
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

---

## API Uç Noktaları ve Örnek İstekler

### 1. Kimlik Doğrulama (Auth)
* **Giriş:** `POST /api/auth/login`
```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"role": "employer"}'
```

### 2. Adaylar (Candidates)
* **Aday Listesi:** `GET /api/candidates?tab=perfect&sort=recommended`
```bash
curl -X GET "http://localhost:8000/api/candidates?tab=perfect&sort=recommended" \
  -H "Authorization: Bearer <TOKEN>"
```

### 3. Görüşme Talepleri (Offers)
* **Talep Listesi:** `GET /api/offers?status_filter=pending&sort=recommended`
```bash
curl -X GET "http://localhost:8000/api/offers?status_filter=pending" \
  -H "Authorization: Bearer <TOKEN>"
```

* **Teklif Detayı:** `GET /api/offers/{id}`
```bash
curl -X GET "http://localhost:8000/api/offers/off-1" \
  -H "Authorization: Bearer <TOKEN>"
```

* **Toplu Teklif Oluşturma:** `POST /api/offers`
```bash
curl -X POST http://localhost:8000/api/offers \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{"workerIds": ["1", "2"]}'
```

* **Teklif Kabul / Ret:**
```bash
# Kabul:
curl -X POST http://localhost:8000/api/offers/off-1/accept -H "Authorization: Bearer <TOKEN>"

# Ret:
curl -X POST http://localhost:8000/api/offers/off-1/reject -H "Authorization: Bearer <TOKEN>"
```

---

## Testleri Koşturma

Backend birim ve entegrasyon testlerini koşturmak için:
```bash
cd backend
pytest
```

---

## İnteraktif API Dokümantasyonu
* **Swagger UI:** `http://localhost:8000/docs`
* **Redoc:** `http://localhost:8000/redoc`
