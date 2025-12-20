-- ============================================================================
-- Green Banking System - Complete Database Setup
-- ============================================================================
-- This script sets up the complete database schema and initial data
-- Run this file once to initialize your Green Banking database
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- 1. CREATE TABLES
-- ============================================================================

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    eco_score DECIMAL(5,2) DEFAULT 0.00,
    total_carbon_saved DECIMAL(10,2) DEFAULT 0.00,
    monthly_carbon_budget DECIMAL(10,2) DEFAULT 100.00,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Carbon factors table
CREATE TABLE IF NOT EXISTS carbon_factors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category VARCHAR(50) UNIQUE NOT NULL,
    emission_factor DECIMAL(10,4) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Transactions table
CREATE TABLE IF NOT EXISTS transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount DECIMAL(15,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    category VARCHAR(50) NOT NULL,
    merchant VARCHAR(255),
    description TEXT,
    carbon_footprint DECIMAL(15,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 2. CREATE INDEXES FOR PERFORMANCE
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);
CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_category ON transactions(category);
CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions(transaction_date);
CREATE INDEX IF NOT EXISTS idx_transactions_user_date ON transactions(user_id, transaction_date DESC);
CREATE INDEX IF NOT EXISTS idx_carbon_factors_category ON carbon_factors(category);

-- ============================================================================
-- 3. INSERT CARBON FACTORS (14 Categories)
-- ============================================================================
-- These emission factors represent kg CO₂ per $ spent
-- Values are based on environmental impact research

INSERT INTO carbon_factors (category, emission_factor, description)
VALUES
    ('GREEN', 0.1000, 'Eco-friendly and sustainable purchases - lowest emissions'),
    ('EDUCATION', 0.2000, 'Education and learning resources'),
    ('SERVICES', 0.3000, 'Services and subscriptions'),
    ('HEALTHCARE', 0.4000, 'Healthcare and medical expenses'),
    ('FOOD', 0.5000, 'Food and groceries purchases - average emissions'),
    ('ENTERTAINMENT', 0.6000, 'Entertainment, dining out, events'),
    ('SHOPPING', 0.8000, 'General shopping and retail purchases'),
    ('HOME', 0.9000, 'Home improvement and furniture'),
    ('FASHION', 1.0000, 'Clothing and accessories'),
    ('TECHNOLOGY', 1.2000, 'Electronics and tech purchases'),
    ('ENERGY', 1.7000, 'Utilities - electricity, gas, water'),
    ('TRANSPORT', 2.1000, 'Transportation including fuel, rideshare, public transit'),
    ('TRAVEL', 3.5000, 'Air travel, hotels, tourism - highest emissions'),
    ('OTHER', 0.5000, 'Miscellaneous transactions - default factor')
ON CONFLICT (category) DO UPDATE SET
    emission_factor = EXCLUDED.emission_factor,
    description = EXCLUDED.description,
    updated_at = CURRENT_TIMESTAMP;

-- ============================================================================
-- 4. INSERT DEMO USER (OPTIONAL)
-- ============================================================================
-- Demo user credentials:
--   Email: demo@greenpay.com
--   Password: password123
-- Password is BCrypt hashed

INSERT INTO users (id, email, password_hash, first_name, last_name, phone_number, eco_score, total_carbon_saved, monthly_carbon_budget, is_active, created_at, updated_at)
VALUES 
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 
     'demo@greenpay.com', 
     '$2a$10$N9qo8uLOickgx2ZMRZoMye1J8qMZNNWJN4A0L9E0Hb2xN5g5g5g5g', 
     'Demo', 
     'User', 
     '+1234567890', 
     85.00, 
     125.50, 
     100.00, 
     true, 
     CURRENT_TIMESTAMP - INTERVAL '30 days', 
     CURRENT_TIMESTAMP)
ON CONFLICT (email) DO NOTHING;

-- ============================================================================
-- 5. INSERT SAMPLE TRANSACTIONS (OPTIONAL)
-- ============================================================================
-- These show how transactions look with carbon footprints

-- Current month transactions
INSERT INTO transactions (user_id, amount, currency, category, merchant, description, carbon_footprint, transaction_date)
VALUES 
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 45.99, 'USD', 'FOOD', 'Whole Foods Market', 'Weekly groceries', 22.995, CURRENT_TIMESTAMP - INTERVAL '2 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 15.50, 'USD', 'TRANSPORT', 'Uber', 'Ride to office', 32.55, CURRENT_TIMESTAMP - INTERVAL '3 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 89.99, 'USD', 'SHOPPING', 'Amazon', 'Office supplies', 71.992, CURRENT_TIMESTAMP - INTERVAL '5 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 125.00, 'USD', 'ENERGY', 'Electric Company', 'Monthly electricity bill', 212.50, CURRENT_TIMESTAMP - INTERVAL '7 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 32.00, 'USD', 'ENTERTAINMENT', 'Netflix', 'Subscription renewal', 19.20, CURRENT_TIMESTAMP - INTERVAL '10 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 67.50, 'USD', 'FOOD', 'Local Restaurant', 'Dinner with friends', 33.75, CURRENT_TIMESTAMP - INTERVAL '12 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 25.00, 'USD', 'TRANSPORT', 'Gas Station', 'Fuel', 52.50, CURRENT_TIMESTAMP - INTERVAL '14 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 199.99, 'USD', 'TECHNOLOGY', 'Best Buy', 'Wireless headphones', 239.988, CURRENT_TIMESTAMP - INTERVAL '18 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 12.99, 'USD', 'SERVICES', 'Spotify', 'Music subscription', 3.897, CURRENT_TIMESTAMP - INTERVAL '20 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 55.00, 'USD', 'FOOD', 'Supermarket', 'Groceries', 27.50, CURRENT_TIMESTAMP - INTERVAL '22 days');

-- Previous month transactions
INSERT INTO transactions (user_id, amount, currency, category, merchant, description, carbon_footprint, transaction_date)
VALUES 
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 350.00, 'USD', 'TRAVEL', 'Delta Airlines', 'Flight ticket', 1225.00, CURRENT_TIMESTAMP - INTERVAL '35 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 78.50, 'USD', 'FASHION', 'H&M', 'Clothing', 78.50, CURRENT_TIMESTAMP - INTERVAL '40 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 42.00, 'USD', 'FOOD', 'Coffee Shop', 'Weekly coffee', 21.00, CURRENT_TIMESTAMP - INTERVAL '42 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 150.00, 'USD', 'HOME', 'IKEA', 'Home decor', 135.00, CURRENT_TIMESTAMP - INTERVAL '45 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 95.00, 'USD', 'HEALTHCARE', 'Pharmacy', 'Medical supplies', 38.00, CURRENT_TIMESTAMP - INTERVAL '48 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 30.00, 'USD', 'GREEN', 'Eco Store', 'Reusable bags and bottles', 3.00, CURRENT_TIMESTAMP - INTERVAL '50 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 18.99, 'USD', 'TRANSPORT', 'Metro Card', 'Monthly transit pass', 39.879, CURRENT_TIMESTAMP - INTERVAL '52 days'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'::uuid, 65.00, 'USD', 'ENTERTAINMENT', 'Movie Theater', 'Movie tickets', 39.00, CURRENT_TIMESTAMP - INTERVAL '55 days');

-- ============================================================================
-- 6. VERIFICATION QUERIES
-- ============================================================================

-- Verify carbon factors
SELECT 
    category, 
    emission_factor AS "kg CO₂ per $", 
    description 
FROM carbon_factors 
ORDER BY emission_factor DESC;

-- Verify demo user
SELECT 
    id, 
    email, 
    first_name, 
    last_name, 
    eco_score 
FROM users 
WHERE email = 'demo@greenpay.com';

-- Verify transactions
SELECT 
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount,
    SUM(carbon_footprint) AS total_carbon_kg
FROM transactions;

-- ============================================================================
-- Setup Complete!
-- ============================================================================
-- Next steps:
-- 1. Start the backend: cd backend && mvn spring-boot:run
-- 2. Access GraphiQL: http://localhost:8081/graphiql
-- 3. Login with: demo@greenpay.com / password123
-- ============================================================================
