# 🌱 Green Banking System - Backend

A Spring Boot 3.4.0 backend application with GraphQL API that automatically calculates carbon footprints for financial transactions, helping users understand and reduce their environmental impact.

![Java](https://img.shields.io/badge/Java-21-orange) ![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.4.0-brightgreen) ![GraphQL](https://img.shields.io/badge/GraphQL-22.0-E10098) ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue)

## 🎯 Overview

The backend is built with:
- **Spring Boot 3.4.0** - Latest Spring framework with Java 21 support
- **GraphQL** - Modern API with efficient querying and real-time capabilities
- **Spring Data JPA** - Database abstraction and ORM
- **Spring Security** - JWT-based authentication
- **PostgreSQL** - Robust relational database

## 📁 Project Structure

```
backend/
├── src/
│   ├── main/
│   │   ├── java/com/ecobank/core/
│   │   │   ├── config/          # Application configuration
│   │   │   ├── dto/              # Data Transfer Objects
│   │   │   ├── entity/           # JPA entities (User, Transaction, etc.)
│   │   │   ├── exception/        # Custom exceptions
│   │   │   ├── repository/       # Data access layer
│   │   │   ├── resolver/         # GraphQL resolvers (queries/mutations)
│   │   │   ├── security/         # JWT & authentication logic
│   │   │   ├── service/          # Business logic
│   │   │   └── CoreApplication.java
│   │   └── resources/
│   │       ├── application.properties
│   │       ├── data.sql          # Sample data
│   │       └── graphql/          # GraphQL schemas
│   └── test/                     # Unit and integration tests
├── pom.xml                       # Maven dependencies
├── mvnw                          # Maven wrapper (Linux/Mac)
├── mvnw.cmd                      # Maven wrapper (Windows)
└── GRAPHQL_API.md               # Complete API documentation
```

## ✨ Key Features

### 🌍 Automatic Carbon Calculation
- Every transaction automatically calculates its carbon footprint
- Based on 14 predefined categories with specific CO₂ emission factors
- Real-time carbon tracking and budgeting

### 🔒 Security
- JWT-based authentication
- Secure password hashing with BCrypt
- Token refresh mechanism
- Protected GraphQL endpoints

### 📊 Transaction Management
- Create, read, update, delete transactions
- Category-based organization
- Merchant tracking
- Transaction history with pagination

### 📈 Analytics & Insights
- User Eco Score calculation (0-100)
- Total carbon saved tracking
- Monthly carbon budgets
- Category-based analytics
- Carbon trends over time

## 🚀 Getting Started

### Prerequisites

- **Java 21** (OpenJDK or Oracle JDK)
- **Maven 3.9+**
- **PostgreSQL 15+** (or use Docker Compose)

### Installation

#### 1. Install Java 21

**Windows (with Chocolatey):**
```powershell
choco install openjdk21
```

**Linux (Fedora/RHEL):**
```bash
sudo dnf install java-21-openjdk-devel
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt install openjdk-21-jdk
```

**macOS:**
```bash
brew install openjdk@21
```

Verify installation:
```bash
java -version
# Should show: openjdk version "21.0.x"
```

#### 2. Install Maven

**Windows (with Chocolatey):**
```powershell
choco install maven
```

**Linux:**
```bash
# Fedora/RHEL
sudo dnf install maven

# Ubuntu/Debian
sudo apt install maven
```

**macOS:**
```bash
brew install maven
```

Verify installation:
```bash
mvn -version
```

### Database Setup

#### Option 1: Docker (Recommended)

```bash
# From project root
cd ..
docker-compose up -d postgres

# Wait for initialization
docker exec greenbank_postgres pg_isready -U postgres
```

This automatically:
- Creates the database schema
- Loads all 14 carbon categories
- Adds demo user and sample transactions
- Sets up pgAdmin on port 5050

#### Option 2: Local PostgreSQL

If you have PostgreSQL installed:

```bash
# Create database and run setup
createdb -U postgres greenbankdb
psql -U postgres -d greenbankdb -f ../database/setup_database.sql

# Verify setup
psql -U postgres -d greenbankdb -c "SELECT COUNT(*) FROM carbon_factors;"
# Should return: 14
```

See [Database README](../database/README.md) for detailed setup instructions.

### Running the Application

#### Development Mode

```bash
cd backend

# Clean install dependencies
mvn clean install -DskipTests

# Run the application
mvn spring-boot:run
```

The server will start on **http://localhost:8081**

#### Production Build

```bash
# Build JAR file
mvn clean package -DskipTests

# Run the JAR
java -jar target/core-0.0.1-SNAPSHOT.jar
```

### Testing the API

#### GraphiQL Interface (Recommended)

Open your browser to:
```
http://localhost:8081/graphiql
```

This provides:
- Interactive GraphQL playground
- Auto-completion
- Documentation explorer
- Schema introspection

#### Using cURL

```bash
# Register a new user
curl -X POST http://localhost:8081/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { register(input: { email: \"test@example.com\", password: \"password123\", firstName: \"John\", lastName: \"Doe\" }) { token user { id email } } }"
  }'

# Login
curl -X POST http://localhost:8081/graphql \
  -H "Content-Type: application/json" \
  -d '{
    "query": "mutation { login(input: { email: \"test@example.com\", password: \"password123\" }) { token } }"
  }'
```

## 📚 API Documentation

### Endpoints

- **GraphQL API**: `http://localhost:8081/graphql`
- **GraphiQL UI**: `http://localhost:8081/graphiql`

### Quick Examples

#### 1. Register & Login

```graphql
mutation Register {
  register(input: {
    email: "user@example.com"
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

#### 2. Create Transaction (with automatic carbon calculation)

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
    carbonFootprint
    transactionDate
  }
}
```

#### 3. Get User Profile with Analytics

```graphql
query GetProfile {
  me {
    id
    firstName
    lastName
    ecoScore
    totalCarbonSaved
    monthlyCarbonBudget
    transactions {
      id
      amount
      carbonFootprint
      category
    }
  }
}
```

### Carbon Categories

| Category | CO₂ per $ |
|----------|-----------|
| ECO_FRIENDLY | 0.1 kg |
| UTILITIES | 0.5 kg |
| GROCERIES | 0.8 kg |
| FOOD | 1.0 kg |
| ENTERTAINMENT | 1.2 kg |
| SHOPPING | 1.5 kg |
| TRANSPORT | 2.0 kg |
| FASHION | 2.5 kg |
| ELECTRONICS | 3.0 kg |
| TRAVEL | 3.5 kg |

For complete API documentation, see [GRAPHQL_API.md](GRAPHQL_API.md)

## 🔧 Configuration

### Application Properties

Edit `src/main/resources/application.properties`:

```properties
# Server Configuration
server.port=8081

# Database Configuration
spring.datasource.url=jdbc:postgresql://localhost:5432/greenbankdb
spring.datasource.username=postgres
spring.datasource.password=postgres123

# JWT Configuration
jwt.secret=your-secret-key-here
jwt.expiration=86400000  # 24 hours

# GraphQL Configuration
spring.graphql.graphiql.enabled=true
```

### Environment Variables

You can override properties with environment variables:

```bash
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=greenbankdb
export DB_USER=postgres
export DB_PASSWORD=postgres123
export JWT_SECRET=your-secret-key
```

## 🧪 Testing

### Run All Tests

```bash
mvn test
```

### Run Specific Test

```bash
mvn test -Dtest=TransactionServiceTest
```

### Skip Tests

```bash
mvn clean install -DskipTests
```

## 🐳 Docker Support

### Build Docker Image

```bash
# From backend directory
docker build -t greenbanking-backend:latest .
```

### Run with Docker Compose

```bash
# From project root
docker-compose up -d
```

This starts:
- PostgreSQL on port 5432
- pgAdmin on port 5050

## 📊 Database Schema

### Main Tables

- **users** - User accounts with authentication info
- **transactions** - Financial transactions with carbon data
- **carbon_categories** - Transaction category definitions with emission factors

### Key Relationships

```
users (1) ──────< (∞) transactions
          one-to-many
```

## 🔍 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Change port in application.properties
server.port=8082
```

#### Database Connection Failure
```bash
# Check if PostgreSQL is running
docker ps
# or
sudo systemctl status postgresql
```

#### Java Version Mismatch
```bash
# Check Java version
java -version

# Set JAVA_HOME (Linux/Mac)
export JAVA_HOME=/path/to/java-21

# Set JAVA_HOME (Windows)
set JAVA_HOME=C:\Program Files\Java\jdk-21
```

#### Maven Build Failure
```bash
# Clean Maven cache
mvn clean

# Update dependencies
mvn dependency:purge-local-repository
```