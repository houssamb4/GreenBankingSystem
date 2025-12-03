#!/bin/bash

# Migration script for existing PostgreSQL database
# This adds missing columns and carbon factors

set -e

echo "🌱 Green Banking System - Database Migration"
echo "=============================================="
echo ""

# Configuration - Aiven Cloud PostgreSQL
DB_NAME="green-banking-system"
DB_USER="avnadmin"
DB_PASSWORD="AVNS_Bwdt22rR8xrdUdwT1L2"
DB_HOST="green-banking-system-m59385781-3b93.h.aivencloud.com"
DB_PORT="17345"
SSL_MODE="?sslmode=require"

echo "📊 Database Information:"
echo "   Host: $DB_HOST:$DB_PORT"
echo "   Database: $DB_NAME"
echo "   User: $DB_USER"
echo ""

# Check if PostgreSQL is accessible
echo "🔍 Checking database connection..."
if ! PGPASSWORD=$DB_PASSWORD psql "postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME?sslmode=require" -c "SELECT 1;" &> /dev/null; then
    echo "❌ Cannot connect to database"
    echo "   Make sure PostgreSQL is running and credentials are correct"
    echo "   Try: psql -h $DB_HOST -U $DB_USER -d $DB_NAME"
    exit 1
fi

echo "✅ Database connection successful!"
echo ""

# Count existing carbon factors
echo "📈 Checking existing carbon factors..."
EXISTING_COUNT=$(PGPASSWORD=$DB_PASSWORD psql "postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME?sslmode=require" -t -c "SELECT COUNT(*) FROM carbon_factors;" | tr -d ' ')
echo "   Found: $EXISTING_COUNT categories"
echo ""

# Apply migration
echo "🔄 Applying database migration..."
PGPASSWORD=$DB_PASSWORD psql "postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME?sslmode=require" -f "$(dirname "$0")/add_missing_columns.sql"

echo ""
echo "✅ Migration completed successfully!"
echo ""

# Verify results
NEW_COUNT=$(PGPASSWORD=$DB_PASSWORD psql "postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME?sslmode=require" -t -c "SELECT COUNT(*) FROM carbon_factors;" | tr -d ' ')
echo "📊 Carbon Factors Summary:"
echo "   Before: $EXISTING_COUNT categories"
echo "   After: $NEW_COUNT categories"
echo ""

if [ "$NEW_COUNT" -eq 14 ]; then
    echo "✅ All 14 carbon factor categories are now available!"
    echo ""
    echo "Categories:"
    PGPASSWORD=$DB_PASSWORD psql "postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME?sslmode=require" -c "SELECT category, emission_factor FROM carbon_factors ORDER BY emission_factor DESC;"
    echo ""
    echo "🎉 Database is ready!"
    echo ""
    echo "Next steps:"
    echo "1. cd backend"
    echo "2. mvn spring-boot:run"
    echo "3. Open http://localhost:8080/graphiql"
else
    echo "⚠️  Expected 14 categories, found $NEW_COUNT"
    echo "   Check for errors above"
fi
