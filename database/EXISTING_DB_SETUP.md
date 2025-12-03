# Setting Up with Your Existing PostgreSQL Database

Since you already have a PostgreSQL database with the schema created, follow these steps:

## 1. Add Missing Columns

Your database schema is mostly complete, but needs a few additions to match the Spring Boot entities:

```bash
# Connect to your database
psql -h localhost -U postgres -d greenbankdb

# Run the migration script
\i /path/to/GreenBankingSystem-main/database/add_missing_columns.sql

# Or copy and paste the SQL commands from add_missing_columns.sql
```

**What this does:**
- Adds `created_at` and `updated_at` columns to `carbon_factors` table
- Adds the remaining 9 carbon factor categories (you only have 5)
- Total: 14 categories (FOOD, TRANSPORT, SHOPPING, ENERGY, SERVICES, ENTERTAINMENT, TRAVEL, HEALTHCARE, EDUCATION, TECHNOLOGY, FASHION, HOME, GREEN, OTHER)

## 2. Verify Carbon Factors

```sql
SELECT category, emission_factor, description
FROM carbon_factors
ORDER BY emission_factor DESC;
```

You should see:

| Category | Emission Factor | Description |
|----------|----------------|-------------|
| TRAVEL | 3.5 | Air travel, hotels |
| TRANSPORT | 2.1 | Transportation services |
| ENERGY | 1.7 | Energy bills and utilities |
| TECHNOLOGY | 1.2 | Electronics and tech |
| FASHION | 1.0 | Clothing and accessories |
| HOME | 0.9 | Home improvement |
| SHOPPING | 0.8 | General shopping |
| ENTERTAINMENT | 0.6 | Movies, dining out |
| FOOD | 0.5 | General food purchases |
| HEALTHCARE | 0.4 | Medical expenses |
| SERVICES | 0.3 | General services |
| EDUCATION | 0.2 | Learning resources |
| GREEN | 0.1 | Eco-friendly products |
| OTHER | 0.5 | Miscellaneous |

## 3. Backend Configuration

The `application.properties` has been configured to work with your existing database:

```properties
# Database connection
spring.datasource.url=jdbc:postgresql://localhost:5432/greenbankdb
spring.datasource.username=postgres
spring.datasource.password=postgres

# Don't let Hibernate modify the schema (it's already created)
spring.jpa.hibernate.ddl-auto=none

# Don't run data.sql (data already exists)
spring.sql.init.mode=never
```

## 4. Update Database Password (if needed)

If your PostgreSQL password is different from `postgres`, update it in:

```bash
# Edit the file
nano backend/src/main/resources/application.properties

# Change this line:
spring.datasource.password=YOUR_ACTUAL_PASSWORD
```

## 5. Test Connection

```bash
# Test database connection
psql -h localhost -U postgres -d greenbankdb -c "SELECT COUNT(*) FROM carbon_factors;"
```

Should return: `14` (if you ran the migration script)

## 6. Start the Backend

```bash
cd backend
mvn clean install -DskipTests
mvn spring-boot:run
```

**Expected output:**
```
Started CoreApplication in X.XXX seconds
GraphiQL: http://localhost:8080/graphiql
```

## 7. Test with GraphiQL

Open http://localhost:8080/graphiql and run:

```graphql
mutation {
  register(input: {
    email: "test@example.com"
    password: "password123"
    firstName: "John"
    lastName: "Doe"
  }) {
    token
    user {
      id
      email
      ecoScore
    }
  }
}
```

## Troubleshooting

### Error: "column does not exist"

**Problem:** Missing `created_at` or `updated_at` columns

**Solution:** Run the `add_missing_columns.sql` script

### Error: "relation does not exist"

**Problem:** Tables not created

**Solution:** Your schema should already be created. Verify with:
```sql
\dt  -- List all tables
```

### Error: "authentication failed"

**Problem:** Wrong password in application.properties

**Solution:** Update the password:
```properties
spring.datasource.password=YOUR_ACTUAL_PASSWORD
```

### Error: "could not execute query"

**Problem:** Data type mismatch

**Solution:** Make sure your schema matches:
- `id` columns are UUID
- `amount` and `carbon_footprint` are DECIMAL
- `eco_score` is INTEGER
- Timestamps are TIMESTAMP type

## Database Schema Summary

Your existing schema is perfect! Just needs:
1. ✅ Add `created_at`, `updated_at` to `carbon_factors`
2. ✅ Add 9 more carbon factor categories
3. ✅ Configure Spring Boot to use existing schema

After running the migration script, you're ready to go! 🚀
