# 🌱 Green Banking System

A comprehensive digital banking platform that **automatically calculates the carbon footprint of every transaction**, helping users make eco-conscious financial decisions through modern technology and beautiful design.

![Java](https://img.shields.io/badge/Java-21-orange) ![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.4.0-brightgreen) ![Flutter](https://img.shields.io/badge/Flutter-3.24.4-blue) ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue) ![GraphQL](https://img.shields.io/badge/GraphQL-22.0-E10098)

## 📖 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#️-architecture)
- [Tech Stack](#-tech-stack)
- [Platform Support](#-platform-support)
- [Quick Start](#-quick-start)
- [Documentation](#-documentation)
- [Project Structure](#-project-structure)
- [Development](#-development)
- [Deployment](#-deployment)
- [Contributing](#-contributing)
- [License](#-license)

## 🎯 Overview

Green Banking System is a full-stack application that bridges the gap between financial transactions and environmental awareness. By automatically calculating the carbon footprint of every transaction, users can:

- 🌍 **Understand their environmental impact** through real-time carbon tracking
- 📊 **Make informed decisions** with detailed analytics and insights
- 🎯 **Set and achieve** carbon reduction goals
- 💚 **Contribute to sustainability** by choosing eco-friendly options

## ✨ Features

### 🌍 Environmental Impact Tracking
- ✅ **Automatic Carbon Calculation** - Every transaction gets a carbon footprint based on 14 predefined categories
- ✅ **Smart Categories** - From eco-friendly (0.1 kg CO₂/$) to high-impact travel (3.5 kg CO₂/$)
- ✅ **Real-time Monitoring** - Live carbon analytics and budget tracking
- ✅ **Eco Score System** - Personal environmental performance rating (0-100)
- ✅ **Carbon Trends** - Historical analysis and future projections

### 💻 Technical Features
- ✅ **GraphQL API** - Modern, efficient API with GraphiQL interactive playground
- ✅ **JWT Authentication** - Secure user authentication with token refresh
- ✅ **Cross-platform Mobile App** - Flutter app for iOS, Android, Web, and Desktop
- ✅ **Responsive Design** - Beautiful UI that works on all screen sizes
- ✅ **Multi-language Support** - Internationalization with 8+ languages
- ✅ **Dark/Light Themes** - User preference themes

### 📊 Business Features
- ✅ **Transaction Management** - Complete CRUD operations for transactions
- ✅ **Category Organization** - Intelligent transaction categorization
- ✅ **Merchant Tracking** - Track spending by merchant
- ✅ **Budget Management** - Set and monitor monthly carbon budgets
- ✅ **Analytics Dashboard** - Visual insights with charts and graphs


## 🏗️ Architecture

The system follows a modern three-tier architecture with clear separation of concerns:

<img width="3346" height="5528" alt="Untitled diagram-2025-12-20-171142" src="https://github.com/user-attachments/assets/2488ad4d-c3a1-451b-b673-2be12032a6e2" />

### Component Communication

1. **Frontend → Backend**: GraphQL queries/mutations via HTTP
2. **Backend → Database**: JPA/Hibernate ORM
3. **Authentication**: JWT tokens in Authorization headers
4. **Carbon Calculation**: Automatic on transaction creation

## 🛠️ Tech Stack

### Backend
| Technology | Version | Purpose |
|------------|---------|---------|
| **Java** | 21 | Programming language |
| **Spring Boot** | 3.4.0 | Application framework |
| **Spring Security** | 6.x | Authentication & authorization |
| **Spring Data JPA** | 3.x | Data persistence |
| **GraphQL Java** | 22.0 | GraphQL implementation |
| **PostgreSQL** | 15 | Relational database |
| **JWT** | - | Token-based authentication |
| **Lombok** | 1.18.36 | Boilerplate reduction |
| **Maven** | 3.9+ | Build tool |

### Frontend
| Technology | Version | Purpose |
|------------|---------|---------|
| **Flutter** | 3.24.4 | UI framework |
| **Dart** | 3.4.1 | Programming language |
| **go_router** | 14.0.0 | Navigation |
| **Provider** | 6.1.1 | State management |
| **Syncfusion Charts** | 32.1.19 | Data visualization |
| **GraphQL Flutter** | - | API client |

### DevOps & Tools
| Tool | Purpose |
|------|---------|
| **Docker** | Containerization |
| **Docker Compose** | Multi-container orchestration |
| **pgAdmin** | Database management |
| **Git** | Version control |
| **Vercel** | Frontend deployment |
| **Aiven Cloud** | Database hosting |

## 💻 Platform Support

| Platform | Backend | Mobile App | Status |
|----------|---------|------------|--------|
| 🐧 **Linux** | ✅ Fully Supported | ✅ Android | Recommended |
| 🍎 **macOS** | ✅ Fully Supported | ✅ iOS/Android | Recommended |
| 🪟 **Windows** | ✅ Fully Supported | ✅ Android/Desktop | Supported |

## 📋 Prerequisites

### Required
- **Java 21** (OpenJDK recommended) - [Installation guide below](#1-install-java-21)
- **Maven 3.9+** - [Installation guide below](#2-install-maven-build-tool)
- **Aiven Cloud PostgreSQL** (already configured) or local PostgreSQL
- **Flutter SDK 3.0+** (for mobile app) - [Installation guide below](#5-install-flutter)

### Optional
- **Docker & Docker Compose** (for local PostgreSQL)
- **pgAdmin 4** (database management)
- **Chocolatey** (Windows package manager - makes installation easier)

## 🚀 Quick Start

### Option 1: Docker Setup (Recommended)

The fastest way to get started:

```bash
# 1. Start PostgreSQL with Docker
docker-compose up -d postgres

# 2. Wait for database initialization (~10 seconds)
docker exec greenbank_postgres pg_isready -U postgres

# 3. Start the backend
cd backend
mvn clean install -DskipTests
mvn spring-boot:run

# 4. Start the Flutter app
cd ../frontend
flutter pub get
flutter run
```

**Database automatically includes:**
- ✅ Complete schema (users, transactions, carbon_factors)
- ✅ 14 carbon categories with emission factors
- ✅ Demo user (email: demo@greenpay.com, password: password123)
- ✅ 18 sample transactions

**Access Points:**
- Backend API: http://localhost:8081
- GraphiQL: http://localhost:8081/graphiql
- pgAdmin: http://localhost:5050

### Option 2: Local PostgreSQL

If you have PostgreSQL installed:

```bash
# 1. Create database and run setup
createdb -U postgres greenbankdb
psql -U postgres -d greenbankdb -f database/setup_database.sql

# 2. Start backend
cd backend
mvn spring-boot:run

# 3. Start frontend
cd ../frontend
flutter run
```

### Option 3: Manual Full Setup

See detailed installation guides in:
- [Backend README](backend/README.md) - Complete backend setup
- [Frontend README](frontend/README_GREENBANKING.md) - Complete frontend setup

## 📚 Documentation

Comprehensive documentation is available for each component:

### Core Documentation
- **[Backend README](backend/README.md)** - Spring Boot API setup, configuration, and development
- **[Frontend README](frontend/README_GREENBANKING.md)** - Flutter app setup, building, and deployment
- **[GraphQL API](backend/GRAPHQL_API.md)** - Complete API reference with examples

### Database Documentation
- **[Database Setup](database/README.md)** - Complete PostgreSQL setup guide
- **[Cloud Database Setup](CLOUD_DB_SETUP.md)** - Aiven Cloud configuration (if applicable)
- **[Debug Fix Summary](DEBUG_FIX_SUMMARY.md)** - Common issues and solutions

### Additional Guides
- **[Debug Fix Summary](DEBUG_FIX_SUMMARY.md)** - Common issues and solutions

## 📂 Project Structure

```
GreenBankingSystem/
├── 📱 frontend/                   # Flutter mobile/web application
│   ├── lib/
│   │   ├── main.dart             # App entry point
│   │   ├── pages/                # Screen widgets
│   │   ├── components/           # Reusable UI components
│   │   ├── core/                 # Core functionality
│   │   └── widgets/              # Custom widgets
│   ├── assets/                   # Images, icons, JSON
│   ├── android/                  # Android config
│   ├── ios/                      # iOS config
│   ├── web/                      # Web config
│   ├── pubspec.yaml              # Flutter dependencies
│   └── README_GREENBANKING.md    # Frontend documentation
│
├── 🖥️ backend/                    # Spring Boot API server
│   ├── src/
│   │   ├── main/java/com/ecobank/core/
│   │   │   ├── config/           # Spring configuration
│   │   │   ├── entity/           # JPA entities
│   │   │   ├── repository/       # Data access layer
│   │   │   ├── service/          # Business logic
│   │   │   ├── resolver/         # GraphQL resolvers
│   │   │   ├── security/         # JWT authentication
│   │   │   └── dto/              # Data transfer objects
│   │   ├── resources/
│   │   │   ├── application.properties
│   │   │   └── graphql/          # GraphQL schemas
│   ├── pom.xml                   # Maven dependencies
│   ├── README.md                 # Backend documentation
│   └── GRAPHQL_API.md           # API reference
│
├── 🗄️ database/                   # Database scripts and setup
│   ├── setup_database.sql        # Complete database setup (USE THIS)
│   └── README.md                 # Database documentation
│
├── 🐳 docker-compose.yml          # Docker container setup
├── 📖 README.md                   # This file
└── 📋 *.md                        # Additional documentation
```

## 💡 Carbon Calculation System

### How It Works

Every transaction is automatically assigned a carbon footprint based on its category:

```
Transaction → Category → Carbon Factor → CO₂ Emissions
    $100   →   FOOD    →    1.0 kg/$   →   100 kg CO₂
```

### Carbon Categories

| Category | CO₂ per $1 | Example Merchants | Use Case |
|----------|-----------|-------------------|-----------|
| 🌱 **ECO_FRIENDLY** | 0.1 kg | Farmers market, green stores | Sustainable products |
| 💡 **UTILITIES** | 0.5 kg | Electric, water, gas bills | Home services |
| 🛒 **GROCERIES** | 0.8 kg | Supermarkets | Food shopping |
| 🍔 **FOOD** | 1.0 kg | Restaurants, cafes | Dining out |
| 🎮 **ENTERTAINMENT** | 1.2 kg | Movies, games | Recreation |
| 🛍️ **SHOPPING** | 1.5 kg | Retail stores | General shopping |
| 🚗 **TRANSPORT** | 2.0 kg | Gas stations, ride-sharing | Transportation |
| 👕 **FASHION** | 2.5 kg | Clothing stores | Apparel |
| 💻 **ELECTRONICS** | 3.0 kg | Tech stores | Gadgets |
| ✈️ **TRAVEL** | 3.5 kg | Airlines, hotels | Travel services |

### Eco Score Calculation

Your Eco Score (0-100) is calculated based on:
- **Transaction patterns** - Frequency of eco-friendly purchases
- **Carbon budget adherence** - Staying within monthly limits
- **Category choices** - Preference for low-carbon options
- **Trend improvement** - Carbon reduction over time

## 🚀 Getting Started (Quick)
sudo dnf install postgresql-server postgresql-contrib
sudo systemctl start postgresql

# Ubuntu
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
```

**macOS:**
```bash
brew install postgresql@15
brew services start postgresql@15
```

**Windows:**
```powershell
# Download from: https://www.postgresql.org/download/windows/
# Or use Chocolatey
choco install postgresql

# PostgreSQL service starts automatically
```

#### 3. Create Database

```bash
# Login as postgres user
sudo -u postgres psql

# In PostgreSQL shell:
CREATE DATABASE greenbankdb;
CREATE USER postgres WITH PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE greenbankdb TO postgres;
\q
```

#### 4. Configure Backend

Edit `backend/src/main/resources/application.properties` if needed:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/greenbankdb
spring.datasource.username=postgres
spring.datasource.password=postgres
```

#### 4. Run Backend

**Linux/macOS:**
```bash
cd backend
mvn clean install -DskipTests
mvn spring-boot:run
```

**Windows (Command Prompt/PowerShell):**
```powershell
cd backend
mvn clean install -DskipTests
mvn spring-boot:run
```

Backend will start on **http://localhost:8081**

#### 5. Install Flutter

**Linux:**
```bash
# Download Flutter SDK
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.x.x-stable.tar.xz
tar xf flutter_linux_*.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"

flutter doctor
```

**macOS:**
```bash
# Download from: https://docs.flutter.dev/get-started/install/macos
# Or use Homebrew
brew install --cask flutter

flutter doctor
```

**Windows:**
```powershell
# Option 1: Using Chocolatey
choco install flutter

# Option 2: Manual installation
# 1. Download from: https://docs.flutter.dev/get-started/install/windows
# 2. Extract to C:\src\flutter
# 3. Add to PATH: C:\src\flutter\bin

# Verify
flutter doctor

# Install Android Studio for Android development
# Install Xcode for iOS development (macOS only)
```

#### 6. Run Flutter App

**All Platforms:**
```bash
cd frontend
flutter pub get
flutter run

# Select your device:
# [1] Windows (desktop)
# [2] Chrome (web)
# [3] Android emulator
# [4] iOS simulator (macOS only)
```

## 📊 Carbon Emission Factors

The system uses scientifically-based emission factors for 14 categories:

| Category | Factor (kg CO₂/$) | Example |
|----------|-------------------|---------|
| 🌱 GREEN | 0.1 | Eco-friendly products |
| 🎓 EDUCATION | 0.2 | Online courses |
| 🛎️ SERVICES | 0.3 | Subscriptions |
| 🏥 HEALTHCARE | 0.4 | Medical expenses |
| 🍽️ FOOD | 0.5 | Groceries |
| 🎬 ENTERTAINMENT | 0.6 | Movies, dining |
| 🛍️ SHOPPING | 0.8 | Retail purchases |
| 🏠 HOME | 0.9 | Furniture |
| 👔 FASHION | 1.0 | Clothing |
| 💻 TECHNOLOGY | 1.2 | Electronics |
| ⚡ ENERGY | 1.7 | Utilities |
| 🚗 TRANSPORT | 2.1 | Fuel, rideshare |
| ✈️ TRAVEL | **3.5** | Flights (highest) |
| 💳 OTHER | 0.5 | Miscellaneous |

**Formula**: `Carbon (kg CO₂) = Amount ($) × Category Factor`

**Example**: $100 flight = 100 × 3.5 = **350 kg CO₂**

## 📱 Using the System

### 1. Register/Login

```
Email: your@email.com
Password: (minimum 6 characters)
```

### 2. Add a Transaction

- Amount: $50
- Category: FOOD
- Merchant: Whole Foods (optional)
- **Carbon is calculated automatically!**

### 3. View Dashboard

- Monthly carbon usage vs budget
- Eco score (0-100)
- Category breakdown
- Total emissions

### 4. Track Progress

Your eco score is based on budget usage:
- 0-50% = 100 points (Excellent)
- 51-75% = 75 points (Good)
- 76-100% = 50 points (Fair)
- 101-125% = 25 points (Poor)
- >125% = 0 points (Critical)

## 🔌 API Documentation

### GraphQL Endpoint

- **API**: `http://localhost:8081/graphql`
- **Playground**: `http://localhost:8081/graphiql`

### Example Queries

**Create Transaction:**
```graphql
mutation {
  createTransaction(input: {
    amount: 50.0
    category: "FOOD"
    merchant: "Whole Foods"
  }) {
    id
    carbonFootprint  # Automatically calculated!
  }
}
```

**Get Carbon Stats:**
```graphql
query {
  getCarbonStats(userId: "your-user-id") {
    monthlyCarbon
    carbonBudget
    carbonPercentage
    ecoScore
  }
}
```

Full API documentation: [backend/GRAPHQL_API.md](backend/GRAPHQL_API.md)

## 🧪 Testing

### Run Backend Tests

```bash
cd backend
mvn test
```

Tests include:
- Carbon calculation accuracy
- Emission factor lookup
- Category handling
- Edge cases (zero amounts, precision)

### Test Coverage

- ✅ CarbonCalculatorService - 12 test cases
- ✅ Carbon emission factors
- ✅ BigDecimal precision
- ✅ Case-insensitive categories

### 💡 Quick Test Without Frontend

You can test everything using GraphiQL before setting up the mobile app:

1. **Start the backend:**
   ```bash
   cd backend
   mvn spring-boot:run
   ```

2. **Open GraphiQL:** http://localhost:8081/graphiql

3. **Register a user:**
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
         monthlyCarbonBudget
       }
     }
   }
   ```

4. **Copy the token** from the response

5. **Set Authorization Header:**
   - Click "Request Headers" at the bottom of GraphiQL
   - Add: `{"Authorization": "Bearer YOUR_TOKEN_HERE"}`

6. **Create a transaction** (carbon is calculated automatically!):
   ```graphql
   mutation {
     createTransaction(input: {
       amount: 100.0
       category: "TRANSPORT"
       merchant: "Gas Station"
       description: "Weekly fuel"
     }) {
       id
       amount
       category
       carbonFootprint  # 🌱 Automatically calculated: 100 × 2.1 = 210 kg CO₂
       transactionDate
     }
   }
   ```

7. **View your carbon stats:**
   ```graphql
   query {
     getCarbonStats(userId: "YOUR_USER_ID_FROM_STEP_3") {
       totalCarbon
       monthlyCarbon
       carbonBudget
       carbonPercentage
       ecoScore
     }
   }
   ```

8. **See category breakdown:**
   ```graphql
   query {
     getCategoryBreakdown(userId: "YOUR_USER_ID_FROM_STEP_3") {
       category
       totalCarbon
       totalAmount
       transactionCount
       percentage
     }
   }
   ```

**Try different categories to see different carbon footprints:**
- FOOD (0.5) → $100 = 50 kg CO₂
- TRANSPORT (2.1) → $100 = 210 kg CO₂
- TRAVEL (3.5) → $100 = 350 kg CO₂
- GREEN (0.1) → $100 = 10 kg CO₂

## 🗂️ Project Structure

```
GreenBankingSystem-main/
├── backend/                    # Spring Boot Backend
│   ├── src/main/
│   │   ├── java/.../entity/   # JPA Entities (User, Transaction, CarbonFactor)
│   │   ├── java/.../service/  # Business Logic (Carbon calculation)
│   │   ├── java/.../resolver/ # GraphQL Resolvers
│   │   └── resources/
│   │       ├── application.properties
│   │       ├── data.sql       # Carbon factor initialization
│   │       └── graphql/       # GraphQL schema
│   ├── src/test/              # Unit tests
│   └── pom.xml                # Maven dependencies
├── frontend/                   # Flutter Mobile App
│   ├── lib/
│   │   ├── config/            # GraphQL client config
│   │   ├── models/            # Data models
│   │   ├── screens/           # UI screens
│   │   └── services/          # Auth & business logic
│   └── pubspec.yaml           # Flutter dependencies
├── database/
│   ├── init.sql               # Database initialization
│   └── setup.sh               # Setup script
├── docker-compose.yml         # Docker configuration
└── README.md                  # This file
```

## 🐳 Docker Commands

```bash
# Start PostgreSQL
docker-compose up -d postgres

# Start PostgreSQL + pgAdmin
docker-compose up -d

# View logs
docker-compose logs -f postgres

# Stop all services
docker-compose down

# Access pgAdmin
# URL: http://localhost:5050
# Email: admin@greenbank.com
# Password: admin
```

## 🔧 Troubleshooting

### Backend won't compile

**Error**: `java.lang.ExceptionInInitializerError: com.sun.tools.javac.code.TypeTag`

**Solution**: You're using Java 25. Install Java 21:

**Linux:**
```bash
sudo dnf install java-21-openjdk-devel
sudo alternatives --config java  # Select Java 21
```

**Windows:**
```powershell
# Check current version
java -version

# Uninstall Java 25 and install Java 21
choco install openjdk21 --force
```

**macOS:**
```bash
brew install openjdk@21
```

### Maven not found

**Windows:**
```powershell
# Install via Chocolatey
choco install maven

# Or add to PATH manually
# Add: C:\Program Files\apache-maven-3.x.x\bin
```

**Linux/macOS:**
```bash
# Linux
sudo apt install maven  # Ubuntu
sudo dnf install maven  # Fedora

# macOS
brew install maven
```

### Database connection failed

**Check if PostgreSQL is running:**
```bash
docker ps  # Should show greenbank_postgres
# OR
sudo systemctl status postgresql
```

**Test connection:**
```bash
psql -h localhost -U postgres -d greenbankdb
```

### Flutter app can't connect

**For Android emulator:**
```dart
// Edit: frontend/lib/config/graphql_config.dart
// Use 10.0.2.2 instead of localhost
static const String _baseUrl = 'http://10.0.2.2:8080/graphql';
```

**For physical device or Windows desktop:**
```dart
// Use your computer's IP
static const String _baseUrl = 'http://192.168.1.XXX:8080/graphql';

// On Windows, find your IP with:
// ipconfig
// Look for "IPv4 Address"
```

### Flutter command not found (Windows)

**Error**: `'flutter' is not recognized`

**Solution**:
```powershell
# Add Flutter to PATH
# 1. Open System Properties → Environment Variables
# 2. Edit "Path" variable
# 3. Add: C:\src\flutter\bin
# 4. Restart terminal

# Verify
flutter --version
```

### Port already in use

**Error**: `Port 8080 is already in use`

**Solution**:

**Windows:**
```powershell
# Find process using port 8080
netstat -ano | findstr :8080

# Kill the process (replace PID)
taskkill /PID <PID> /F
```

**Linux/macOS:**
```bash
# Find process
lsof -i :8080

# Kill the process
kill -9 <PID>
```
## 🚀 Development

### Backend Development

```bash
cd backend

# Clean build
mvn clean install

# Run with hot reload
mvn spring-boot:run

# Run tests
mvn test

# Package for production
mvn clean package -DskipTests
```

### Frontend Development

```bash
cd frontend

# Install dependencies
flutter pub get

# Run in debug mode (with hot reload)
flutter run

# Build for release
flutter build apk --release  # Android
flutter build ios --release  # iOS
flutter build web --release  # Web
```

### Database Management

```bash
# Access PostgreSQL (Docker)
docker exec -it greenbank_postgres psql -U postgres -d greenbankdb

# Run SQL file
docker exec -i greenbank_postgres psql -U postgres -d greenbankdb < database/init.sql

# Access pgAdmin
# Open: http://localhost:5050
# Connect to: postgres container (host: postgres, port: 5432)
```

### Adding New Features

#### Backend: Add New GraphQL Mutation

1. **Create DTO** in `dto/`
```java
public record NewFeatureInput(String field1, String field2) {}
```

2. **Add service method** in `service/`
```java
public NewFeature createFeature(NewFeatureInput input) { ... }
```

3. **Create resolver** in `resolver/`
```java
@MutationMapping
public NewFeature newFeature(@Argument NewFeatureInput input) { ... }
```

4. **Update GraphQL schema** in `resources/graphql/schema.graphqls`
```graphql
type Mutation {
  newFeature(input: NewFeatureInput!): NewFeature
}
```

#### Frontend: Add New Screen

1. **Create screen** in `lib/pages/new_feature/`
```dart
class NewFeatureScreen extends StatelessWidget { ... }
```

2. **Add route** in `lib/routes.dart`
```dart
GoRoute(path: '/new-feature', builder: (context, state) => NewFeatureScreen())
```

3. **Add navigation** in sidebar/menu

## 📦 Deployment

### Backend Deployment

#### Docker

```bash
# Build image
cd backend
docker build -t greenbanking-backend:1.0 .

# Run container
docker run -d -p 8081:8081 \
  -e DB_HOST=your-db-host \
  -e DB_PASSWORD=your-password \
  greenbanking-backend:1.0
```

#### Cloud Platforms

**Heroku:**
```bash
heroku create greenbanking-api
git push heroku main
heroku config:set DB_HOST=your-db-host
```

**AWS/Azure/GCP:**
- Use provided Dockerfile
- Configure environment variables
- Set up database connection
- Deploy with container service

### Frontend Deployment

#### Web (Vercel)

```bash
cd frontend
flutter build web --release --web-renderer html

# Deploy to Vercel
cd build/web
vercel deploy --prod
```

#### Mobile App Stores

**Google Play:**
1. Build: `flutter build appbundle --release`
2. Sign with keystore
3. Upload to Play Console

**Apple App Store:**
1. Build: `flutter build ipa --release`
2. Sign with certificates
3. Upload to App Store Connect

## 🧪 Testing Strategy

### Backend Tests

```bash
# Unit tests
mvn test

# Integration tests
mvn verify

# Test with coverage
mvn clean test jacoco:report
```

**Test Categories:**
- ✅ Service layer tests
- ✅ Carbon calculation tests
- ✅ Repository tests
- ✅ Security tests
- ✅ GraphQL resolver tests

### Frontend Tests

```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter drive --target=test_driver/app.dart

# Coverage report
flutter test --coverage
```

## 🔒 Security Considerations

### Backend Security

- ✅ **JWT Authentication** - Secure token-based auth
- ✅ **Password Hashing** - BCrypt with salt
- ✅ **CORS Configuration** - Controlled cross-origin access
- ✅ **SQL Injection Prevention** - JPA parameterized queries
- ✅ **Input Validation** - Spring validation annotations

### Best Practices

```properties
# Use strong JWT secret (64+ characters)
jwt.secret=your-very-long-and-secure-secret-key-here

# Use environment variables for sensitive data
DB_PASSWORD=${DB_PASSWORD}
JWT_SECRET=${JWT_SECRET}

# Enable HTTPS in production
server.ssl.enabled=true
```

### Frontend Security

- ✅ **Secure Storage** - Token storage with encryption
- ✅ **HTTPS Only** - Production API calls over HTTPS
- ✅ **Input Sanitization** - Validate user inputs
- ✅ **Token Expiry** - Automatic refresh mechanism

## 📊 Performance Optimization

### Backend

- **Database indexing** on frequently queried fields
- **Connection pooling** with HikariCP
- **Caching** with Spring Cache
- **Async operations** for non-blocking calls
- **GraphQL DataLoader** for N+1 query prevention

### Frontend

- **Lazy loading** for routes and widgets
- **Image caching** for assets
- **State management** with Provider
- **Debouncing** for search inputs
- **Pagination** for large lists

## 🌍 Environment Configuration

### Development

```properties
# backend/src/main/resources/application-dev.properties
spring.datasource.url=jdbc:postgresql://localhost:5432/greenbankdb
spring.graphql.graphiql.enabled=true
logging.level.root=DEBUG
```

### Production

```properties
# backend/src/main/resources/application-prod.properties
spring.datasource.url=${DATABASE_URL}
spring.graphql.graphiql.enabled=false
logging.level.root=INFO
server.ssl.enabled=true
```

### Environment Variables

```bash
# .env file (don't commit to git!)
DB_HOST=your-db-host
DB_PORT=5432
DB_NAME=greenbankdb
DB_USER=postgres
DB_PASSWORD=your-secure-password
JWT_SECRET=your-jwt-secret-key
```

### Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/houssamb4/GreenBankingSystem.git`
3. Create a branch: `git checkout -b feature/amazing-feature`
4. Make your changes
5. Test thoroughly
6. Commit: `git commit -m 'Add amazing feature'`
7. Push: `git push origin feature/amazing-feature`
8. Open a Pull Request

### Code Style

**Backend (Java):**
- Follow Spring Boot conventions
- Use Lombok for boilerplate
- Write JavaDoc for public methods
- Keep methods under 50 lines
- Use meaningful variable names

**Frontend (Flutter):**
- Follow Dart style guide
- Use `flutter format` before committing
- Run `flutter analyze` to check for issues
- Write widget tests for new components
- Use meaningful widget names

### Commit Messages

```
feat: Add carbon trend analysis
fix: Correct Eco Score calculation
docs: Update API documentation
style: Format backend code
test: Add transaction service tests
refactor: Simplify carbon calculator
```

### Pull Request Process

1. Update documentation if needed
2. Add tests for new features
3. Ensure all tests pass
4. Update CHANGELOG.md
5. Request review from maintainers

## 📝 Changelog

### Version 0.0.5 (Current)
- ✅ Automatic carbon footprint calculation
- ✅ 14 transaction categories
- ✅ Eco Score system
- ✅ GraphQL API with authentication
- ✅ Flutter cross-platform app
- ✅ Cloud database integration

### Upcoming Features
- 🔄 Real-time notifications
- 🔄 Carbon offset marketplace
- 🔄 Social sharing of achievements
- 🔄 AI-powered spending insights
- 🔄 Recurring transaction tracking
- 🔄 Export reports (PDF/CSV)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Green Banking System

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software...
```

## 🙏 Acknowledgments

- **Spring Boot Team** - Excellent framework and documentation
- **Flutter Team** - Amazing cross-platform framework
- **FlareLine** - Beautiful admin dashboard template
- **PostgreSQL** - Robust database system
- **GraphQL** - Modern API query language
- **Aiven** - Managed cloud database hosting
- **Open Source Community** - For inspiration and tools

## 📧 Contact & Support

### Documentation
- [Backend README](backend/README.md) - Complete backend guide
- [Frontend README](frontend/README_GREENBANKING.md) - Complete frontend guide
- [GraphQL API](backend/GRAPHQL_API.md) - API reference
- [Database Setup](database/EXISTING_DB_SETUP.md) - Database guide

### Community
- ⭐ Star this repository if you find it helpful
- 🔔 Watch for updates and new features
- 🍴 Fork to create your own version
- 🤝 Contribute to make it better

## 🎯 Project Roadmap

### Phase 1: Core Features (✅ Complete)
- [x] Backend API with GraphQL
- [x] Carbon calculation engine
- [x] User authentication
- [x] Flutter mobile app
- [x] Basic dashboard

### Phase 2: Enhanced Features (🚧 In Progress)
- [ ] Real-time notifications
- [ ] Advanced analytics
- [ ] Social features
- [ ] Mobile app optimization
- [ ] Web app deployment

### Phase 3: Advanced Features (📋 Planned)
- [ ] AI-powered insights
- [ ] Carbon offset marketplace
- [ ] Multi-currency support
- [ ] Third-party integrations
- [ ] Gamification system

### Phase 4: Enterprise Features (🔮 Future)
- [ ] Multi-tenant architecture
- [ ] White-label solution
- [ ] API marketplace
- [ ] Advanced reporting
- [ ] Enterprise security

## 📚 Additional Resources

### Learning
- [Spring Boot Documentation](https://docs.spring.io/spring-boot/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [GraphQL Documentation](https://graphql.org/learn/)
- [PostgreSQL Tutorial](https://www.postgresql.org/docs/)

### Tools
- [GraphiQL](http://localhost:8081/graphiql) - API playground
- [pgAdmin](http://localhost:5050) - Database management
- [Postman](https://www.postman.com/) - API testing
- [VS Code](https://code.visualstudio.com/) - Recommended IDE

### Related Projects
- [FlareLine Flutter](https://github.com/FlutterFlareLine/FlareLine) - UI template
- [Spring Boot Examples](https://github.com/spring-projects/spring-boot)
- [Flutter Samples](https://github.com/flutter/samples)

---

<div align="center">

**🌱 Making Finance More Sustainable, One Transaction at a Time 🌍**

Made with ❤️ for the planet

[⬆ Back to top](#-green-banking-system)

</div>
