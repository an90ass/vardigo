# VardiGO — Backend Servisi (FastAPI)

VardiGO çalışması için geliştirilmiş, **MVC (Model-View-Controller)** mimarisini temel alan, gelişmiş eşleştirme motoru (Matching Engine), otomatik veri tohumlama (Seed Data), kalıcı durum yönetimi ve Docker konteyner desteği sunan FastAPI REST API servisi.

---

## İçindekiler
1. [Mimari Yapı (MVC / Katmanlı Mimari)](#1-mimari-yapı-mvc--katmanlı-mimari)
2. [Eşleştirme Motoru Puanlama Algoritması](#2-eşleştirme-motoru-puanlama-algoritması)
3. [Veritabanı Mimarisi ve PostgreSQL Geçişi](#3-veritabanı-mimarisi-ve-postgresql-geçişi)
4. [Docker ile Kurulum ve Çalıştırma](#4-docker-ile-kurulum-ve-çalıştırma)
5. [Manuel (Yerel) Kurulum](#5-manuel-yerel-kurulum)
6. [Kimlik Doğrulama (Mock Auth)](#6-kimlik-doğrulama-mock-auth)
7. [Ayrıntılı API Sözleşmesi ve Uç Noktalar](#7-ayrıntılı-api-sözleşmesi-ve-uç-noktalar)
8. [Hata Kodları ve Sözleşme Kuralları](#8-hata-kodları-ve-sözleşme-kuralları)
9. [İnteraktif API Dokümantasyonu](#9-interaktif-api-dokümantasyonu)

---

## 1. Mimari Yapı (MVC / Katmanlı Mimari)

Backend servisi, sorumlulukların net ayrıldığı **MVC (Model-View-Controller)** ve Servis Katmanı mimarisiyle inşa edilmiştir:

```text
backend/
├── app/
│   ├── config/             # Veritabanı ve ortam yapılandırması (Database & Settings)
│   ├── data/               # Sabit seed verisi (Candidates & Offers JSON)
│   ├── dependencies/       # Rol Yetkilendirme & Dependency Injection
│   ├── models/             # [MODEL] SQLAlchemy ORM veritabanı varlıkları (User, Candidate, Offer)
│   ├── repositories/       # [REPOSITORY] Veritabanı sorgu ve CRUD soyutlama katmanı
│   ├── routes/             # [CONTROLLER] HTTP Router'ları & Uç Noktalar
│   │   ├── auth_routes.py
│   │   ├── candidate_routes.py
│   │   └── offer_routes.py
│   ├── schemas/            # [DTO] Pydantic v2 veri doğrulama ve transfer şemaları
│   ├── services/           # [İŞ MANTIĞI] Eşleştirme motoru, teklif yönetimi ve tohumlama
│   │   ├── auth_service.py
│   │   ├── candidate_service.py
│   │   ├── matching_service.py
│   │   ├── offer_service.py
│   │   └── seed_service.py
│   └── main.py             # FastAPI uygulama başlangıcı ve CORS yapılandırması
│
├── run.py                  # Kolay başlatıcı script (Entrypoint)
├── Dockerfile              # Docker konteyner yapılandırması
├── .dockerignore           # Konteyner harici bırakılan dosyalar
└── requirements.txt        # Python bağımlılıkları
```

---

## 2. Eşleştirme Motoru Puanlama Algoritması

İşveren kriterleri ile aday özellikleri arasındaki eşleşme puanı (`match_score`), 100 puan üzerinden aşağıdaki ağırlıklı kurallarla hesaplanır:

| Kriter | Ağırlık | Kural Açıklaması |
| :--- | :---: | :--- |
| **Unvan Uyumu (Title Match)** | **35 Puan** | Adayın unvanı ile pozisyon unvanı tam eşleşiyorsa 35, kısmi eşleşiyorsa 20 puan. |
| **Konum & Mesafe (Location)** | **25 Puan** | Aynı şehirde ise 25 puan, komşu/yakın mesafe kademeli puanlama. |
| **Çalışma Tipi (Employment Type)** | **20 Puan** | Tam zamanlı, yarı zamanlı veya vardiyalı çalışma tercihi uyumu. |
| **Sektör & Deneyim (Industry)** | **20 Puan** | Hizmet/Restoran sektörü deneyimi ve geçmiş çalışma uyumu. |

* **%100 Eşleşen Sekmesi (`tab=perfect`):** `match_score >= 80` olan adaylar.
* **Benzer Personeller Sekmesi (`tab=similar`):** `match_score < 80` olan adaylar.

---

## 3. Veritabanı Mimarisi ve PostgreSQL Geçişi

### 1. SQLite Tercih Nedeni (Zero-Config & Taşınabilirlik)
Vaka değerlendirme sürecinde harici bir veritabanı sunucusu kurma zorunluluğunu ortadan kaldırmak için varsayılan olarak **SQLite** (`sqlite_vardigo.db`) tercih edilmiştir. Uygulama başlatıldığında `SeedService` aracılığıyla veriler (adaylar ve teklifler) otomatik olarak tohumlanır ve durum kalıcı olarak saklanır.

### 2. PostgreSQL'e 2 Adımda Kolay Geçiş (Production-Ready)
SQLAlchemy ORM katmanı sayesinde veritabanı motoru kod tabanından tamamen soyutlanmıştır:
1. Sürücüyü Yükleyin: `pip install psycopg2-binary`
2. Ortam Değişkenini (.env) Tanımlayın: `DATABASE_URL=postgresql://user:pass@localhost:5432/vardigo_db`

---

## 4. Docker ile Kurulum ve Çalıştırma

### Docker Compose ile Tek Komutla Başlatma (Önerilen)
> **Önkoşul:** *Docker Desktop uygulamasının arka planda açık ve çalışıyor olması gerekmektedir.*

```bash
# Proje kök dizininde (vardigo/):
docker compose up --build
```
* **API Adresi:** `http://localhost:8000`
* **Swagger Dokümantasyonu:** `http://localhost:8000/docs`

---

## 5. Manuel (Yerel) Kurulum

```bash
cd backend
python -m venv venv

# Sanal ortamı aktif etme (Windows):
.\venv\Scripts\activate
# (macOS/Linux): source venv/bin/activate

pip install -r requirements.txt
python run.py
# veya: uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

---

## 6. Kimlik Doğrulama (Mock Auth)

Tüm korumalı uç noktalar `Authorization: Bearer <TOKEN>` başlığı ile doğrulanır:

| Rol | Kullanıcı | Bearer Token |
| :--- | :--- | :--- |
| **İşveren (Employer)** | Zarif Cheff Restaurant (`u_employer`) | `Bearer dev-employer` |
| **İş Arayan (Worker)** | Aday Demo Hesabı (`u_worker`) | `Bearer dev-worker` |

---

## 7. Ayrıntılı API Sözleşmesi ve Uç Noktalar

Tüm yanıtlar standart API Zarfı formatındadır:
```json
{
  "ok": true,
  "data": { ... },
  "error": null
}
```

---

### 1. Kimlik Doğrulama Uç Noktaları (Auth)

#### `POST /api/auth/login`
Rol bazlı oturum açar ve kullanıcı oturum nesnesini döner.
* **Header:** `Content-Type: application/json`
* **Request Body:**
```json
{
  "role": "employer"
}
```
* **Success Response (200 OK):**
```json
{
  "ok": true,
  "data": {
    "id": "u_employer",
    "name": "Zarif Cheff Restaurant",
    "role": "employer",
    "token": "dev-employer"
  },
  "error": null
}
```
* **cURL Örneği:**
```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"role": "employer"}'
```

---

### 2. Adaylar Uç Noktaları (Candidates - İşveren)

#### `GET /api/candidates`
Eşleşen veya benzer personelleri listeler.
* **Header:** `Authorization: Bearer dev-employer`
* **Query Parametreleri:**
  * `tab`: `perfect` (%100 Eşleşen) veya `similar` (Benzer Adaylar)
  * `sort`: `recommended` (Önerilen), `near` (En Yakın), `rating` (Puana Göre)
* **Success Response (200 OK):**
```json
{
  "ok": true,
  "data": {
    "perfectCount": 3,
    "similarCount": 1,
    "candidates": [
      {
        "id": "w_merve",
        "name": "Merve Aydın",
        "title": "Garson",
        "photo": "assets/images/candidates/merve.png",
        "rating": "4.9 (128)",
        "attend": "%98",
        "km": "1.2 km",
        "matchRate": 92,
        "isOnline": true,
        "match_score": 92
      }
    ]
  },
  "error": null
}
```
* **cURL Örneği:**
```bash
curl -X GET "http://localhost:8000/api/candidates?tab=perfect&sort=recommended" \
  -H "Authorization: Bearer dev-employer"
```

---

### 3. Görüşme Talepleri Uç Noktaları (Offers)

#### `POST /api/offers` (Toplu Teklif Oluşturma - İşveren)
İşverenin seçtiği adaylara toplu görüşme talebi gönderir.
* **Header:**
  * `Authorization: Bearer dev-employer`
  * `Content-Type: application/json`
* **Request Body:**
```json
{
  "workerIds": ["w_merve", "w_derya"]
}
```
* **Success Response (200 OK):**
```json
{
  "ok": true,
  "data": {
    "created": [
      {
        "id": "o_a1b2c3d4",
        "workerId": "w_merve",
        "title": "Garson",
        "place": "Zarif Cheff Restaurant",
        "pay": "45.000",
        "payValue": 45000,
        "logo": "/assets/logos/zarif.svg",
        "district": "Kadıköy",
        "when": "16 Ağu · 12:00 - 16:00",
        "status": "pending",
        "expiresAt": "2026-08-17T09:32:00.000Z",
        "remain": "21 saat 32 dakika"
      }
    ]
  },
  "error": null
}
```
* **Error Response (400 Bad Request - Boş Liste):**
```json
{
  "ok": false,
  "error": {
    "code": "EMPTY_SELECTION",
    "message": "En az bir aday seçilmelidir."
  }
}
```
* **Error Response (404 Not Found - Bilinmeyen Aday):**
```json
{
  "ok": false,
  "error": {
    "code": "CANDIDATE_NOT_FOUND",
    "message": "'w_unknown' id'li aday bulunamadı."
  }
}
```
* **Error Response (409 Conflict - Açık Teklif Çakışması):**
```json
{
  "ok": false,
  "error": {
    "code": "OFFER_CONFLICT",
    "message": "Merve Aydın adlı adaya zaten açık bir görüşme talebi bulunmaktadır."
  }
}
```
* **cURL Örneği:**
```bash
curl -X POST http://localhost:8000/api/offers \
  -H "Authorization: Bearer dev-employer" \
  -H "Content-Type: application/json" \
  -d '{"workerIds": ["w_merve", "w_derya"]}'
```

---

#### `GET /api/offers` (Teklifleri Listeleme - İş Arayan)
Görüşme taleplerini durumlarına göre filtreleyerek listeler.
* **Header:** `Authorization: Bearer dev-worker`
* **Query Parametreleri:**
  * `status_filter`: `pending` (Bekleyen), `answered` (Cevaplanan), `expired` (Süresi Dolan)
* **Success Response (200 OK):**
```json
{
  "ok": true,
  "data": {
    "pendingCount": 2,
    "offers": [
      {
        "id": "o_seed_1",
        "workerId": "w_merve",
        "title": "Garson",
        "place": "Zarif Cheff Restaurant",
        "pay": "45.000",
        "payValue": 45000,
        "logo": "/assets/logos/zarif.svg",
        "district": "Kadıköy",
        "when": "16 Ağu · 12:00 - 16:00",
        "status": "pending",
        "expiresAt": "2026-08-17T09:32:00.000Z",
        "remain": "21 saat 32 dakika"
      }
    ]
  },
  "error": null
}
```
* **cURL Örneği:**
```bash
curl -X GET "http://localhost:8000/api/offers?status_filter=pending" \
  -H "Authorization: Bearer dev-worker"
```

---

#### `GET /api/offers/{id}` (Teklif Detayı - İş Arayan)
Belirtilen teklifin şehir, şube ve ek detay bilgilerini döner.
* **Header:** `Authorization: Bearer dev-worker`
* **Success Response (200 OK):**
```json
{
  "ok": true,
  "data": {
    "id": "o_seed_1",
    "workerId": "w_merve",
    "title": "Garson",
    "place": "Zarif Cheff Restaurant",
    "pay": "45.000",
    "payValue": 45000,
    "logo": "/assets/logos/zarif.svg",
    "district": "Kadıköy",
    "city": "İstanbul",
    "note": "Şube: Sinanpaşa Mah.",
    "when": "16 Ağu · 12:00 - 16:00",
    "status": "pending",
    "expiresAt": "2026-08-17T09:32:00.000Z",
    "remain": "21 saat 32 dakika"
  },
  "error": null
}
```
* **cURL Örneği:**
```bash
curl -X GET "http://localhost:8000/api/offers/o_seed_1" \
  -H "Authorization: Bearer dev-worker"
```

---

#### `POST /api/offers/{id}/accept` (Teklifi Kabul Etme)
Bekleyen bir görüşme teklifini kabul eder (`status = accepted`).
* **Header:** `Authorization: Bearer dev-worker`
* **Success Response (200 OK):**
```json
{
  "ok": true,
  "data": {
    "id": "o_seed_1",
    "status": "accepted"
  },
  "error": null
}
```
* **Error Response (409 Conflict):** Teklifin süresi dolmuşsa veya zaten yanıtlanmışsa.
* **cURL Örneği:**
```bash
curl -X POST "http://localhost:8000/api/offers/o_seed_1/accept" \
  -H "Authorization: Bearer dev-worker"
```

---

#### `POST /api/offers/{id}/reject` (Teklifi Reddetme)
Bekleyen bir görüşme teklifini reddeder (`status = rejected`).
* **Header:** `Authorization: Bearer dev-worker`
* **Success Response (200 OK):**
```json
{
  "ok": true,
  "data": {
    "id": "o_seed_1",
    "status": "rejected"
  },
  "error": null
}
```
* **cURL Örneği:**
```bash
curl -X POST "http://localhost:8000/api/offers/o_seed_1/reject" \
  -H "Authorization: Bearer dev-worker"
```

---

## 8. Hata Kodları ve Sözleşme Kuralları

| HTTP Kodu | Hata Kodu (`code`) | Tetiklenme Durumu |
| :--- | :--- | :--- |
| **`400 Bad Request`** | `EMPTY_SELECTION` | `POST /api/offers` isteğinde `workerIds` listesi boş gönderildiğinde. |
| **`404 Not Found`** | `CANDIDATE_NOT_FOUND` | Sistemde tanımlı olmayan bir `workerId` için teklif oluşturulmak istendiğinde. |
| **`404 Not Found`** | `OFFER_NOT_FOUND` | Bulunamayan `offer_id` ile detay, kabul veya ret işlemi yapıldığında. |
| **`409 Conflict`** | `OFFER_CONFLICT` | Adayın zaten açık (pending) bir görüşme talebi varken yeni talep gönderilmek istendiğinde. |
| **`409 Conflict`** | `OFFER_STATE_ERROR` | Süresi dolmuş veya zaten yanıtlanmış bir teklife kabul/ret isteği atıldığında. |

---

## 9. İnteraktif API Dokümantasyonu
* **Swagger UI:** `http://localhost:8000/docs`
* **Redoc:** `http://localhost:8000/redoc`
