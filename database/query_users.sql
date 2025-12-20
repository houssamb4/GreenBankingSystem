-- Quick DB query script
-- Run with: psql ... -f query_users.sql

SELECT 
    id,
    email,
    first_name,
    last_name,
    eco_score,
    total_carbon_saved,
    monthly_carbon_budget,
    is_active,
    created_at
FROM users
ORDER BY created_at DESC;
