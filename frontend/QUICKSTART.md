# Green Banking System - Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### Step 1: Install Dependencies
```bash
cd frontend
flutter pub get
```

### Step 2: Run the App
```bash
flutter run
```

The app will launch on your default device/emulator with the Dashboard page.

---

## 📱 Navigation Overview

### Main Menu (Drawer on Mobile / Sidebar on Desktop)
1. **Dashboard** (`/`) - Home page with KPIs & recent transactions
2. **Transactions** (`/transactions`) - List all transactions
3. **Reports** (`/reports`) - Analyze carbon footprint
4. **Advice** (`/advice`) - Get personalized recommendations
5. **Profile** (`/profile`) - Manage settings

### Quick Actions
- **FAB (Floating Action Button)** - Add new transaction
- **AppBar Menu** - Notifications, settings

---

## 🎯 Current Implementation Status

### ✅ Fully Implemented
- Dashboard with KPI cards and recent transactions
- Transactions list with search & filters
- Add transaction form with CO₂ calculation preview
- Transaction detail view
- Reports page
- Advice & tips page
- Profile & settings page
- Responsive desktop/mobile layouts
- Complete design system

### ⚠️ Needs Backend Integration
- GraphQL queries/mutations
- Real data fetching
- User authentication
- Database persistence

### 📋 Next Steps
1. Connect GraphQL backend
2. Implement authentication
3. Add advanced charts (fl_chart)
4. Setup CI/CD pipeline

---

## 🔧 Development Workflow

### Hot Reload
Press `r` in terminal to reload code changes without losing state.

### Hot Restart  
Press `R` in terminal to restart the app and rebuild everything.

### Debug
```bash
flutter run --debug
```

### Profile Performance
```bash
flutter run --profile
```

### Build Release
```bash
flutter build apk    # Android
flutter build ios    # iOS
flutter build web    # Web
```

---

## 📊 Test Data

The app uses mock data in providers. To connect real data:

1. **Update providers** in `lib/providers/providers.dart`:
```dart
final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  // Replace mock with GraphQL query
  final result = await ref.watch(graphqlProvider).query(transactionsQuery);
  return result.map((json) => Transaction.fromJson(json)).toList();
});
```

2. **Configure GraphQL client** in a new service file:
```dart
// lib/services/graphql_service.dart
class GraphQLService {
  // Initialize graphql_flutter client
}
```

---

## 🎨 Customizing Theme

Edit `lib/config/theme.dart`:

```dart
// Change primary color
static const Color primaryDarkGreen = Color(0xFF0B6B3A); // ← Change here

// Update typography
displayLarge: TextStyle(
  fontSize: 32, // Adjust size
  fontWeight: FontWeight.w700,
  color: textDark,
),
```

---

## 📝 Adding a New Screen

1. **Create the screen file**:
   ```bash
   touch lib/screens/myfeature/my_screen.dart
   ```

2. **Add route** in `lib/config/router.dart`:
   ```dart
   GoRoute(
     path: '/myfeature',
     name: 'myfeature',
     builder: (context, state) => const MyScreen(),
   ),
   ```

3. **Add navigation item** to `lib/screens/layout/main_layout.dart`:
   ```dart
   _NavItem(
     label: 'My Feature',
     icon: Icons.star,
     route: Routes.myfeature,
   ),
   ```

4. **Navigate to it**:
   ```dart
   context.go(Routes.myfeature);
   ```

---

## 🧩 Creating a New Component

1. **Add to** `lib/widgets/components.dart`:
```dart
class MyComponent extends StatelessWidget {
  final String title;
  
  const MyComponent({
    Key? key,
    required this.title,
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

2. **Export it** in the same file (components.dart is main component file)

3. **Use it**:
```dart
MyComponent(title: 'Hello')
```

---

## 🔌 GraphQL Integration Checklist

When ready to integrate backend:

- [ ] Install `graphql_flutter`
- [ ] Create `lib/services/graphql_service.dart`
- [ ] Define queries in `lib/services/queries.dart`
- [ ] Update providers to use GraphQL client
- [ ] Test queries in GraphQL playground
- [ ] Handle loading/error states
- [ ] Add request/response logging
- [ ] Setup authentication token handling

### Example GraphQL Setup:
```dart
// lib/services/graphql_service.dart
class GraphQLService {
  late GraphQLClient _client;
  
  GraphQLService(String apiUrl, String? token) {
    final httpLink = HttpLink(apiUrl);
    final authLink = AuthLink(getToken: () => 'Bearer $token');
    
    _client = GraphQLClient(
      link: authLink.concat(httpLink),
      cache: GraphQLCache(),
    );
  }
  
  Future<List<Transaction>> getTransactions() async {
    final result = await _client.query(QueryOptions(
      document: gql(transactionsQuery),
    ));
    
    if (result.hasException) throw result.exception!;
    
    return (result.data?['transactions'] as List)
        .map((json) => Transaction.fromJson(json))
        .toList();
  }
}
```

---

## 🐛 Common Issues

### "Package not found" error
```bash
flutter clean
flutter pub get
flutter run
```

### Hot reload not working
- Restart the Flutter run process (Ctrl+C, then `flutter run`)
- Check for syntax errors

### App crashes on navigation
- Verify route paths in `router.dart`
- Check that all imported screens exist
- Ensure BuildContext is correct

### Performance issues
- Use `const` constructors where possible
- Profile with `--profile` build
- Check for rebuild cycles with DevTools

---

## 📚 Useful Resources

- [Flutter Docs](https://flutter.dev/docs)
- [Riverpod Docs](https://riverpod.dev)
- [GoRouter Docs](https://pub.dev/packages/go_router)
- [Material Design 3](https://m3.material.io/)

---

## 💡 Pro Tips

1. **Use `const` for performance**:
   ```dart
   const EdgeInsets.all(8) // Good
   EdgeInsets.all(8)       // Unnecessary rebuilds
   ```

2. **Leverage Riverpod for caching**:
   ```dart
   ref.read(transactionsProvider); // Cached query
   ref.refresh(transactionsProvider); // Force refresh
   ```

3. **Use named routes**:
   ```dart
   context.go(Routes.dashboard); // Not context.go('/');
   ```

4. **Responsive UI Check**:
   ```dart
   final isDesktop = MediaQuery.of(context).size.width > 900;
   ```

5. **Debug State**:
   ```dart
   // Print current state
   debugPrint('State: ${ref.watch(myProvider)}');
   ```

---

## 📞 Need Help?

- Check [IMPLEMENTATION.md](IMPLEMENTATION.md) for detailed architecture
- See [COMPONENTS.md](COMPONENTS.md) for component reference
- Review [README.md](../README.md) for project overview

**Last Updated**: December 2024
