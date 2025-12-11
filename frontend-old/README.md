# Green Banking Frontend (Flutter)

A Flutter mobile application for tracking the carbon footprint of banking transactions.

## Features

- ✅ **User Authentication** - Login & Registration with JWT
- ✅ **Carbon Dashboard** - Real-time carbon footprint analytics
- ✅ **Transaction Management** - Add and view transactions
- ✅ **Category Breakdown** - Carbon emissions by spending category
- ✅ **Eco Score** - Personal environmental performance tracking
- ✅ **Budget Monitoring** - Track monthly carbon budget usage

## Prerequisites

1. **Flutter SDK** (3.0.0 or later)
2. **Backend API** running on `http://localhost:8080`

## Installation

### Install Dependencies

```bash
cd frontend
flutter pub get
```

### Configure Backend URL

Edit `lib/config/graphql_config.dart` line 3 if needed:

```dart
static const String _baseUrl = 'http://localhost:8080/graphql';
```

**Note:** For Android emulator, use `http://10.0.2.2:8080/graphql`

## Running the App

```bash
flutter run
```

## Project Structure

```
lib/
├── config/           # GraphQL configuration
├── models/           # Data models
├── screens/          # UI screens
├── services/         # Business logic
├── utils/            # Utilities & constants
└── main.dart         # Entry point
```

## Carbon Categories (14 types)

| Category | Factor (kg CO₂/$) |
|----------|-------------------|
| Travel | 3.5 (highest) |
| Transport | 2.1 |
| Energy | 1.7 |
| Technology | 1.2 |
| Fashion | 1.0 |
| Home | 0.9 |
| Shopping | 0.8 |
| Entertainment | 0.6 |
| Food | 0.5 |
| Healthcare | 0.4 |
| Services | 0.3 |
| Education | 0.2 |
| Green | 0.1 (lowest) |
| Other | 0.5 |

## Troubleshooting

### Can't connect to backend?

1. Check backend is running: `curl http://localhost:8080/graphql`
2. For Android emulator: Use `http://10.0.2.2:8080/graphql`
3. For physical device: Use your computer's IP (e.g., `http://192.168.1.X:8080/graphql`)

### Clear cache

```bash
flutter clean && flutter pub get && flutter run
```

## Building

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release
```
