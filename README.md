<img width="100%" src="https://raw.githubusercontent.com/layankhayyat04-ui/booking-app-flutter/main/assets/banner.svg" alt="banner"/>

<p align="center">
  <img src="https://img.shields.io/badge/status-active-16213e?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Flutter-2c5443?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-2c5443?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Material_3-2c5443?style=for-the-badge&logo=materialdesign&logoColor=white"/>
</p>

A Flutter front-end for the [booking-api](https://github.com/layankhayyat04-ui/booking-api) — the mobile client that turns three REST endpoints into a real, usable booking flow: **browse venues, book a court, and manage your own bookings.**

---

### ✨ Features

- 📋 **Live venue list** — pulled straight from `GET /venues`, no mock data
- 🗓️ **Guided booking form** — date/time pickers, court selection, duration — validated before it ever hits the network
- ⚠️ **Server-driven error messages** — a `409` overlap conflict from the API is shown to the user verbatim, not swallowed by a generic "something went wrong"
- ❌ **Cancel from the app** — soft-cancels a booking via `DELETE /bookings/:id` and refreshes the list instantly

### 📱 Tech Stack

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-2c5443?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-2c5443?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/http_package-2c5443?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/REST_API-2c5443?style=for-the-badge"/>
</p>

| | |
|---|---|
| **Framework** | Flutter (Material 3) |
| **Language** | Dart |
| **Networking** | `http` package, typed `ApiException` on non-2xx |
| **Backend** | [booking-api](https://github.com/layankhayyat04-ui/booking-api) — Node.js + Express + PostgreSQL |

### 🏗 Architecture

```mermaid
flowchart LR
    U["User"] -- "opens app" --> VL["Venue List Screen"]
    VL -- "GET /venues" --> API[("booking-api")]
    VL -- "tap venue" --> BF["Booking Form Screen"]
    BF -- "POST /bookings" --> API
    API -- "409 on overlap" --> BF
    API -- "201 confirmed" --> VL
    U -- "views" --> MB["My Bookings Screen"]
    MB -- "GET /bookings" --> API
    MB -- "DELETE /bookings/:id" --> API

    classDef input fill:#0c4a6e,stroke:#38bdf8,color:#f0f9ff
    classDef process fill:#134e4a,stroke:#2dd4bf,color:#f0fdfa
    classDef output fill:#312e81,stroke:#a5b4fc,color:#eef2ff
    class U input
    class VL,BF,MB process
    class API output
```

### 📂 Screens

| Screen | What it does |
|---|---|
| **Venues** | Lists all venues via `GET /venues`. Tap one to start booking. |
| **Book a court** | Pick a court, date, start time, duration → `POST /bookings`. Shows the server's own conflict message on `409`. |
| **My Bookings** | Lists bookings via `GET /bookings`; cancel via `DELETE /bookings/:id`. |

### 🚀 Quick start

```bash
git clone https://github.com/layankhayyat04-ui/booking-app-flutter.git
cd booking-app-flutter
flutter pub get
```

Point `baseUrl` in `lib/services/pi_service.dart` at your running [booking-api](https://github.com/layankhayyat04-ui/booking-api) instance, then:

```bash
flutter run
```

### 📁 Repository map

```text
booking-app-flutter/
├── lib/
│   ├── main.dart              # App entry point, theming
│   ├── models/                # Venue, Booking (fromJson)
│   ├── screens/                # Venue list, booking form, my bookings
│   └── services/
│       └── pi_service.dart    # ApiService — all REST calls, typed errors
├── android/ ios/ web/          # Platform scaffolding
└── pubspec.yaml
```

### 📝 Design notes

- **Server errors surface verbatim.** A `409` overlap conflict from the API is parsed and shown directly in the booking form — no generic "error occurred" message.
- **State is explicit.** Each screen manages its own `Future` and reloads via `setState`, keeping data flow easy to trace without extra state-management libraries.
- **Typed models.** `Venue` and `Booking` both use `fromJson` factories, so a shape mismatch from the API fails fast and visibly instead of silently.

---

<p align="center">

**Built by [Layan Khayyat](https://github.com/layankhayyat04-ui)**

Explore more: [Booking API](https://github.com/layankhayyat04-ui/booking-api) · [BMS Dashboard](https://github.com/layankhayyat04-ui/bms-dashboard) · [CV RAG Chatbot](https://github.com/layankhayyat04-ui/cv-rag-chatbot)

<img src="https://img.shields.io/badge/Book-2DD4BF?style=flat-square"/> <img src="https://img.shields.io/badge/Confirm-2DD4BF?style=flat-square"/> <img src="https://img.shields.io/badge/Cancel-2DD4BF?style=flat-square"/>

</p>
