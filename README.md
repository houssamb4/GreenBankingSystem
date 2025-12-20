# 🌱 Green Banking System

A comprehensive digital banking platform that **automatically calculates the carbon footprint of every transaction**, helping users make eco-conscious financial decisions.

![Java](https://img.shields.io/badge/Java-21-orange) ![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.4.0-brightgreen) ![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue) ![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue) ![GraphQL](https://img.shields.io/badge/GraphQL-API-E10098)

## ✨ Features

- ✅ **Automatic Carbon Calculation** - Every transaction gets a carbon footprint based on category
- ✅ **14 Transaction Categories** - From eco-friendly (0.1 kg CO₂/$) to high-impact travel (3.5 kg CO₂/$)
- ✅ **Real-time Dashboard** - Live carbon analytics and budget tracking
- ✅ **Eco Score System** - Personal environmental performance rating (0-100)
- ✅ **GraphQL API** - Modern, efficient API with GraphiQL playground
- ✅ **JWT Authentication** - Secure user authentication
- ✅ **Mobile App** - Flutter cross-platform mobile application

## 🏗️ Architecture

```
┌─────────────────┐
│  Flutter App    │  ← User Interface (Mobile)
└────────┬────────┘
         │ GraphQL
         ▼
┌─────────────────┐
│  Spring Boot    │  ← Backend API (Java 21)
│   + GraphQL     │
└────────┬────────┘
         │ JPA/Hibernate
         ▼
┌─────────────────┐
│  PostgreSQL     │  ← Database
└─────────────────┘
```

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

### Option 1: Using Existing PostgreSQL Database ⚡ (Fastest)

If you already have PostgreSQL with the schema created:

```bash
# 1. Navigate to project directory
cd GreenBankingSystem-main

# 2. Run the migration script to add missing columns and carbon factors
./database/migrate_existing_db.sh

# 3. Install Java 21 (if not already installed)
sudo dnf install java-21-openjdk-devel
sudo alternatives --config java  # Select Java 21

# 4. Start the backend
cd backend
mvn clean install -DskipTests
mvn spring-boot:run

# Backend runs on: http://localhost:8081
# GraphiQL: http://localhost:8081/graphiql
```

**Note:** The backend is configured to use your existing database schema. See [database/EXISTING_DB_SETUP.md](database/EXISTING_DB_SETUP.md) for details.

### Option 2: Docker Setup (Recommended for New Setup)

```bash
# 1. Clone the repository
git clone <repository-url>
cd GreenBankingSystem-main

# 2. Start PostgreSQL with Docker
./database/setup.sh

# 3. Start the backend (requires Java 21)
cd backend
mvn spring-boot:run

# 4. Start the Flutter app
cd ../frontend
flutter pub get
flutter run
```

### Option 2: Manual Setup

#### 1. Install Java 21

**Linux (Fedora/RHEL):**
```bash
sudo dnf install java-21-openjdk-devel
sudo alternatives --config java  # Select Java 21
java -version  # Verify
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install openjdk-21-jdk
java -version  # Verify
```

**macOS:**
```bash
# Using Homebrew
brew install openjdk@21

# Add to PATH
echo 'export PATH="/usr/local/opt/openjdk@21/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

java -version  # Verify
```

**Windows:**
```powershell
# Option 1: Using Chocolatey (recommended)
choco install openjdk21

# Option 2: Manual installation
# 1. Download from: https://adoptium.net/temurin/releases/?version=21
# 2. Run the installer
# 3. Add to PATH: Control Panel → System → Environment Variables
#    Add: C:\Program Files\Eclipse Adoptium\jdk-21\bin

# Verify in Command Prompt or PowerShell
java -version  # Should show version 21
```

#### 2. Install Maven (Build Tool)

**Linux:**
```bash
# Fedora/RHEL
sudo dnf install maven

# Ubuntu/Debian
sudo apt install maven

mvn -version  # Verify
```

**macOS:**
```bash
brew install maven
mvn -version  # Verify
```

**Windows:**
```powershell
# Using Chocolatey
choco install maven

# Or download manually from: https://maven.apache.org/download.cgi
# Extract and add to PATH

mvn -version  # Verify
```

#### 3. Install PostgreSQL (Optional - using Aiven Cloud)

**Note:** Since you're using Aiven Cloud PostgreSQL, you can skip local installation. Otherwise:

**Linux:**
```bash
# Fedora
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
