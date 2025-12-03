# GraphQL API Documentation

## Endpoint

- **URL**: `http://localhost:8080/graphql`
- **GraphiQL Interface**: `http://localhost:8080/graphiql`

## Authentication

All authenticated endpoints require a JWT token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

## Mutations

### 1. Register User

```graphql
mutation Register {
  register(input: {
    email: "user@example.com"
    password: "password123"
    firstName: "John"
    lastName: "Doe"
  }) {
    token
    refreshToken
    user {
      id
      email
      firstName
      lastName
      ecoScore
      totalCarbonSaved
      monthlyCarbonBudget
    }
  }
}
```

### 2. Login

```graphql
mutation Login {
  login(input: {
    email: "user@example.com"
    password: "password123"
  }) {
    token
    refreshToken
    user {
      id
      email
      firstName
      lastName
      ecoScore
    }
  }
}
```

### 3. Create Transaction

**Requires Authentication**

```graphql
mutation CreateTransaction {
  createTransaction(input: {
    amount: 50.00
    category: "FOOD"
    merchant: "Whole Foods"
    description: "Weekly groceries"
  }) {
    id
    amount
    currency
    category
    merchant
    description
    carbonFootprint
    transactionDate
    createdAt
  }
}
```

**Carbon Footprint is Automatically Calculated!**

### 4. Update Transaction

**Requires Authentication**

```graphql
mutation UpdateTransaction {
  updateTransaction(
    id: "transaction-uuid-here"
    input: {
      amount: 75.00
      category: "TRANSPORT"
      merchant: "Uber"
    }
  ) {
    id
    carbonFootprint
  }
}
```

### 5. Delete Transaction

**Requires Authentication**

```graphql
mutation DeleteTransaction {
  deleteTransaction(id: "transaction-uuid-here")
}
```

### 6. Update Carbon Budget

**Requires Authentication**

```graphql
mutation UpdateBudget {
  updateCarbonBudget(budget: 150.0) {
    id
    monthlyCarbonBudget
  }
}
```

## Queries

### 1. Get Current User

**Requires Authentication**

```graphql
query GetCurrentUser {
  getCurrentUser {
    id
    email
    firstName
    lastName
    ecoScore
    totalCarbonSaved
    monthlyCarbonBudget
    createdAt
    updatedAt
  }
}
```

### 2. Get User Transactions

**Requires Authentication**

```graphql
query GetTransactions {
  getUserTransactions(userId: "user-uuid-here") {
    id
    amount
    currency
    category
    merchant
    description
    carbonFootprint
    transactionDate
    createdAt
  }
}
```

### 3. Get Carbon Statistics

**Requires Authentication**

```graphql
query GetCarbonStats {
  getCarbonStats(userId: "user-uuid-here") {
    userId
    totalCarbon
    monthlyCarbon
    carbonBudget
    carbonPercentage
    ecoScore
  }
}
```

### 4. Get Category Breakdown

**Requires Authentication**

```graphql
query GetCategoryBreakdown {
  getCategoryBreakdown(userId: "user-uuid-here") {
    category
    totalCarbon
    totalAmount
    transactionCount
    percentage
  }
}
```

## Carbon Emission Factors

| Category | Emission Factor (kg CO₂/$) | Description |
|----------|---------------------------|-------------|
| FOOD | 0.5 | Food and groceries |
| TRANSPORT | 2.1 | Transportation, fuel, rideshare |
| SHOPPING | 0.8 | General retail purchases |
| ENERGY | 1.7 | Utilities - electricity, gas, water |
| SERVICES | 0.3 | Services and subscriptions |
| ENTERTAINMENT | 0.6 | Entertainment, dining out |
| TRAVEL | 3.5 | **Air travel, hotels (highest)** |
| HEALTHCARE | 0.4 | Healthcare and medical |
| EDUCATION | 0.2 | Education resources |
| TECHNOLOGY | 1.2 | Electronics and tech |
| FASHION | 1.0 | Clothing and accessories |
| HOME | 0.9 | Home improvement, furniture |
| GREEN | 0.1 | **Eco-friendly purchases (lowest)** |
| OTHER | 0.5 | Miscellaneous |

## Carbon Calculation Formula

```
Carbon Footprint (kg CO₂) = Transaction Amount ($) × Category Emission Factor
```

**Example:**
- Transaction: $100 at a gas station (TRANSPORT category)
- Emission Factor: 2.1 kg CO₂/$
- **Carbon Footprint: 210 kg CO₂**

## Eco Score Calculation

The Eco Score is calculated based on monthly carbon budget usage:

| Budget Usage | Eco Score | Status |
|--------------|-----------|--------|
| ≤ 50% | 100 | Excellent |
| 51-75% | 75 | Good |
| 76-100% | 50 | Fair |
| 101-125% | 25 | Poor |
| > 125% | 0 | Critical |

## Error Handling

GraphQL errors are returned in the standard format:

```json
{
  "errors": [
    {
      "message": "User not found",
      "path": ["getCurrentUser"],
      "extensions": {
        "classification": "NOT_FOUND"
      }
    }
  ]
}
```

## Testing with cURL

### Register User

```bash
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { register(input: { email: \"test@example.com\", password: \"password123\", firstName: \"Test\", lastName: \"User\" }) { token user { id email } } }"
  }'
```

### Login

```bash
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { login(input: { email: \"test@example.com\", password: \"password123\" }) { token user { id email } } }"
  }'
```

### Create Transaction (with JWT)

```bash
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "query": "mutation { createTransaction(input: { amount: 50.0, category: \"FOOD\", merchant: \"Store\" }) { id carbonFootprint } }"
  }'
```

## GraphiQL Playground

For interactive API testing, visit:

**http://localhost:8080/graphiql**

The GraphiQL interface provides:
- Auto-completion
- Schema documentation
- Query history
- Variable support

## Best Practices

1. **Always use HTTPS in production**
2. **Store JWT tokens securely** (use secure storage on mobile)
3. **Refresh tokens before expiry** (24-hour default)
4. **Validate input on client-side** before mutations
5. **Handle errors gracefully** with user-friendly messages
6. **Use query batching** for multiple related queries
7. **Implement retry logic** for network failures

## Rate Limiting

Currently no rate limiting is implemented. For production:
- Implement rate limiting per user/IP
- Add query complexity analysis
- Set maximum query depth
- Monitor for abuse patterns
