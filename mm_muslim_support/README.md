# Minara

A Flutter-based Muslim lifestyle app featuring prayer times, Quran recitation, tasbih counter, Qibla compass, and Islamic educational resources.

## Features

- **Prayer Times** — Accurate daily prayer schedules with location-based calculation
- **Quran** — Read, listen, and bookmark Quran verses with audio recitation
- **Tasbih Counter** — Digital tasbih with multiple dhikr lists and haptic feedback
- **Qibla Compass** — Find the direction of the Kaaba
- **Ramadan Resources** — Suhoor tips, iftar guidance, charity, and taraweeh info
- **Islamic History** — Timeline of major events in Islamic history
- **Notifications** — Prayer time and suhoor/iftar alarms
- **Dark Mode** — Light and dark theme support

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart) |
| State Management | flutter_bloc + Cubit |
| Routing | go_router |
| Networking | Dio |
| Local DB | SQLite (sqflite) |
| Audio | just_audio + audio_service |
| Notifications | flutter_local_notifications |
| Maps/Location | geolocator + geocoding |
| Firebase | Core, Messaging, Crashlytics, Analytics |
| Background Tasks | workmanager |

## Project Structure

```
lib/
├── common/              # Shared blocs/cubits (download, hijri offset)
├── core/
│   ├── enums/           # Prayer, folder, date format, font constants
│   ├── network/         # Dio client, SQLite database setup
│   ├── routing/         # go_router config, navigation extensions
│   └── themes/          # Light/dark theme, text theme
├── dao/                 # Data access objects (bookmarks)
├── data/                # Shared static data (history events)
├── logic/               # App-level cubits (theme)
├── model/               # Data models (prayer time, quran, tasbih, etc.)
├── module/              # Feature modules
│   ├── home/            # Dashboard, prayer tracker, bottom nav
│   ├── menu/            # Settings, compass, about, logs
│   ├── quran/           # Quran list, reader, audio player, bookmarks
│   ├── tasbih/          # Digital tasbih counter
│   ├── ramadan/         # Ramadan resources (suhoor, taraweeh, etc.)
│   ├── history/         # Islamic history timeline
│   ├── notification/    # Notification center
│   └── stay_tuned_page  # Placeholder for future features
├── repository/          # Data repositories (bookmarks, file download)
├── service/             # Platform services (location, audio, notifications, etc.)
├── utility/             # Helpers (extensions, constants, date utils)
└── widget/              # Shared widgets (compass, history card, etc.)
```

## Getting Started

### Prerequisites

- Flutter SDK ^3.7.0
- iOS 12+ or Android 5.0+
- Firebase project (optional for push notifications / crashlytics)

### Setup

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Firebase Configuration

Copy your `firebase_options.dart` or generate one:
```bash
flutterfire configure
```

## Architecture

The app follows a **feature-first** structure with BLoC/Cubit for state management:

- **Presentation** — Widgets and pages (Flutter)
- **Cubit** — Business logic and state management (flutter_bloc)
- **Service** — Platform abstractions (location, audio, notifications)
- **Repository/DAO** — Data persistence layer (SQLite, shared preferences)
- **Core** — Shared infrastructure (routing, themes, networking)

## Routes

| Path | Page |
|------|------|
| `/` | Home (splash) with bottom nav |
| `/history` | Islamic History |
| `/prayerSettingPage` | Prayer Time Settings |
| `/tasbih` | Tasbih Counter |
| `/quran_list_page` | Quran Surah List |
| `/quran` | Quran Reader |
| `/notification_page` | Notifications |
| `/compass` | Qibla Compass |
| `/surah_listen_list` | Quran Audio List |
| `/surah_listen_page` | Quran Audio Player |
| `/stay_tuned_page` | Coming Soon |
| `/alarm_page` | Alarm Settings |
| `/logs` | Debug Logs |
| `/history_timeline` | Islamic History Timeline |
| `/avoid_overeating` | Ramadan: Avoid Overeating |
| `/charity_sadaqah` | Ramadan: Charity |
| `/healthy_suhoor` | Ramadan: Healthy Suhoor |
| `/hydrate_often` | Ramadan: Hydration |
| `/taraweeh` | Ramadan: Taraweeh |

## License

Private project.
