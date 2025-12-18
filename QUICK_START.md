# Quick Start Guide: Frontend-Backend Integration

## ✅ What's Been Done

Your Flutter frontend is now fully integrated with your GraphQL backend! Here's what has been implemented:

### 🔧 Services Created

1. **GraphQLService** - Handles all GraphQL API communication
2. **TokenStorageService** - Securely stores authentication tokens
3. **AuthService** - Manages login, registration, and user sessions
4. **TransactionService** - Handles all transaction-related operations

### 📦 Models Created

1. **User** - User data with eco-score tracking
2. **Transaction** - Transaction data with carbon footprint
3. **CarbonStats** - Carbon usage statistics
4. **CategoryBreakdown** - Category-wise carbon analysis

### 🎨 UI Updates

1. **Sign-in page** - Now connects to backend with loading states
2. **Register page** - Fully functional with proper error handling

## 🚀 How to Use

### 1. Start the Backend

```powershell
cd c:\Users\houss\projects\GreenBankingSystem\backend
.\mvnw.cmd spring-boot:run
```

Wait until you see: `Started GreenBankingApplication`

### 2. Run the Frontend

```powershell
cd c:\Users\houss\projects\GreenBankingSystem\frontend
flutter run
```

### 3. Test the Integration

1. Click "Sign Up" in the app
2. Enter your details:
   - Full Name: John Doe
   - Email: john@example.com
   - Password: password123
3. Click "Create Account"
4. You should be logged in automatically! ✨

## 📝 Code Examples

### Login

```dart
import 'package:greenpay/core/services/auth_service.dart';

final authService = AuthService.instance;
final result = await authService.login('user@example.com', 'password123');
print('Welcome ${result['user']['firstName']}!');
```

### Create Transaction

```dart
import 'package:greenpay/core/services/transaction_service.dart';
import 'package:greenpay/core/services/token_storage_service.dart';

final transactionService = TransactionService.instance;
final transaction = await transactionService.createTransaction(
  amount: 50.0,
  category: 'FOOD',
  merchant: 'Whole Foods',
  description: 'Weekly groceries',
);
print('Carbon footprint: ${transaction.carbonFootprint} kg CO₂');
```

### Get Carbon Statistics

```dart
final userId = await TokenStorageService.instance.getUserId();
final stats = await transactionService.getCarbonStats(userId!);
print('Monthly carbon: ${stats.monthlyCarbon} kg CO₂');
print('Eco score: ${stats.ecoScore}');
```

## 🔐 Security Features

- ✅ JWT tokens stored securely using Flutter Secure Storage
- ✅ Automatic token attachment to all authenticated requests
- ✅ Password validation (min 8 characters)
- ✅ Email validation
- ✅ Secure HTTPS ready (just update the endpoint URL)

## 📱 Available Categories

When creating transactions, use these categories:

- `FOOD` - 0.5 kg CO₂/$
- `TRANSPORT` - 2.1 kg CO₂/$ (highest except travel)
- `SHOPPING` - 0.8 kg CO₂/$
- `ENERGY` - 1.7 kg CO₂/$
- `SERVICES` - 0.3 kg CO₂/$
- `ENTERTAINMENT` - 0.6 kg CO₂/$
- `TRAVEL` - 3.5 kg CO₂/$ (highest!)
- `HEALTHCARE` - 0.4 kg CO₂/$
- `EDUCATION` - 0.2 kg CO₂/$
- `TECHNOLOGY` - 1.2 kg CO₂/$
- `FASHION` - 1.0 kg CO₂/$
- `HOME` - 0.9 kg CO₂/$
- `GREEN` - 0.1 kg CO₂/$ (lowest!)
- `OTHER` - 0.5 kg CO₂/$

## ⚙️ Configuration

### Backend URL

Located in `lib/core/services/graphql_service.dart`:

```dart
final String _endpoint = 'http://localhost:8080/graphql';
```

**For Android Emulator:**
```dart
final String _endpoint = 'http://10.0.2.2:8080/graphql';
```

**For Physical Device:**
```dart
final String _endpoint = 'http://YOUR_IP_ADDRESS:8080/graphql';
```

## 🐛 Troubleshooting

### "Connection refused" error

Make sure the backend is running on port 8080. Check with:
```powershell
netstat -ano | findstr :8080
```

### "Invalid credentials" error

The user might not exist. Register a new account first.

### Token issues

Clear stored tokens:
```dart
await TokenStorageService.instance.clearAll();
```

### Dependencies not found

Run:
```powershell
flutter clean
flutter pub get
```

## 📊 Next Steps

1. **Build Dashboard**: Display carbon stats and transactions
2. **Add Transaction Form**: Let users manually add transactions
3. **Create Charts**: Visualize carbon footprint over time
4. **Implement Categories**: Show breakdown by category
5. **Add Notifications**: Alert when approaching carbon budget
6. **Offline Mode**: Cache data locally

## 📚 API Documentation

Full GraphQL API documentation is available in:
`c:\Users\houss\projects\GreenBankingSystem\backend\GRAPHQL_API.md`

Test queries interactively at:
`http://localhost:8080/graphiql`

## 🎉 Success!

Your app is now fully connected to the backend. You can:
- ✅ Register new users
- ✅ Login existing users
- ✅ Create transactions with automatic carbon calculation
- ✅ Fetch user statistics
- ✅ Get category breakdowns
- ✅ Update carbon budgets

Happy coding! 🚀🌱
