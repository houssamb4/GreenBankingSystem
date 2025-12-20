-- Create or fix the demo user
-- Email: demo@greenpay.com
-- Password: password123
-- BCrypt hash generated for "password123" with strength 10

-- Insert or update the demo user
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
    '$2a$10$dXJ3SW6G7P3wuq.BSkEBKOXL8EjP3LJdI8oYGNaCRvNWk3hVn4tW2', 
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
    updated_at = CURRENT_TIMESTAMP;

-- Verify the user exists
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
WHERE email = 'demo@greenpay.com';
