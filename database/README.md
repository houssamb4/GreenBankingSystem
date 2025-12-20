# 🗄️ Green Banking System - Database Setup

Complete guide for setting up the PostgreSQL database for the Green Banking System.

## 📋 Overview

The database contains:
- **3 main tables**: users, transactions, carbon_factors
- **14 carbon categories**: From eco-friendly (0.1 kg CO₂/$) to travel (3.5 kg CO₂/$)
- **Performance indexes**: Optimized for common queries
- **Sample data**: Demo user and transactions for testing

## 🚀 Quick Setup

### Option 1: Docker (Recommended)

The easiest way to get started:

```bash
# From project root
docker-compose up -d postgres

# Wait for PostgreSQL to start (takes ~10 seconds)
docker exec greenbank_postgres pg_isready -U postgres
```

This automatically:
- ✅ Creates the database `greenbankdb`
- ✅ Runs `setup_database.sql`
- ✅ Sets up demo user and sample data
- ✅ Configures pgAdmin on port 5050

**Access the Database:**
- Host: `localhost`
- Port: `5432`
- Database: `greenbankdb`
- User: `postgres`
- Password: `postgres123`

**Access pgAdmin:**
- URL: http://localhost:5050
- Email: `admin@greenbank.com`
- Password: `admin`

### Option 2: Local PostgreSQL

If you have PostgreSQL installed locally:

```bash
# 1. Create database
createdb -U postgres greenbankdb

# 2. Run setup script
psql -U postgres -d greenbankdb -f setup_database.sql

# 3. Verify installation
psql -U postgres -d greenbankdb -c "SELECT COUNT(*) FROM carbon_factors;"
# Should return: 14
```

### Option 3: Cloud Database (Aiven, AWS RDS, etc.)

```bash
# Connect to your cloud database
psql -h your-cloud-host -U your-user -d your-database

# Run the setup script
\i setup_database.sql

# Or use command line
psql -h your-cloud-host -U your-user -d your-database -f setup_database.sql
```

## 📊 Database Schema

### Tables Overview

```sql
users (Main user accounts)
├── id (UUID, Primary Key)
├── email (Unique, Not Null)
├── password_hash (BCrypt)
├── first_name, last_name
├── eco_score (0-100)
├── total_carbon_saved
├── monthly_carbon_budget
└── timestamps

carbon_factors (Emission factors for categories)
├── id (UUID, Primary Key)
├── category (Unique)
├── emission_factor (kg CO₂ per $)
├── description
└── timestamps

transactions (User transactions with carbon data)
├── id (UUID, Primary Key)
├── user_id (Foreign Key → users)
├── amount, currency
├── category, merchant
├── carbon_footprint (auto-calculated)
├── transaction_date
└── timestamps
```

### Carbon Categories

| Category | CO₂/$ | Description |
|----------|-------|-------------|
| GREEN | 0.1 | Eco-friendly products (lowest) |
| EDUCATION | 0.2 | Learning resources |
| SERVICES | 0.3 | Subscriptions |
| HEALTHCARE | 0.4 | Medical expenses |
| FOOD | 0.5 | Groceries |
| ENTERTAINMENT | 0.6 | Dining, events |
| SHOPPING | 0.8 | Retail |
| HOME | 0.9 | Furniture |
| FASHION | 1.0 | Clothing |
| TECHNOLOGY | 1.2 | Electronics |
| ENERGY | 1.7 | Utilities |
| TRANSPORT | 2.1 | Fuel, rides |
| TRAVEL | 3.5 | Flights (highest) |
| OTHER | 0.5 | Miscellaneous |

## 🧪 Testing the Database

### Verify Setup

```sql
-- Check carbon factors
SELECT category, emission_factor FROM carbon_factors ORDER BY emission_factor DESC;

-- Check demo user
SELECT email, first_name, eco_score FROM users WHERE email = 'demo@greenpay.com';

-- Check transactions
SELECT COUNT(*), SUM(carbon_footprint) FROM transactions;
```

### Demo User Credentials

- **Email**: `demo@greenpay.com`
- **Password**: `password123`
- **Eco Score**: 85
- **Sample Transactions**: 18 transactions over 3 months

## 🔧 Configuration

### Update Backend Connection

Edit `backend/src/main/resources/application.properties`:

```properties
# Database Connection
spring.datasource.url=jdbc:postgresql://localhost:5432/greenbankdb
spring.datasource.username=postgres
spring.datasource.password=postgres123

# Let JPA use existing schema
spring.jpa.hibernate.ddl-auto=update

# Don't run data.sql (already loaded)
spring.sql.init.mode=never
```

### For Cloud Database

```properties
spring.datasource.url=jdbc:postgresql://your-host:5432/your-db
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASSWORD}
spring.datasource.ssl-mode=require
```

## 🐳 Docker Commands

```bash
# Start PostgreSQL
docker-compose up -d postgres

# View logs
docker-compose logs -f postgres

# Connect to database
docker exec -it greenbank_postgres psql -U postgres -d greenbankdb

# Stop PostgreSQL
docker-compose down

# Remove all data (fresh start)
docker-compose down -v
```

## 🔍 Useful Queries

### Check User Carbon Stats

```sql
SELECT 
    u.email,
    u.eco_score,
    COUNT(t.id) AS transaction_count,
    SUM(t.amount) AS total_spent,
    SUM(t.carbon_footprint) AS total_carbon_kg
FROM users u
LEFT JOIN transactions t ON u.id = t.user_id
WHERE u.email = 'demo@greenpay.com'
GROUP BY u.id, u.email, u.eco_score;
```

### Category Breakdown

```sql
SELECT 
    category,
    COUNT(*) AS count,
    SUM(amount) AS total_amount,
    SUM(carbon_footprint) AS total_carbon
FROM transactions
GROUP BY category
ORDER BY total_carbon DESC;
```

### Monthly Carbon Trend

```sql
SELECT 
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS transactions,
    SUM(carbon_footprint) AS total_carbon
FROM transactions
WHERE user_id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'
GROUP BY month
ORDER BY month DESC;
```

## 🔒 Security Best Practices

### Production Configuration

```sql
-- Create dedicated user (not postgres)
CREATE USER greenbank_app WITH PASSWORD 'your-secure-password';
GRANT CONNECT ON DATABASE greenbankdb TO greenbank_app;
GRANT USAGE ON SCHEMA public TO greenbank_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO greenbank_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO greenbank_app;
```

### Environment Variables

```bash
# .env file (never commit!)
DB_HOST=localhost
DB_PORT=5432
DB_NAME=greenbankdb
DB_USER=greenbank_app
DB_PASSWORD=your-secure-password
```

## 🔄 Maintenance

### Backup Database

```bash
# Full backup
docker exec greenbank_postgres pg_dump -U postgres greenbankdb > backup_$(date +%Y%m%d).sql

# Restore from backup
docker exec -i greenbank_postgres psql -U postgres -d greenbankdb < backup_20231220.sql
```

### Reset Database

```bash
# Drop and recreate (WARNING: Deletes all data!)
docker exec -it greenbank_postgres psql -U postgres -c "DROP DATABASE IF EXISTS greenbankdb;"
docker exec -it greenbank_postgres psql -U postgres -c "CREATE DATABASE greenbankdb;"
docker exec -i greenbank_postgres psql -U postgres -d greenbankdb < setup_database.sql
```

### Update Carbon Factors

```sql
-- Modify emission factors
UPDATE carbon_factors 
SET emission_factor = 2.5, updated_at = CURRENT_TIMESTAMP 
WHERE category = 'TRANSPORT';

-- Add new category
INSERT INTO carbon_factors (category, emission_factor, description)
VALUES ('CUSTOM', 1.5, 'Custom category');
```

## 🐛 Troubleshooting

### Cannot connect to database

```bash
# Check if PostgreSQL is running
docker ps | grep postgres

# Check logs
docker logs greenbank_postgres

# Restart container
docker restart greenbank_postgres
```

### Port already in use

```bash
# Check what's using port 5432
# Windows
netstat -ano | findstr :5432

# Linux/Mac
lsof -i :5432

# Change port in docker-compose.yml
ports:
  - "5433:5432"  # Use 5433 instead
```

### Authentication failed

```sql
-- Reset postgres password (inside container)
docker exec -it greenbank_postgres psql -U postgres
ALTER USER postgres WITH PASSWORD 'new_password';
```

### Schema mismatch

```bash
# Check what Spring Boot expects vs what exists
# View backend entities:
ls backend/src/main/java/com/ecobank/core/entity/

# Compare with database
docker exec -it greenbank_postgres psql -U postgres -d greenbankdb
\dt  -- List tables
\d users  -- Describe users table
```

## 📚 Additional Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Backend README](../backend/README.md) - Backend setup
- [Main README](../README.md) - Project overview

## 🔗 Related Files

- `setup_database.sql` - **Single comprehensive setup file** (USE THIS)
- `../docker-compose.yml` - Docker configuration

## ✅ Next Steps

After database setup:

1. **Start Backend**:
   ```bash
   cd ../backend
   mvn spring-boot:run
   ```

2. **Test API**:
   - Open http://localhost:8081/graphiql
   - Login with `demo@greenpay.com` / `password123`

3. **Start Frontend**:
   ```bash
   cd ../frontend
   flutter run
   ```

---

**Need help?** Check the [main README](../README.md) or [backend documentation](../backend/README.md)
