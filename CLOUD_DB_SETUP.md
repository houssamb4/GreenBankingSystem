# Cloud Database Setup - Instructions

## Current Situation

You registered a new user account, but that user has:
- **User ID**: `684fc6b0-9d66-4941-bfef-d8cae1d5a493`
- **No transactions** in the database
- **No carbon stats** calculated

The backend returns "User not found" because your registered user exists but the `getCurrentUser` query might be failing, OR there's a mismatch between the stored user ID and what exists in the database.

## Solution Options

### Option 1: Add Sample Data to YOUR User (Recommended)

Create transactions for your existing user via the app:

1. **Stay signed in** to your current account
2. **Click "Create" button** in the dashboard
3. **Add 5-10 test transactions** with different categories:
   - FOOD, TRANSPORT, SHOPPING, ENERGY, etc.
4. **Refresh** the dashboard

The backend will automatically:
- Calculate carbon footprints
- Generate carbon stats
- Create category breakdowns

### Option 2: Use GraphiQL to Add Transactions Bulk

1. **Get your JWT token**:
   - Open browser DevTools (F12)
   - Go to Application/Storage → Local Storage or Session Storage
   - Find your auth token

2. **Open GraphiQL**: http://localhost:8081/graphiql

3. **Set Authorization header**:
   ```
   {
     "Authorization": "Bearer YOUR_TOKEN_HERE"
   }
   ```

4. **Run this mutation multiple times** (change amounts/merchants):
   ```graphql
   mutation {
     createTransaction(input: {
       amount: 45.99
       category: "FOOD"
       merchant: "Whole Foods Market"
       description: "Weekly groceries"
     }) {
       id
       amount
       carbonFootprint
     }
   }
   ```

### Option 3: Use DBeaver or Database Tool

If you have database access tools:

1. **Connect to**:
   - Host: `green-banking-system-m59385781-3b93.h.aivencloud.com`
   - Port: `17345`
   - Database: `green-banking-system`
   - User: `avnadmin`
   - Password: `AVNS_Bwdt22rR8xrdUdwT1L2`
   - SSL: Required

2. **Run this SQL** (replace USER_ID with yours: `684fc6b0-9d66-4941-bfef-d8cae1d5a493`):

```sql
-- Add sample transactions for your user
INSERT INTO transactions (id, user_id, amount, currency, category, merchant, description, carbon_footprint, transaction_date, created_at, updated_at)
VALUES 
    (gen_random_uuid(), '684fc6b0-9d66-4941-bfef-d8cae1d5a493'::uuid, 45.99, 'USD', 'FOOD', 'Whole Foods Market', 'Weekly groceries', 22.995, CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '684fc6b0-9d66-4941-bfef-d8cae1d5a493'::uuid, 15.50, 'USD', 'TRANSPORT', 'Uber', 'Ride to office', 32.55, CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '684fc6b0-9d66-4941-bfef-d8cae1d5a493'::uuid, 89.99, 'USD', 'SHOPPING', 'Amazon', 'Office supplies', 71.992, CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '684fc6b0-9d66-4941-bfef-d8cae1d5a493'::uuid, 125.00, 'USD', 'ENERGY', 'Electric Company', 'Monthly electricity bill', 212.50, CURRENT_TIMESTAMP - INTERVAL '7 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), '684fc6b0-9d66-4941-bfef-d8cae1d5a493'::uuid, 32.00, 'USD', 'ENTERTAINMENT', 'Netflix', 'Subscription renewal', 19.20, CURRENT_TIMESTAMP - INTERVAL '10 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
```

## Why "User Not Found" Error?

The backend query `getCurrentUser` is failing. Let me check the backend code...

The issue might be:
1. **JWT token doesn't contain user ID** properly
2. **Security context not extracting user** correctly  
3. **User ID mismatch** between token and database

## Quick Test

Let's test the transaction creation through the UI first since you're logged in:

1. **Click "Create" button** in dashboard
2. **Fill out form**:
   - Amount: 50.00
   - Merchant: Test Store
   - Category: FOOD
3. **Click Create**

Watch the console for:
- `DEBUG: Creating transaction:...`
- Success or error message

If this works, the user exists and we just need to create more data!
