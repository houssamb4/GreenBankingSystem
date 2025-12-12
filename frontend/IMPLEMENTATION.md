# Green Banking System - Flutter Frontend

A modern, responsive Flutter application for tracking carbon footprint from financial transactions. Built with clean architecture, Riverpod state management, and Material Design 3.

## 🌱 Project Overview

The Green Banking System frontend enables users to:
- Track carbon emissions from transactions
- View personalized insights and recommendations
- Generate detailed reports on carbon footprint
- Manage account preferences
- Responsive design for mobile, tablet, and desktop

## 📁 Project Structure

```
frontend/lib/
├── main.dart                 # App entry point
├── config/
│   ├── theme.dart           # Design system & theme configuration
│   └── router.dart          # Navigation & routing setup
├── models/
│   └── models.dart          # Data models (Transaction, User, etc.)
├── providers/
│   └── providers.dart       # Riverpod state management
├── screens/
│   ├── home/
│   │   └── dashboard_screen.dart
│   ├── transactions/
│   │   ├── transactions_list_screen.dart
│   │   ├── add_transaction_screen.dart
│   │   └── transaction_detail_screen.dart
│   ├── reports/
│   │   └── reports_screen.dart
│   ├── advice/
│   │   └── advice_screen.dart
│   ├── profile/
│   │   └── profile_screen.dart
│   └── layout/
│       └── main_layout.dart
└── widgets/
    └── components.dart      # Reusable UI components
```

## 🎨 Design System

### Colors
- **Primary Dark Green**: `#0B6B3A` - Main actions & branding
- **Primary Light Green**: `#3CB371` - Accents & highlights
- **Background**: `#F6F8F7` - Neutral background
- **Text Dark**: `#1F2937` - Primary text
- **Error Red**: `#DC2626` - Destructive actions
- **Success Green**: `#16A34A` - Confirmations

### Typography
- **Font**: Roboto / Inter
- **Responsive sizing**: 11px - 32px based on context
- **Font weights**: 400, 500, 600, 700

### Spacing & Radius
- **Corner radius**: 12px (default), 8px (small), 16px (large)
- **Padding**: 4px, 8px, 16px, 24px, 32px
- **Shadow**: Soft shadow (0, 2, 8px blur)

## 📱 Responsive Layout

### Desktop (>900px width)
- Fixed sidebar navigation (280px)
- Two-column layouts for forms + preview
- Data tables for transaction lists
- Top app bar with user controls

### Mobile (<900px width)
- Navigation drawer (accessible via menu icon)
- Card-based layouts
- Floating action button for quick actions
- Bottom app bar with bottom navigation

## 🏗️ Architecture

### State Management (Riverpod)
- **Providers**: Global state for user, transactions, reports
- **StateProviders**: Form state for add/edit operations
- **FutureProviders**: Async data fetching from GraphQL

### Navigation (GoRouter)
- Clean declarative routing
- Supports nested navigation with shell routes
- Type-safe route parameters

### Data Models
- `Transaction`: Financial transaction with CO₂ estimate
- `User`: User profile & preferences
- `MonthlyReport`: Aggregated monthly metrics
- `CarbonEstimate`: Calculation breakdown

## 🎯 Page Implementation Status

### ✅ Implemented (High Priority)

#### 1. Dashboard (home/dashboard_screen.dart)
- KPI cards showing monthly metrics
- Daily CO₂ emissions chart
- Top categories breakdown
- Recent transactions list
- Quick add transaction button

**Features**:
- Welcome header with username
- 3 KPI cards (Total CO₂, Transaction count, Average CO₂)
- Simple bar chart for daily emissions
- Category pie chart breakdown
- Transaction list with filtering

#### 2. Transactions List (transactions/transactions_list_screen.dart)
- Search by merchant name
- Multi-filter support (date range, category, CO₂ range)
- Table view (desktop) / Card view (mobile)
- Swipe to delete on mobile
- Export to CSV

**Features**:
- Search bar with autocomplete suggestions
- Filter panel (collapsible)
- Desktop: DataTable with sortable columns
- Mobile: Dismissible cards with swipe actions
- Pagination ready

#### 3. Add/Edit Transaction (transactions/add_transaction_screen.dart)
- Two-column layout (form + carbon estimate preview)
- Date picker
- Amount & currency selection
- Category autocomplete
- Payment method selector
- Real-time CO₂ calculation
- Carbon estimate breakdown

**Features**:
- Form validation
- Live carbon estimate calculation
- Merchant history suggestions
- Optional notes field
- Save/Save & New/Cancel options

#### 4. Transaction Detail (transactions/transaction_detail_screen.dart)
- Full transaction information
- Carbon calculation breakdown
- Edit / Delete actions
- Expandable carbon details

#### 5. Reports (reports/reports_screen.dart)
- Period selector (monthly/annual)
- Summary KPIs
- Daily emissions chart
- Category breakdown chart

#### 6. Advice & Tips (advice/advice_screen.dart)
- Personalized recommendations
- Impact estimation
- Monthly challenges
- Tracking checkboxes

#### 7. Profile & Settings (profile/profile_screen.dart)
- User information display
- Display preferences (currency, unit)
- Security settings (2FA, notifications)
- Danger zone (password, delete account)

## 🔧 Dependencies

### Core
- `flutter_riverpod`: State management
- `go_router`: Navigation
- `intl`: Internationalization & formatting

### UI
- `font_awesome_flutter`: Icons
- Material Design 3 (built-in)

### Optional (Not yet integrated)
- `graphql_flutter`: GraphQL client (for backend integration)
- `shared_preferences`: Local storage
- `flutter_dotenv`: Environment configuration

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.10.3 or higher
- Dart SDK compatible with Flutter version

### Installation

1. **Navigate to frontend directory**
   ```bash
   cd frontend
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Development

**Hot Reload** (code changes without restarting):
```bash
r
```

**Hot Restart** (full app restart):
```bash
R
```

**Run on specific device**:
```bash
flutter devices
flutter run -d <device_id>
```

## 🔌 Backend Integration

### GraphQL Queries Needed

```graphql
# Dashboard
query monthlyReport($userId: ID!, $year: Int!, $month: Int!) {
  monthlyReport {
    totalCarbon
    transactionCount
    co2ByDay
    co2ByCategory
  }
}

# Transactions
query transactions(
  $userId: ID!
  $from: DateTime
  $to: DateTime
  $category: String
  $limit: Int
  $offset: Int
) {
  transactions {
    id
    date
    merchant
    amount
    category
    estimatedCO2
  }
}

# Emission Factors
query emissionFactors($categoryId: ID) {
  factors {
    id
    category
    value
    unit
  }
}
```

### GraphQL Mutations Needed

```graphql
mutation addTransaction($input: TransactionInput!) {
  addTransaction(input: $input) {
    id
    estimatedCO2
  }
}

mutation updateTransaction($id: ID!, $input: TransactionInput!) {
  updateTransaction(id: $id, input: $input) {
    id
  }
}

mutation deleteTransaction($id: ID!) {
  deleteTransaction(id: $id)
}
```

## 📊 State Management Examples

### Access User State
```dart
final user = ref.watch(userProvider);
```

### Update Form State
```dart
ref.read(addTransactionFormProvider.notifier).state = 
  form.copyWith(amount: 100.0);
```

### Watch Async Data
```dart
final transactionsAsync = ref.watch(transactionsProvider);
transactionsAsync.when(
  data: (transactions) => ...,
  loading: () => LoadingState(),
  error: (error, stack) => ErrorWidget(),
);
```

## 🎨 Using Components

### KPI Card
```dart
KpiCard(
  label: 'Total CO₂',
  value: '45.2',
  unit: 'kg',
  icon: Icons.leaf,
  variation: -12.5,
  isPositive: true,
);
```

### Transaction Card
```dart
TransactionCard(
  transaction: transaction,
  onTap: () => ...,
  onEdit: () => ...,
  onDelete: () => ...,
);
```

### Category Badge
```dart
CategoryBadge(
  category: Category.food,
  compact: false,
);
```

## 🧪 Testing

(To be implemented)

```bash
flutter test
```

## 📝 Code Guidelines

### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Constants**: `camelCase`
- **Private members**: `_leadingUnderscore`

### Widget Structure
```dart
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### Spacing & Padding
Always use `AppTheme` constants:
- `paddingSmall` = 8px
- `paddingMedium` = 16px
- `paddingLarge` = 24px

## 🐛 Known Limitations

1. **Mock Data**: Currently uses placeholder data; needs GraphQL integration
2. **Authentication**: Not implemented yet
3. **Offline Support**: Requires implementation
4. **Charts**: Simple implementations; consider fl_chart or charts_flutter for advanced visualizations

## 📋 TODO / Future Enhancements

- [ ] Integrate GraphQL client
- [ ] Implement authentication flow
- [ ] Add advanced charting with fl_chart
- [ ] Implement offline-first with Hive
- [ ] Add unit & widget tests
- [ ] Admin panel for category/factor management
- [ ] Real-time notifications
- [ ] Dark mode support
- [ ] Localization (multi-language)
- [ ] PDF export for reports

## 🤝 Contributing

1. Follow the code guidelines above
2. Use meaningful commit messages
3. Test changes locally before pushing
4. Create feature branches from `main`

## 📄 License

(To be specified)

---

**Last Updated**: December 2024
**Version**: 1.0.0 (MVP)
