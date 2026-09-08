# Venue Booking App (Flutter)

![Flutter](https://img.shields.io/badge/Flutter-3.x-2c5443?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-2c5443?style=for-the-badge&logo=dart&logoColor=white)
![REST API](https://img.shields.io/badge/REST-API-2c5443?style=for-the-badge)

A Flutter front-end for the [booking-api](https://github.com/layankhayyat04-ui/booking-api) — browse venues, book a court, and view/cancel bookings, all through real REST calls to a Node.js/Express/PostgreSQL backend.

## Screens

1. **Venues** — lists venues via `GET /venues`. Tap one to book.
2. **Book a court** — pick a court, date, start time and duration, enter name/email, submit via `POST /bookings`. Overlap conflicts (`409`) are shown directly from the server's own error message.
3. **My Bookings** — lists bookings via `GET /bookings`, cancel via `DELETE /bookings/:id`.

## Tech

- Flutter + Dart, `http` package for REST calls
- Models (`Venue`, `Booking`) with `fromJson` factories
- Service layer (`ApiService`) wrapping all API calls with typed error handling

## Setup

```bash
flutter pub get
flutter run
```

Point `baseUrl` in `lib/services/pi_service.dart` at your running [booking-api](https://github.com/layankhayyat04-ui/booking-api) instance.

## Related

- [booking-api](https://github.com/layankhayyat04-ui/booking-api) — the backend this app talks to
