# Green Banking System - Complete Development Guide

**Last Updated**: 2024  
**Project Status**: MVP Implementation Complete ✅

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Project Architecture](#project-architecture)
3. [File Structure](#file-structure)
4. [Development Workflow](#development-workflow)
5. [Testing Strategy](#testing-strategy)
6. [Deployment Guide](#deployment-guide)
7. [Troubleshooting](#troubleshooting)
8. [Common Tasks](#common-tasks)

---

## Quick Start

### Prerequisites

- Flutter SDK: `^3.10.3`
- Dart: Latest compatible version
- Android Studio / Xcode (for mobile development)
- VS Code with Flutter/Dart extensions (recommended)

### Getting Up and Running

```bash
# 1. Navigate to frontend directory
cd frontend

# 2. Get dependencies
flutter pub get

# 3. Run the application
flutter run

# 4. Select device (emulator, simulator, or physical device)
```

### First Build (5-10 minutes)

```bash
# Full clean build
flutter clean
flutter pub get
flutter run -v  # Verbose mode for debugging

# For web
flutter run -d chrome

# For desktop (Windows)
flutter run -d windows
```

---

## Project Architecture

### Layered Architecture

```
┌─────────────────────────────────────────┐
│         UI Layer (Screens)              │
│  (Dashboard, Transactions, Reports...)  │
├─────────────────────────────────────────┤
│      Components & Widgets Layer         │
│  (KpiCard, TransactionCard, ...)        │
├─────────────────────────────────────────┤
│    State Management Layer (Riverpod)    │
│  (Providers, Family providers)          │
├─────────────────────────────────────────┤
│       Models & Data Layer               │
│  (Transaction, User, MonthlyReport...)  │
├─────────────────────────────────────────┤
│    Services Layer (GraphQL, Auth)       │
│  (graphql_service.dart - To implement)  │
├─────────────────────────────────────────┤
│       Theme & Config Layer              │
│  (theme.dart, router.dart)              │
└─────────────────────────────────────────┘
```

### State Management Pattern (Riverpod)

**Providers Used:**

1. **User Provider** - Current logged-in user
   ```dart
   final userProvider = StateProvider<User?>((ref) => null);
   ```

2. **Transactions Provider** - List of user transactions
   ```dart
   final transactionsProvider = FutureProvider<List<Transaction>>((ref) {
     // TODO: Connect to GraphQL
     return [];
   });
   ```

3. **Monthly Report Provider** - Report for specific month
   ```dart
   final monthlyReportProvider = FutureProvider.family<MonthlyReport, DateTime>((ref, date) {
     // Parameterized by month/year
   });
   ```

4. **Filter State** - Transaction list filters
   ```dart
   final transactionFiltersProvider = StateProvider<TransactionFilters>((ref) => TransactionFilters());
   ```

**Best Practices:**

- Use `ConsumerWidget` for widgets that need state
- Use `ref.watch()` for reactive data
- Use `ref.read()` for one-time data access
- Use `.family` for parameterized providers
- Use `FutureProvider` for async operations (GraphQL, API calls)

### Navigation Pattern (GoRouter)

**Routes Available:**

| Route | Path | Purpose |
|-------|------|---------|
| dashboard | / | Home screen |
| transactions | /transactions | Transaction list |
| addTransaction | /transactions/add | Create transaction |
| transactionDetail | /transactions/:id | View transaction |
| reports | /reports | Carbon reports |
| advice | /advice | Eco-tips & recommendations |
| profile | /profile | User settings |

**Type-safe Navigation:**

```dart
// Programmatic navigation
context.go(Routes.dashboard);
context.go(Routes.transactionDetailPath('123'));

// From GoRouter
router.go('/transactions/123');

// With parameters
context.pushNamed('transactionDetail', pathParameters: {'id': '456'});
```

---

## File Structure

```
frontend/lib/
├── main.dart                          # App entry point
├── config/
│   ├── theme.dart                     # Design system (colors, typography, spacing)
│   └── router.dart                    # Navigation configuration
├── models/
│   └── models.dart                    # Data classes (Transaction, User, Report...)
├── providers/
│   └── providers.dart                 # Riverpod state management
├── widgets/
│   └── components.dart                # Reusable UI components
├── screens/
│   ├── layout/
│   │   └── main_layout.dart           # Main app shell (sidebar/drawer)
│   ├── home/
│   │   └── dashboard_screen.dart      # Dashboard page
│   ├── transactions/
│   │   ├── transactions_list_screen.dart
│   │   ├── add_transaction_screen.dart
│   │   └── transaction_detail_screen.dart
│   ├── reports/
│   │   └── reports_screen.dart        # Carbon reports
│   ├── advice/
│   │   └── advice_screen.dart         # Tips & recommendations
│   ├── profile/
│   │   └── profile_screen.dart        # User settings
│   └── admin/
│       └── admin_screen.dart          # Admin panel (placeholder)
└── services/
    └── (graphql_service.dart - To create)
```

---

## Development Workflow

### Hot Reload

Flutter hot reload instantly applies code changes:

```bash
flutter run
# Make changes to code
# Press 'r' in terminal to hot reload
# Press 'R' for hot restart (rebuilds entire app)
```

**What Hot Reload Works With:**
- Widget code changes ✅
- Provider logic changes ✅
- Theme changes ✅
- Asset changes (images) ⚠️ (may need restart)

**What Requires Full Restart:**
- Model changes (after JSON serialization update)
- New dependencies added
- Route changes
- Plugin changes

### Adding a New Screen

1. **Create screen file** in `lib/screens/[feature]/[feature]_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/config/theme.dart';
import 'package:frontend/widgets/components.dart';

class MyNewScreen extends ConsumerWidget {
  const MyNewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    
    return Scaffold(
      appBar: AppBar(title: const Text('My New Screen')),
      body: Center(
        child: Text(isMobile ? 'Mobile' : 'Desktop'),
      ),
    );
  }
}
```

2. **Add route** in `lib/config/router.dart`:

```dart
GoRoute(
  path: 'mynewscreen',
  name: 'myNewScreen',
  builder: (context, state) => const MyNewScreen(),
),
```

3. **Add navigation item** in `lib/screens/layout/main_layout.dart`:

```dart
_NavItem(
  icon: Icons.star,
  label: 'My Feature',
  route: Routes.myNewScreen,
  isActive: state.name == Routes.myNewScreen,
),
```

### Adding a New Component

1. **Add to** `lib/widgets/components.dart`:

```dart
class MyNewComponent extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  
  const MyNewComponent({
    required this.title,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
        boxShadow: const [AppTheme.softShadow],
      ),
      child: Text(title),
    );
  }
}
```

2. **Document** in `COMPONENTS.md` with:
   - Purpose
   - Properties table
   - Usage example
   - Best practices

### Working with Providers

**Reading State:**

```dart
// In ConsumerWidget
final transactions = ref.watch(transactionsProvider);

// Handle loading/error states
transactions.when(
  data: (data) => Text('${data.length} transactions'),
  loading: () => const LoadingState(),
  error: (err, stack) => Text('Error: $err'),
);
```

**Updating State:**

```dart
// Simple state update
ref.read(userProvider.notifier).state = newUser;

// Complex updates with provider
final filters = ref.read(transactionFiltersProvider);
ref.read(transactionFiltersProvider.notifier).state = 
  filters.copyWith(category: 'food');
```

**Invalidating Cache:**

```dart
// Force provider to refresh
ref.refresh(monthlyReportProvider(DateTime.now()));

// Refresh and get new data
final newData = await ref.refresh(transactionsProvider.future);
```

---

## Testing Strategy

### Unit Tests

Test individual functions and classes:

```dart
// test/models/models_test.dart
void main() {
  group('Transaction', () {
    test('creates transaction from JSON', () {
      final json = {
        'id': '1',
        'amount': 100,
        'category': 'food',
        'merchant': 'Pizza Place',
      };
      
      final transaction = Transaction.fromJson(json);
      expect(transaction.id, '1');
      expect(transaction.amount, 100);
    });
  });
}
```

### Widget Tests

Test UI components:

```dart
// test/widgets/components_test.dart
void main() {
  testWidgets('KpiCard displays value', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: KpiCard(
            label: 'Total CO₂',
            value: '42.5',
            unit: 'kg',
            icon: Icons.leaf,
          ),
        ),
      ),
    );

    expect(find.text('42.5'), findsOneWidget);
    expect(find.text('kg'), findsOneWidget);
  });
}
```

### Integration Tests

Test full user flows:

```bash
# Run integration tests
flutter test integration_test/app_test.dart
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/models_test.dart

# Run tests with coverage
flutter test --coverage

# View coverage report (Linux/Mac)
lcov --list coverage/lcov.info
```

---

## Deployment Guide

### Building for Production

#### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Google Play)
flutter build appbundle --release
```

**Output**: `build/app/outputs/flutter-apk/app-release.apk`

#### iOS

```bash
# Build IPA
flutter build ios --release
```

**Output**: `build/ios/ipa/`

#### Web

```bash
# Build for web
flutter build web --release

# Deploy to hosting (Firebase, Netlify, etc.)
firebase deploy --project=your-project
```

#### Windows Desktop

```bash
# Build Windows executable
flutter build windows --release
```

**Output**: `build/windows/runner/Release/`

### Environment Configuration

Create `.env` files for different environments:

```
# .env.development
API_URL=http://localhost:8080/graphql
DEBUG_MODE=true

# .env.production
API_URL=https://api.greenbanking.com/graphql
DEBUG_MODE=false
```

Load in `main.dart`:

```dart
Future<void> main() async {
  final env = const String.fromEnvironment('APP_ENV', defaultValue: 'development');
  // Load configuration
  runApp(const MyApp());
}
```

---

## Troubleshooting

### Common Issues

#### 1. **"Dependency version mismatch"**

```bash
# Clean and reinstall
flutter clean
flutter pub get
flutter pub upgrade
```

#### 2. **"Device not found"**

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d device-id

# Create Android emulator
flutter emulators --create

# Run emulator
flutter emulators --launch emulator-5554
```

#### 3. **"Hot reload not working"**

- Press 'R' for full hot restart instead
- Ensure no syntax errors in modified files
- Check terminal for compilation errors

#### 4. **"Build fails on web"**

```bash
# Clean web build
rm -rf build/web
flutter clean
flutter pub get
flutter run -d chrome
```

#### 5. **"Riverpod provider not updating"**

- Ensure using `StateProvider` not `Provider` for mutable state
- Check that using `ref.read(...notifier).state` not `ref.watch()`
- Invalidate provider if cached: `ref.refresh()`

### Debug Mode

```bash
# Run with verbose logging
flutter run -v

# Enable debug breakpoints in VS Code
# Place breakpoint in code, press F5 or debug icon
```

---

## Common Tasks

### Connecting to GraphQL Backend

1. **Create GraphQL service** (`lib/services/graphql_service.dart`):

```dart
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  static final HttpLink _httpLink = HttpLink(
    'https://api.example.com/graphql',
  );
  
  static final AuthLink _authLink = AuthLink(
    getToken: () async {
      final token = await _getToken(); // From secure storage
      return 'Bearer $token';
    },
  );
  
  static final Link _link = _authLink.concat(_httpLink);
  
  static GraphQLClient getClient() {
    return GraphQLClient(
      link: _link,
      cache: GraphQLCache(),
    );
  }
  
  static Future<String?> _getToken() async {
    // Retrieve from shared_preferences
    return null;
  }
}
```

2. **Update providers** in `lib/providers/providers.dart`:

```dart
final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final client = GraphQLService.getClient();
  
  const String query = '''
    query GetTransactions {
      transactions {
        id
        amount
        category
        merchant
        date
        estimatedCO2grams
      }
    }
  ''';
  
  final result = await client.query(
    QueryOptions(document: gql(query)),
  );
  
  if (result.hasException) throw result.exception!;
  
  final data = result.data?['transactions'] as List;
  return data.map((t) => Transaction.fromJson(t)).toList();
});
```

3. **Test connection**:

```bash
flutter run
# Navigate to Transactions screen and verify data loads
```

### Adding User Authentication

1. **Create auth provider**:

```dart
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null);
  
  Future<void> login(String email, String password) async {
    // TODO: Call GraphQL login mutation
    // Save token to secure storage
    // Update state with user
  }
  
  Future<void> logout() async {
    state = null;
    // TODO: Clear secure storage
  }
}
```

2. **Add authentication guard** in router:

```dart
GoRoute(
  path: 'profile',
  builder: (context, state) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return const LoginScreen();
    }
    return const ProfileScreen();
  },
),
```

### Customizing Theme

**Global color change:**

Edit `lib/config/theme.dart`:

```dart
static const Color primaryDarkGreen = Color(0xFF0B6B3A); // Change this
static const Color primaryLightGreen = Color(0xFF3CB371); // Or this
```

Hot reload will apply everywhere.

**Per-widget override:**

```dart
Container(
  color: AppTheme.primaryDarkGreen.withOpacity(0.8),
  child: ...,
)
```

---

## Performance Optimization

### Key Optimizations

1. **Use `const` constructors** where possible:
   ```dart
   const KpiCard(...) // Avoids rebuilds
   ```

2. **Minimize rebuilds** with Riverpod selectors:
   ```dart
   ref.watch(transactionsProvider.select((t) => t.length)) // Only watch length
   ```

3. **Lazy load** large lists:
   ```dart
   // Use ListView.builder instead of ListView
   ListView.builder(
     itemCount: items.length,
     itemBuilder: (context, index) => ...,
   )
   ```

4. **Cache expensive computations**:
   ```dart
   final expensiveComputeProvider = Provider<Result>((ref) {
     return expensiveComputation();
   }); // Cached by default
   ```

### Monitoring Performance

```bash
# Profile app performance
flutter run --profile

# Check memory usage
flutter run --verbose 2>&1 | grep "memory"

# Analyze frame rendering
# Open DevTools: dart devtools
```

---

## Resources & References

### Documentation

- [Flutter Docs](https://flutter.dev/docs)
- [Riverpod Docs](https://riverpod.dev)
- [GoRouter Docs](https://pub.dev/documentation/go_router/latest/)
- [Material 3 Guide](https://m3.material.io/)

### Useful Commands

```bash
# View project structure
flutter pub tree

# Check for security vulnerabilities
flutter pub audit

# Generate code (for build_runner)
flutter pub run build_runner build

# Format code
flutter format .

# Analyze code
flutter analyze

# View installed packages
flutter pub global list
```

---

## Next Steps

### Immediate (Week 1-2)
1. ✅ Run the app and verify all pages load
2. ✅ Test navigation between pages
3. ⏳ Setup backend GraphQL endpoint
4. ⏳ Implement database integration

### Short-term (Week 3-4)
1. ⏳ Connect to real GraphQL backend
2. ⏳ Implement user authentication
3. ⏳ Add PDF/CSV export functionality
4. ⏳ Implement offline mode with Hive

### Long-term (Week 5+)
1. ⏳ Advanced charting with fl_chart
2. ⏳ Real-time notifications
3. ⏳ Custom reports builder
4. ⏳ Multi-language support (i18n)
5. ⏳ Dark mode support

---

## Support

For questions or issues:

1. Check `QUICKSTART.md` for common questions
2. Review `IMPLEMENTATION.md` for architectural details
3. Check `COMPONENTS.md` for component usage
4. See `PROJECT_SUMMARY.md` for overview

---

**Happy coding! 🌱**
