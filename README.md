# ✈️ Travel Planner — Flutter Final Project

Demo: https://drive.google.com/file/d/1BNX8N7pMmk2-SpuN3gfhFo_6VnO13qQp/view?usp=drive_link

A full-featured **Travel & Event Planner** mobile application built with Flutter, demonstrating Clean Architecture, state management with Riverpod, local and cloud persistence, and external API integration.

---

## 👥 Team Members

| Name | Role |
|------|------|
| Shynbergen | Lead Developer |
| — | — |
| — | — |

---

## 📱 Features

- **Trip Management** — Create, edit, and delete trips with full itinerary details
- **Event Tracking** — Add events/activities to each trip with dates, locations, and notes
- **Location Search** — Search cities and destinations worldwide via Nominatim API (OpenStreetMap)
- **Collaborative Planning** — Share trips with friends in real-time via Firebase Firestore
- **Dark Mode** — Full light/dark theme support with persistent preference
- **User Profile** — Persistent user identity via Shared Preferences

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a strict separation of layers:

```
lib/
├── core/                        # Constants, utilities, theme
│   ├── constants/
│   ├── theme/
│   └── utils/
├── data/                        # Data layer
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── drift/           # SQLite database (Drift)
│   │   │   └── shared_prefs/    # Shared Preferences
│   │   └── remote/
│   │       ├── chopper/         # HTTP client (Chopper)
│   │       └── firestore/       # Firebase Firestore
│   ├── models/                  # JSON serializable models
│   └── repositories/            # Repository implementations
├── domain/                      # Domain layer
│   ├── entities/                # Pure Dart entity classes
│   ├── repositories/            # Abstract repository interfaces
│   └── usecases/                # Business logic use cases
└── presentation/                # UI layer
    ├── providers/               # Riverpod providers
    ├── router/                  # go_router navigation
    ├── screens/                 # App screens
    └── widgets/                 # Reusable widgets
```

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.44.0 / Dart 3.12 |
| State Management | Riverpod 3.x (`flutter_riverpod`) |
| Navigation | go_router 17.x |
| Local Database | Drift 2.33 (SQLite) |
| Lightweight Storage | Shared Preferences |
| HTTP Client | Chopper 8.x |
| Cloud Database | Firebase Firestore |
| JSON Serialization | `json_annotation` + `json_serializable` |

---

## ✅ Requirements Coverage

| Requirement | Implementation |
|-------------|----------------|
| Clean Architecture | `domain/`, `data/`, `presentation/` layers |
| Riverpod | All state managed via `Provider`, `NotifierProvider`, `StreamProvider`, `FutureProvider` |
| go_router + sub-routes | `ShellRoute` + nested routes (`/trips/:id/edit`) |
| Slivers / GridView | `SliverAppBar`, `SliverList`, `SliverGrid` used throughout |
| Chopper (HTTP) | `LocationApiService` → Nominatim OpenStreetMap API |
| JSON Serialization | `LocationModel` with `@JsonSerializable()` |
| Shared Preferences | Dark mode toggle, user name, user ID |
| Drift (SQLite) | Trips table + Events table with DAO pattern |
| Firebase Firestore | Real-time shared trips (`shared_trips` collection) |

---

## 🚀 Getting Started

### Prerequisites

- Flutter 3.44.0+
- Xcode 16+ (for iOS)
- A Firebase project with Firestore enabled

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/travel_planner.git
   cd travel_planner
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase configuration**

   Place your `GoogleService-Info.plist` in `ios/Runner/` (iOS).

   The app uses Firebase project: `travel-planner-301d0`

4. **Run the app**
   ```bash
   open -a Simulator
   flutter run
   ```

---

## 📂 Key Files

| File | Description |
|------|-------------|
| `lib/main.dart` | App entry point, Firebase init |
| `lib/core/theme/app_theme.dart` | Material 3 light & dark themes |
| `lib/presentation/router/app_router.dart` | go_router configuration |
| `lib/data/datasources/local/drift/app_database.dart` | Drift database schema |
| `lib/data/datasources/remote/chopper/location_api_service.dart` | Chopper HTTP service |
| `lib/data/datasources/remote/firestore/firestore_service.dart` | Firestore CRUD |
| `lib/presentation/providers/` | All Riverpod providers |

---

## 🗄️ Database Schema

### Drift (SQLite)

**TripsTable**

| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER PK | Auto-increment |
| title | TEXT | Trip name |
| destination | TEXT | Destination city |
| startDate | DATETIME | Trip start |
| endDate | DATETIME | Trip end |
| description | TEXT? | Optional notes |
| isShared | BOOLEAN | Shared to Firestore |
| firestoreId | TEXT? | Firestore document ID |

**EventsTable**

| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER PK | Auto-increment |
| tripId | INTEGER FK | References TripsTable |
| title | TEXT | Event name |
| location | TEXT? | Event location |
| scheduledAt | DATETIME | Event date/time |
| notes | TEXT? | Optional notes |
| isCompleted | BOOLEAN | Completion status |

### Firestore

**`shared_trips` collection**
```json
{
  "title": "USA Trip",
  "destination": "New York",
  "startDate": "Timestamp",
  "endDate": "Timestamp",
  "description": "...",
  "ownerId": "user_id",
  "ownerName": "Traveler",
  "participants": ["user_id"],
  "createdAt": "Timestamp",
  "updatedAt": "Timestamp"
}
```

---

## 🌐 External API

**Nominatim OpenStreetMap API**
- Base URL: `https://nominatim.openstreetmap.org`
- Endpoint: `GET /search?q={query}&format=json&limit=10&addressdetails=1`
- Integrated via **Chopper** HTTP client with `JsonConverter`
- Returns city/location data with name, country, and coordinates

---

## 🔥 Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select project `travel-planner-301d0`
3. Enable **Cloud Firestore** in test mode
4. Download `GoogleService-Info.plist` → place in `ios/Runner/`

**Firestore Rules (Development)**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

> ⚠️ For production, replace with authenticated rules.

---

## 🎥 Live Demo Plan (10 min)

1. **Home Screen** — Show trip list (GridView + Slivers), statistics
2. **Create Trip** — Add new trip with title, destination, dates
3. **Trip Detail** — Add events, mark as complete, share to cloud
4. **Search** — Search "Paris" via Chopper → Nominatim API → "Plan a trip here"
5. **Shared Tab** — Real-time Firestore trip appears instantly
6. **Settings** — Toggle dark mode, edit user name
7. **Architecture Q&A** — Clean Architecture layers walkthrough

Demo: https://drive.google.com/file/d/1BNX8N7pMmk2-SpuN3gfhFo_6VnO13qQp/view?usp=drive_link

---

## 📄 License

Submitted as a final project for the Cross-Mobile Development course.
