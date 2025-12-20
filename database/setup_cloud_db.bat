@echo off
echo ========================================
echo Green Banking System - Cloud DB Setup
echo ========================================
echo.
echo This script will:
echo 1. Connect to Aiven PostgreSQL database
echo 2. Create demo user (if not exists)
echo 3. Load sample transactions
echo.
echo Database: green-banking-system-m59385781-3b93.h.aivencloud.com:17345
echo.

set PGPASSWORD=AVNS_Bwdt22rR8xrdUdwT1L2

echo Step 1: Creating demo user...
psql -h green-banking-system-m59385781-3b93.h.aivencloud.com -p 17345 -U avnadmin -d green-banking-system -f fix_demo_password.sql

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to create demo user
    echo Please check your database connection and credentials
    pause
    exit /b 1
)

echo.
echo Step 2: Loading sample transactions...
psql -h green-banking-system-m59385781-3b93.h.aivencloud.com -p 17345 -U avnadmin -d green-banking-system -f sample_data.sql

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo WARNING: Some sample data may already exist (this is OK)
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo You can now sign in with:
echo   Email: demo@greenpay.com
echo   Password: password123
echo.
echo Backend API: http://localhost:8081/graphql
echo GraphiQL: http://localhost:8081/graphiql
echo.
pause
