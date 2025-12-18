# Frontend-Backend Integration

## Overview

The Flutter frontend is now connected to the GraphQL backend using the following architecture:

### Services Created

1. **GraphQLService** (`lib/core/services/graphql_service.dart`)
   - Manages GraphQL client configuration
   - Handles authentication headers with JWT tokens
   - Endpoint: `http://localhost:8080/graphql`

2. **TokenStorageService** (`lib/core/services/token_storage_service.dart`)
   - Securely stores JWT tokens and refresh tokens using `flutter_secure_storage`
   - Manages user session data (ID, email)

3. **AuthService** (`lib/core/services/auth_service.dart`)
   - Handles user authentication (login/register)
   - Manages JWT token lifecycle
   - GraphQL mutations: `login`, `register`
   - GraphQL queries: `getCurrentUser`

4. **TransactionService** (`lib/core/services/transaction_service.dart`)
   - Manages transaction operations
   - GraphQL mutations: `createTransaction`, `updateCarbonBudget`
   - GraphQL queries: `getUserTransactions`, `getCarbonStats`, `getCategoryBreakdown`

### Models Created

1. **User** (`lib/core/models/user.dart`)
   - User data model with eco score and carbon tracking

2. **Transaction** (`lib/core/models/transaction.dart`)
   - Transaction data model with carbon footprint calculation
   - CarbonStats model for analytics
   - CategoryBreakdown model for category-wise analysis

### Updated Components

1. **SignInProvider** (`lib/pages/auth/sign_in/sign_in_provider.dart`)
   - Integrated with AuthService
   - Added loading states
   - Error handling with user-friendly messages

2. **RegisterProvider** (`lib/pages/auth/register/register_provider.dart`)
   - New provider for registration
   - Integrated with AuthService
   - Form validation and error handling

3. **RegisterPage** (`lib/pages/auth/register/register_page.dart`)
   - Updated to use RegisterProvider
   - Added loading indicators
   - Connected to GraphQL backend

4. **SignInPage** (`lib/pages/auth/sign_in/sign_in_page.dart`)
   - Added loading state to sign-in button

## Setup Instructions

### 1. Install Dependencies

```bash
cd frontend
flutter pub get
```

### 2. Start the Backend

Make sure your GraphQL backend is running on `http://localhost:8080/graphql`

```bash
cd backend
./mvnw spring-boot:run
# or on Windows:
mvnw.cmd spring-boot:run
```

### 3. Run the Frontend

```bash
cd frontend
flutter run
```

## Configuration

### Backend URL

The backend URL is configured in `lib/core/services/graphql_service.dart`:

```dart
final String _endpoint = 'http://localhost:8080/graphql';
```

For production, update this to your production GraphQL endpoint.

### Security

- JWT tokens are stored securely using `flutter_secure_storage`
- Tokens are automatically attached to GraphQL requests via `AuthLink`
- Token refresh logic can be added in the future

## Features Implemented

### Authentication
- ✅ User registration with email/password
- ✅ User login with email/password
- ✅ JWT token management
- ✅ Secure token storage
- ✅ Loading states and error handling

### Transaction Management (Services Ready)
- ✅ Create transaction
- ✅ Get user transactions
- ✅ Get carbon statistics
- ✅ Get category breakdown
- ✅ Update carbon budget

## API Usage Examples

### Login

```dart
final authService = AuthService.instance;
final result = await authService.login('user@example.com', 'password123');
```

### Register

```dart
final authService = AuthService.instance;
final result = await authService.register(
  email: 'user@example.com',
  password: 'password123',
  firstName: 'John',
  lastName: 'Doe',
);
```

### Create Transaction

```dart
final transactionService = TransactionService.instance;
final transaction = await transactionService.createTransaction(
  amount: 50.0,
  category: 'FOOD',
  merchant: 'Whole Foods',
  description: 'Weekly groceries',
);
```

### Get Carbon Stats

```dart
final transactionService = TransactionService.instance;
final userId = await TokenStorageService.instance.getUserId();
final stats = await transactionService.getCarbonStats(userId!);
```

## Next Steps

1. **Implement Dashboard**: Use `TransactionService` to display user's carbon footprint
2. **Add Transaction UI**: Create screens for adding and viewing transactions
3. **Carbon Analytics**: Build charts using `CarbonStats` and `CategoryBreakdown`
4. **Token Refresh**: Implement automatic token refresh before expiry
5. **Error Handling**: Add global error handling for network issues
6. **Loading States**: Add global loading indicator
7. **Offline Support**: Cache data locally for offline access

## Troubleshooting

### Connection Issues

If you get connection errors:

1. Make sure backend is running on port 8080
2. For Android emulator, use `http://10.0.2.2:8080/graphql` instead
3. For iOS simulator, use `http://localhost:8080/graphql`
4. For physical devices, use your computer's IP address

Update the endpoint in `graphql_service.dart` accordingly.

### Dependencies

If you encounter dependency issues, run:

```bash
flutter clean
flutter pub get
```

## Testing

To test the authentication flow:

1. Start the backend
2. Run the frontend
3. Navigate to the register page
4. Create a new account
5. You should be redirected to the home page with a success message

To verify in GraphiQL:

```graphql
query {
  getCurrentUser {
    id
    email
    firstName
    lastName
  }
}
```

Add the JWT token in the Authorization header:
```
Authorization: Bearer <your-jwt-token>
```
