# 🌱 Green Banking System - Frontend

A cross-platform Flutter mobile application that helps users track their carbon footprint through smart banking transactions, providing real-time environmental impact insights.

![Flutter](https://img.shields.io/badge/Flutter-3.24.4-blue) ![Dart](https://img.shields.io/badge/Dart-3.4.1-blue) ![License](https://img.shields.io/badge/License-MIT-green)

## 🎯 Overview

The Green Banking frontend is a modern, responsive Flutter application built on the **FlareLine Admin Dashboard Template**, providing:

- 📱 **Cross-platform support** - iOS, Android, Web, Windows, macOS, Linux
- 🎨 **Beautiful UI** - Modern design with dark/light themes
- 🌍 **Carbon tracking** - Real-time transaction carbon footprint display
- 📊 **Analytics dashboard** - Visual insights into environmental impact
- 🔐 **Secure authentication** - JWT-based login and registration
- 🌐 **Multi-language support** - i18n with 8+ languages

## ✨ Key Features

### 🌍 Carbon Footprint Tracking
- Automatic carbon calculation for every transaction
- Visual representation of CO₂ emissions
- Category-based carbon insights
- Monthly carbon budget tracking

### 📊 Dashboard & Analytics
- Real-time Eco Score display (0-100)
- Total carbon saved statistics
- Transaction history with carbon data
- Category breakdown charts
- Trend analysis over time

### 💳 Transaction Management
- Create new transactions
- View transaction history
- Update and delete transactions
- Category filtering
- Merchant tracking

### 🔐 Authentication
- User registration
- Secure login with JWT
- Token refresh mechanism
- Password reset (upcoming)

### 🎨 User Experience
- Responsive design for all screen sizes
- Dark and light theme support
- Smooth animations
- Intuitive navigation
- Offline capability (upcoming)

## 📁 Project Structure

```
frontend/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── routes.dart               # Route configuration
│   ├── flareline.dart            # Main app configuration
│   ├── components/               # Reusable UI components
│   ├── core/                     # Core functionality
│   ├── pages/                    # Screen/page widgets
│   │   ├── dashboard/            # Dashboard screens
│   │   ├── transactions/         # Transaction screens
│   │   ├── auth/                 # Login/register screens
│   │   └── profile/              # User profile screens
│   ├── widgets/                  # Custom widgets
│   ├── l10n/                     # Localization files
│   └── flutter_gen/              # Generated files
├── assets/                       # Images, icons, JSON files
├── android/                      # Android specific configuration
├── ios/                          # iOS specific configuration
├── web/                          # Web specific configuration
├── windows/                      # Windows specific configuration
├── linux/                        # Linux specific configuration
├── macos/                        # macOS specific configuration
├── pubspec.yaml                  # Dependencies and metadata
└── README.md                     # This file
```

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** 3.24.4 or higher
- **Dart** 3.4.1 or higher
- **Android Studio** / **Xcode** (for mobile development)
- **VS Code** (recommended) with Flutter extension
- **Backend API** running on `http://localhost:8081`

### Installation

#### 1. Install Flutter

**Windows:**
```powershell
# Using Chocolatey
choco install flutter

# Or download from: https://docs.flutter.dev/get-started/install/windows
```

**macOS:**
```bash
# Using Homebrew
brew install --cask flutter

# Or download from: https://docs.flutter.dev/get-started/install/macos
```

**Linux:**
```bash
# Download and extract Flutter
cd ~/development
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.4-stable.tar.xz
tar xf flutter_linux_3.24.4-stable.tar.xz

# Add to PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

#### 2. Verify Flutter Installation

```bash
flutter doctor
```

This checks for:
- Flutter SDK installation
- Connected devices
- Android toolchain
- Xcode (macOS)
- VS Code / Android Studio plugins

#### 3. Install Dependencies

```bash
cd frontend

# Get all packages
flutter pub get

# Generate localization files
flutter gen-l10n

# Generate code (if needed)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running the Application

#### Mobile (Android/iOS)

```bash
# List available devices
flutter devices

# Run on connected device
flutter run

# Run on specific device
flutter run -d <device-id>

# Run with hot reload
flutter run --hot
```

#### Web Browser

```bash
# Run in Chrome
flutter run -d chrome --web-renderer html

# Or
flutter run -d web-server
# Then open http://localhost:8080 in browser
```

#### Desktop

```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

### Building for Production

#### Android APK

```bash
# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

#### Android App Bundle (Google Play)

```bash
# Build app bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

#### iOS

```bash
# Build for iOS
flutter build ios --release

# Build IPA for App Store
flutter build ipa --release
```

#### Web

```bash
# Build for web
flutter build web --release --web-renderer html

# Output: build/web/
```

#### Windows

```bash
# Build Windows executable
flutter build windows --release

# Output: build/windows/runner/Release/
```

## 🔧 Configuration

### Backend API Connection

Edit the API base URL in your app configuration:

**Location**: `lib/core/config/api_config.dart` (create if doesn't exist)

```dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:8081/graphql';
  static const String graphiqlUrl = 'http://localhost:8081/graphiql';
}
```

For mobile devices, use your computer's IP:
```dart
static const String baseUrl = 'http://192.168.1.100:8081/graphql';
```

### Theme Configuration

Customize colors and themes in:
```
lib/core/theme/app_theme.dart
```

### Localization

Add new language support:

1. Create `.arb` file in `lib/l10n/` (e.g., `app_pt.arb`)
2. Run: `flutter gen-l10n`
3. Use in code:
```dart
import 'package:flareline/flutter_gen/app_localizations.dart';

Text(AppLocalizations.of(context)!.hello)
```

## 📦 Key Dependencies

### Core Framework
- `flutter` - Flutter SDK
- `flutter_localizations` - Internationalization support

### Navigation & State
- `go_router: ^14.0.0` - Declarative routing
- `provider: ^6.1.1` - State management

### UI Components
- `syncfusion_flutter_charts: ^32.1.19` - Chart widgets
- `syncfusion_flutter_datagrid: ^32.1.19` - Data tables
- `popover: ^0.2.9` - Popover components

### HTTP & GraphQL
- Add GraphQL client for backend communication
- `graphql_flutter` (recommended)

### Authentication
- JWT token storage
- Secure storage for credentials

See [pubspec.yaml](pubspec.yaml) for complete dependency list.

## 🎨 UI Components

### Pre-built Components (from FlareLine)

- **Dashboard widgets** - Cards, charts, statistics
- **Data tables** - Sortable, filterable tables
- **Forms** - Input fields, dropdowns, validation
- **Navigation** - Sidebar, app bar, bottom nav
- **Cards** - Various card layouts
- **Buttons** - Primary, secondary, icon buttons
- **Dialogs** - Alerts, confirmations, modals

### Custom Components

- **Carbon Display** - Shows CO₂ emissions
- **Transaction Card** - Transaction list item
- **Eco Score Badge** - User environmental rating
- **Category Icon** - Transaction category indicator

## 🧪 Testing

### Run All Tests

```bash
flutter test
```

### Run Specific Test

```bash
flutter test test/widget_test.dart
```

### Run with Coverage

```bash
flutter test --coverage
```

### Integration Tests

```bash
flutter drive --target=test_driver/app.dart
```

## 🌐 Deployment

### Vercel (Web)

```bash
# Build for web
flutter build web --release --web-renderer html

# Deploy to Vercel
cd build/web
vercel deploy --prod
```

Or use the provided script:
```bash
./deploy_vercel.sh
```

### Google Play Store

1. Create signing key
2. Configure `android/app/build.gradle`
3. Build app bundle: `flutter build appbundle --release`
4. Upload to Google Play Console

### Apple App Store

1. Configure Xcode project
2. Build: `flutter build ipa --release`
3. Upload with Xcode or Application Loader
4. Submit for review in App Store Connect

## 📱 Platform-Specific Notes

### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Requires internet permission in `AndroidManifest.xml`

### iOS
- Minimum iOS version: 12.0
- Requires camera/photo permissions for profile pictures
- Configure Info.plist for permissions

### Web
- Best performance with Chrome
- Use `--web-renderer html` for compatibility
- Configure CORS for API calls

## 🔍 Troubleshooting

### Common Issues

#### "Flutter SDK not found"
```bash
# Add Flutter to PATH (Linux/Mac)
export PATH="$PATH:/path/to/flutter/bin"

# Windows: Add to System Environment Variables
```

#### "Gradle build failed"
```bash
# Update Gradle wrapper
cd android
./gradlew wrapper --gradle-version 8.3
```

#### "CocoaPods not installed" (iOS)
```bash
sudo gem install cocoapods
cd ios
pod install
```

#### API connection issues
```bash
# For Android emulator, use
http://10.0.2.2:8081/graphql

# For iOS simulator, use
http://localhost:8081/graphql

# For physical device, use computer's IP
http://192.168.1.100:8081/graphql
```

#### Hot reload not working
```bash
# Stop app and rebuild
flutter clean
flutter pub get
flutter run
```

## 📚 Learning Resources

### Flutter Documentation
- [Flutter Docs](https://docs.flutter.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Widget Catalog](https://docs.flutter.dev/development/ui/widgets)

### FlareLine Template
- [FlareLine GitHub](https://github.com/FlutterFlareLine/FlareLine)
- [FlareLine Demo](https://flareline.vercel.app/)
- [FlareLine UI Kit](https://github.com/FlutterFlareLine/FlareLine-UiKit)

## 🛠️ Development Tips

### Hot Reload
- Save file (Ctrl+S) for hot reload
- Press `r` in terminal for manual hot reload
- Press `R` for hot restart (loses state)

### Debugging
```bash
# Run with debug logging
flutter run --verbose

# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

### Code Generation
```bash
# Watch for changes and regenerate
flutter pub run build_runner watch
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open pull request

### Code Style
- Follow Flutter style guide
- Use `flutter format` before committing
- Run `flutter analyze` to check for issues

## 📄 License

This project is based on FlareLine Flutter Template (MIT License) and is free for personal and commercial use.

## 🙏 Acknowledgments

- **FlareLine Team** - For the amazing admin dashboard template
- **Flutter Team** - For the excellent framework
- **Syncfusion** - For chart and data grid components

## 🔗 Related Documentation

- [Backend README](../backend/README.md) - Spring Boot API
- [GraphQL API Documentation](../backend/GRAPHQL_API.md) - API reference
- [Project README](../README.md) - Full system overview

## 📧 Support

For issues and questions:
- Check the main [project README](../README.md)
- Review [backend documentation](../backend/README.md)
- Open an issue on GitHub

---

**Demo Credentials:**
- Email: `demo@flareline.com`
- Password: `123456`

**Happy Coding! 🚀🌱**