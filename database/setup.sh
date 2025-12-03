#!/bin/bash

# Green Banking Database Setup Script

set -e

echo "🌱 Green Banking System - Database Setup"
echo "=========================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed."
    exit 1
fi

echo "✅ Docker is installed"
echo ""

# Start PostgreSQL
echo "🚀 Starting PostgreSQL database..."
cd "$(dirname "$0")/.."
docker-compose up -d postgres

echo ""
echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 5

# Check if PostgreSQL is ready
until docker exec greenbank_postgres pg_isready -U postgres &> /dev/null; do
    echo "   Waiting for PostgreSQL..."
    sleep 2
done

echo ""
echo "✅ PostgreSQL is ready!"
echo ""
echo "📊 Database Information:"
echo "   Host: localhost"
echo "   Port: 5432"
echo "   Database: greenbankdb"
echo "   Username: postgres"
echo "   Password: postgres"
echo ""
echo "🔧 Optional: Start pgAdmin for database management"
echo "   Run: docker-compose up -d pgadmin"
echo "   Access: http://localhost:5050"
echo "   Email: admin@greenbank.com"
echo "   Password: admin"
echo ""
echo "✅ Database setup complete!"
echo ""
echo "Next steps:"
echo "1. Start the backend: cd backend && mvn spring-boot:run"
echo "2. Backend will automatically create tables and load carbon factors"
