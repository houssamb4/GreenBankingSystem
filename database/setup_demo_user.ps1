# Simple PowerShell script to set up cloud database
$env:PGPASSWORD = 'AVNS_Bwdt22rR8xrdUdwT1L2'
$host = 'green-banking-system-m59385781-3b93.h.aivencloud.com'
$port = '17345'
$user = 'avnadmin'
$dbname = 'green-banking-system'

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Querying existing users..." -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

psql -h $host -p $port -U $user -d $dbname -c "SELECT id, email, first_name, last_name, created_at FROM users ORDER BY created_at DESC LIMIT 10;"

Write-Host ""
Write-Host "================================" -ForegroundColor Yellow  
Write-Host "Creating/Updating demo user..." -ForegroundColor Yellow
Write-Host "================================" -ForegroundColor Yellow
Write-Host ""

$sql = @"
INSERT INTO users (
    id, 
    email, 
    password_hash, 
    first_name, 
    last_name, 
    phone_number, 
    eco_score, 
    total_carbon_saved, 
    monthly_carbon_budget, 
    is_active, 
    created_at, 
    updated_at
)
VALUES (
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 
    'demo@greenpay.com', 
    '\`$2a\`$10\`$dXJ3SW6G7P3wuq.BSkEBKOXL8EjP3LJdI8oYGNaCRvNWk3hVn4tW2', 
    'Demo', 
    'User', 
    '+1234567890', 
    85.0, 
    125.50, 
    100.00, 
    true, 
    CURRENT_TIMESTAMP - INTERVAL '30 days', 
    CURRENT_TIMESTAMP
)
ON CONFLICT (email) 
DO UPDATE SET 
    password_hash = EXCLUDED.password_hash,
    updated_at = CURRENT_TIMESTAMP
RETURNING id, email, first_name, last_name;
"@

psql -h $host -p $port -U $user -d $dbname -c $sql

Write-Host ""
Write-Host "================================" -ForegroundColor Green
Write-Host "Setup complete!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""
Write-Host "Login credentials:" -ForegroundColor White
Write-Host "  Email: demo@greenpay.com" -ForegroundColor Cyan
Write-Host "  Password: password123" -ForegroundColor Cyan
Write-Host ""
