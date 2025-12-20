-- Sample Data for Green Banking System
-- Run this script on your PostgreSQL database to populate sample transactions
-- Password for test user: password123

-- First, insert a sample user
-- Note: The password is BCrypt hashed for "password123"
INSERT INTO users (id, email, password_hash, first_name, last_name, phone_number, eco_score, total_carbon_saved, monthly_carbon_budget, is_active, created_at, updated_at)
VALUES 
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 
     'demo@greenpay.com', 
     '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8qMZNNWJN4A0L9E0Hb2xN5g5g5g5g', 
     'Demo', 
     'User', 
     '+1234567890', 
     85, 
     125.50, 
     100.00, 
     true, 
     CURRENT_TIMESTAMP - INTERVAL '30 days', 
     CURRENT_TIMESTAMP)
ON CONFLICT (email) DO NOTHING;

-- Insert sample transactions for the past 3 months
-- Recent transactions (This month)
INSERT INTO transactions (id, user_id, amount, currency, category, merchant, description, carbon_footprint, transaction_date, created_at, updated_at)
VALUES 
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 45.99, 'USD', 'FOOD', 'Whole Foods Market', 'Weekly groceries', 22.995, CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 15.50, 'USD', 'TRANSPORT', 'Uber', 'Ride to office', 32.55, CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 89.99, 'USD', 'SHOPPING', 'Amazon', 'Office supplies', 71.992, CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 125.00, 'USD', 'ENERGY', 'Electric Company', 'Monthly electricity bill', 212.50, CURRENT_TIMESTAMP - INTERVAL '7 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 32.00, 'USD', 'ENTERTAINMENT', 'Netflix', 'Subscription renewal', 19.20, CURRENT_TIMESTAMP - INTERVAL '10 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 67.50, 'USD', 'FOOD', 'Local Restaurant', 'Dinner with friends', 33.75, CURRENT_TIMESTAMP - INTERVAL '12 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 25.00, 'USD', 'TRANSPORT', 'Gas Station', 'Fuel', 52.50, CURRENT_TIMESTAMP - INTERVAL '14 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 199.99, 'USD', 'TECHNOLOGY', 'Best Buy', 'Wireless headphones', 239.988, CURRENT_TIMESTAMP - INTERVAL '18 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 12.99, 'USD', 'SERVICES', 'Spotify', 'Music subscription', 3.897, CURRENT_TIMESTAMP - INTERVAL '20 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 55.00, 'USD', 'FOOD', 'Supermarket', 'Groceries', 27.50, CURRENT_TIMESTAMP - INTERVAL '22 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Last month transactions
INSERT INTO transactions (id, user_id, amount, currency, category, merchant, description, carbon_footprint, transaction_date, created_at, updated_at)
VALUES 
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 350.00, 'USD', 'TRAVEL', 'Delta Airlines', 'Flight ticket', 1225.00, CURRENT_TIMESTAMP - INTERVAL '35 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 78.50, 'USD', 'FASHION', 'H&M', 'Clothing', 78.50, CURRENT_TIMESTAMP - INTERVAL '40 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 42.00, 'USD', 'FOOD', 'Coffee Shop', 'Weekly coffee', 21.00, CURRENT_TIMESTAMP - INTERVAL '42 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 150.00, 'USD', 'HOME', 'IKEA', 'Home decor', 135.00, CURRENT_TIMESTAMP - INTERVAL '45 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 95.00, 'USD', 'HEALTHCARE', 'Pharmacy', 'Medical supplies', 38.00, CURRENT_TIMESTAMP - INTERVAL '48 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 30.00, 'USD', 'GREEN', 'Eco Store', 'Reusable bags and bottles', 3.00, CURRENT_TIMESTAMP - INTERVAL '50 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 18.99, 'USD', 'TRANSPORT', 'Metro Card', 'Monthly transit pass', 39.879, CURRENT_TIMESTAMP - INTERVAL '52 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 65.00, 'USD', 'ENTERTAINMENT', 'Movie Theater', 'Movie tickets', 39.00, CURRENT_TIMESTAMP - INTERVAL '55 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Two months ago transactions
INSERT INTO transactions (id, user_id, amount, currency, category, merchant, description, carbon_footprint, transaction_date, created_at, updated_at)
VALUES 
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 120.00, 'USD', 'EDUCATION', 'Online Course', 'Programming course', 24.00, CURRENT_TIMESTAMP - INTERVAL '65 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 88.00, 'USD', 'FOOD', 'Restaurant', 'Lunch meeting', 44.00, CURRENT_TIMESTAMP - INTERVAL '68 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 45.00, 'USD', 'TRANSPORT', 'Gas Station', 'Fuel', 94.50, CURRENT_TIMESTAMP - INTERVAL '70 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 210.00, 'USD', 'TECHNOLOGY', 'Apple Store', 'AirPods', 252.00, CURRENT_TIMESTAMP - INTERVAL '75 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 52.00, 'USD', 'SHOPPING', 'Target', 'Household items', 41.60, CURRENT_TIMESTAMP - INTERVAL '78 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 35.00, 'USD', 'FOOD', 'Grocery Store', 'Weekly groceries', 17.50, CURRENT_TIMESTAMP - INTERVAL '80 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 75.00, 'USD', 'ENERGY', 'Gas Company', 'Natural gas bill', 127.50, CURRENT_TIMESTAMP - INTERVAL '82 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 22.50, 'USD', 'GREEN', 'Farmers Market', 'Organic produce', 2.25, CURRENT_TIMESTAMP - INTERVAL '85 days', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Verify the data was inserted
SELECT 'Sample data inserted successfully!' as status;
SELECT COUNT(*) as user_count FROM users WHERE email = 'demo@greenpay.com';
SELECT COUNT(*) as transaction_count FROM transactions WHERE user_id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid;
