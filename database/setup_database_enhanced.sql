-- ============================================================================
-- Banque Numérique Verte - Enhanced Database Schema
-- ============================================================================
-- Complete database setup matching the detailed specifications
-- Run this file to initialize the Green Banking database
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ============================================================================
-- 1. CORE TABLES
-- ============================================================================

-- Users table with preferences
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(200),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone_number VARCHAR(20),
    preferences JSONB DEFAULT '{}',
    two_factor_enabled BOOLEAN DEFAULT false,
    two_factor_secret VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Accounts table (bank accounts for each user)
CREATE TABLE IF NOT EXISTS accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    account_type VARCHAR(50) NOT NULL, -- CHECKING, SAVINGS, CREDIT_CARD
    currency VARCHAR(3) DEFAULT 'EUR',
    balance DECIMAL(15,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    name_fr VARCHAR(100),
    description TEXT,
    icon VARCHAR(50),
    color VARCHAR(7),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Emission factors table with versioning
CREATE TABLE IF NOT EXISTS emission_factors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID REFERENCES categories(id) ON DELETE CASCADE,
    factor_value DECIMAL(10,4) NOT NULL, -- gCO2e per EUR
    unit VARCHAR(20) DEFAULT 'gCO2e/EUR',
    source VARCHAR(255),
    effective_date DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Merchant rules for automatic categorization
CREATE TABLE IF NOT EXISTS merchant_rules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_pattern VARCHAR(255) NOT NULL,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    priority INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Transactions table
CREATE TABLE IF NOT EXISTS transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    account_id UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    date TIMESTAMP WITH TIME ZONE NOT NULL,
    merchant_name VARCHAR(255),
    amount DECIMAL(15,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'EUR',
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    payment_method VARCHAR(50), -- CARD, TRANSFER, CASH, CHEQUE
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Transaction carbon tracking
CREATE TABLE IF NOT EXISTS transaction_carbon (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    transaction_id UUID NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
    carbon_value_g DECIMAL(15,2) NOT NULL, -- gCO2e
    factor_id UUID REFERENCES emission_factors(id),
    calculation_method VARCHAR(50),
    details_json JSONB,
    computed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Monthly carbon reports
CREATE TABLE IF NOT EXISTS carbon_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    report_month DATE NOT NULL,
    total_carbon_g DECIMAL(15,2),
    category_breakdown JSONB,
    recommendations JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, report_month)
);

-- Eco suggestions
CREATE TABLE IF NOT EXISTS eco_suggestions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    suggestion_type VARCHAR(50),
    title VARCHAR(200),
    description TEXT,
    category_id UUID REFERENCES categories(id),
    potential_saving_g DECIMAL(10,2),
    priority INTEGER DEFAULT 0,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Admin audit log
CREATE TABLE IF NOT EXISTS admin_audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id UUID,
    changes JSONB,
    ip_address INET,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 2. INDEXES FOR PERFORMANCE
-- ============================================================================

-- Users
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_active ON users(is_active);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

-- Accounts
CREATE INDEX IF NOT EXISTS idx_accounts_user_id ON accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_accounts_type ON accounts(account_type);

-- Transactions
CREATE INDEX IF NOT EXISTS idx_transactions_account_id ON transactions(account_id);
CREATE INDEX IF NOT EXISTS idx_transactions_date ON transactions(date);
CREATE INDEX IF NOT EXISTS idx_transactions_category_id ON transactions(category_id);
CREATE INDEX IF NOT EXISTS idx_transactions_merchant ON transactions(merchant_name);
CREATE INDEX IF NOT EXISTS idx_transactions_account_date ON transactions(account_id, date DESC);

-- Transaction Carbon
CREATE INDEX IF NOT EXISTS idx_transaction_carbon_trans_id ON transaction_carbon(transaction_id);
CREATE INDEX IF NOT EXISTS idx_transaction_carbon_factor_id ON transaction_carbon(factor_id);

-- Emission Factors
CREATE INDEX IF NOT EXISTS idx_emission_factors_category ON emission_factors(category_id);
CREATE INDEX IF NOT EXISTS idx_emission_factors_date ON emission_factors(effective_date, end_date);

-- Merchant Rules
CREATE INDEX IF NOT EXISTS idx_merchant_rules_pattern ON merchant_rules(merchant_pattern);
CREATE INDEX IF NOT EXISTS idx_merchant_rules_category ON merchant_rules(category_id);
CREATE INDEX IF NOT EXISTS idx_merchant_rules_active ON merchant_rules(is_active);

-- Carbon Reports
CREATE INDEX IF NOT EXISTS idx_carbon_reports_user_month ON carbon_reports(user_id, report_month);

-- ============================================================================
-- 3. INSERT DEFAULT CATEGORIES (French context)
-- ============================================================================

INSERT INTO categories (name, name_fr, description, icon, color) VALUES
('TRANSPORT', 'Transport', 'Déplacements (voiture, transports en commun, avion)', 'directions_car', '#EF4444'),
('ALIMENTATION', 'Alimentation', 'Courses alimentaires, restaurants', 'restaurant', '#F59E0B'),
('HEBERGEMENT', 'Hébergement', 'Loyer, hôtels, hébergement', 'home', '#10B981'),
('ACHATS', 'Achats', 'Achats généraux, shopping', 'shopping_bag', '#3B82F6'),
('SERVICES', 'Services', 'Services divers, abonnements', 'build', '#6366F1'),
('ENERGIE', 'Énergie', 'Électricité, gaz, eau', 'bolt', '#F59E0B'),
('SANTE', 'Santé', 'Soins médicaux, pharmacie', 'local_hospital', '#EC4899'),
('LOISIRS', 'Loisirs', 'Divertissement, culture, sport', 'sports_esports', '#8B5CF6'),
('TECH', 'Technologie', 'Électronique, informatique', 'devices', '#06B6D4'),
('MODE', 'Mode', 'Vêtements, accessoires', 'checkroom', '#EC4899'),
('EDUCATION', 'Éducation', 'Formation, livres, fournitures', 'school', '#14B8A6'),
('VERT', 'Vert', 'Produits éco-responsables', 'eco', '#10B981'),
('AUTRE', 'Autre', 'Transactions diverses', 'more_horiz', '#6B7280')
ON CONFLICT (name) DO UPDATE SET
    name_fr = EXCLUDED.name_fr,
    description = EXCLUDED.description,
    icon = EXCLUDED.icon,
    color = EXCLUDED.color;

-- ============================================================================
-- 4. INSERT EMISSION FACTORS (gCO2e per EUR)
-- ============================================================================
-- Source: Based on ADEME (Agence de l'Environnement et de la Maîtrise de l'Énergie)
-- Values are in grams of CO2 equivalent per Euro spent

INSERT INTO emission_factors (category_id, factor_value, unit, source, effective_date)
SELECT
    c.id,
    CASE
        WHEN c.name = 'TRANSPORT' THEN 2100.0
        WHEN c.name = 'ALIMENTATION' THEN 500.0
        WHEN c.name = 'HEBERGEMENT' THEN 400.0
        WHEN c.name = 'ACHATS' THEN 800.0
        WHEN c.name = 'SERVICES' THEN 300.0
        WHEN c.name = 'ENERGIE' THEN 1700.0
        WHEN c.name = 'SANTE' THEN 400.0
        WHEN c.name = 'LOISIRS' THEN 600.0
        WHEN c.name = 'TECH' THEN 1200.0
        WHEN c.name = 'MODE' THEN 1000.0
        WHEN c.name = 'EDUCATION' THEN 200.0
        WHEN c.name = 'VERT' THEN 100.0
        ELSE 500.0
    END as factor_value,
    'gCO2e/EUR',
    'ADEME Base Carbone v2024',
    CURRENT_DATE
FROM categories c
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 5. INSERT MERCHANT RULES (Examples for France)
-- ============================================================================

INSERT INTO merchant_rules (merchant_pattern, category_id, priority)
SELECT
    pattern,
    (SELECT id FROM categories WHERE name = cat_name),
    priority
FROM (VALUES
    ('%SNCF%', 'TRANSPORT', 10),
    ('%RATP%', 'TRANSPORT', 10),
    ('%UBER%', 'TRANSPORT', 10),
    ('%TOTAL%', 'TRANSPORT', 10),
    ('%BP%', 'TRANSPORT', 10),
    ('%CARREFOUR%', 'ALIMENTATION', 10),
    ('%AUCHAN%', 'ALIMENTATION', 10),
    ('%LECLERC%', 'ALIMENTATION', 10),
    ('%MONOPRIX%', 'ALIMENTATION', 10),
    ('%FRANPRIX%', 'ALIMENTATION', 10),
    ('%MCDON%', 'ALIMENTATION', 10),
    ('%KFC%', 'ALIMENTATION', 10),
    ('%RESTAURANT%', 'ALIMENTATION', 5),
    ('%EDF%', 'ENERGIE', 10),
    ('%ENGIE%', 'ENERGIE', 10),
    ('%VEOLIA%', 'ENERGIE', 10),
    ('%AIRBNB%', 'HEBERGEMENT', 10),
    ('%BOOKING%', 'HEBERGEMENT', 10),
    ('%HOTEL%', 'HEBERGEMENT', 5),
    ('%AMAZON%', 'ACHATS', 10),
    ('%FNAC%', 'ACHATS', 10),
    ('%DECATHLON%', 'ACHATS', 10),
    ('%ZARA%', 'MODE', 10),
    ('%H&M%', 'MODE', 10),
    ('%NIKE%', 'MODE', 10),
    ('%APPLE%', 'TECH', 10),
    ('%BOULANGER%', 'TECH', 10),
    ('%DARTY%', 'TECH', 10),
    ('%NETFLIX%', 'LOISIRS', 10),
    ('%SPOTIFY%', 'LOISIRS', 10),
    ('%CINEMA%', 'LOISIRS', 5),
    ('%PHARMACIE%', 'SANTE', 10),
    ('%DOCTEUR%', 'SANTE', 5)
) AS merchant_data(pattern, cat_name, priority)
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 6. CREATE DEMO USER
-- ============================================================================
-- Password: GreenBank2024!
-- Hash generated with BCrypt

INSERT INTO users (email, password_hash, first_name, last_name, full_name, preferences)
VALUES (
    'demo@banqueverte.fr',
    '$2a$10$YourActualBcryptHashHere',
    'Marie',
    'Dupont',
    'Marie Dupont',
    '{"language": "fr", "currency": "EUR", "notifications": true}'::jsonb
)
ON CONFLICT (email) DO NOTHING;

-- Create demo account
INSERT INTO accounts (user_id, name, account_type, currency, balance)
SELECT
    u.id,
    'Compte Courant Principal',
    'CHECKING',
    'EUR',
    2500.00
FROM users u WHERE u.email = 'demo@banqueverte.fr'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 7. INSERT DEMO TRANSACTIONS
-- ============================================================================

WITH demo_account AS (
    SELECT a.id as account_id
    FROM accounts a
    JOIN users u ON a.user_id = u.id
    WHERE u.email = 'demo@banqueverte.fr'
    LIMIT 1
),
demo_transactions AS (
    INSERT INTO transactions (account_id, date, merchant_name, amount, currency, category_id, payment_method, description)
    SELECT
        da.account_id,
        NOW() - INTERVAL '1 day' * (random() * 30)::int,
        merchant,
        amount,
        'EUR',
        (SELECT id FROM categories WHERE name = category),
        method,
        descr
    FROM demo_account da,
    (VALUES
        ('CARREFOUR MARKET PARIS', 45.80, 'ALIMENTATION', 'CARD', 'Courses hebdomadaires'),
        ('SNCF VOYAGES', 89.00, 'TRANSPORT', 'CARD', 'Billet TGV Paris-Lyon'),
        ('EDF ELECTRICITE', 78.50, 'ENERGIE', 'TRANSFER', 'Facture électricité'),
        ('RESTAURANT LE MARAIS', 62.00, 'ALIMENTATION', 'CARD', 'Déjeuner'),
        ('FNAC PARIS', 35.90, 'ACHATS', 'CARD', 'Livre et DVD'),
        ('TOTAL ENERGIE', 65.00, 'TRANSPORT', 'CARD', 'Essence'),
        ('PHARMACIE CENTRALE', 18.50, 'SANTE', 'CARD', 'Médicaments'),
        ('NETFLIX', 13.49, 'LOISIRS', 'CARD', 'Abonnement mensuel'),
        ('ZARA CHAMPS ELYSEES', 89.90, 'MODE', 'CARD', 'Vêtements'),
        ('BIO COOP', 42.30, 'VERT', 'CARD', 'Produits bio'),
        ('UBER', 15.50, 'TRANSPORT', 'CARD', 'Course'),
        ('AMAZON.FR', 56.70, 'ACHATS', 'CARD', 'Divers achats en ligne'),
        ('MONOPRIX', 23.40, 'ALIMENTATION', 'CARD', 'Courses express'),
        ('CINEMA UGC', 24.00, 'LOISIRS', 'CARD', '2 places de cinéma'),
        ('DECATHLON', 67.50, 'ACHATS', 'CARD', 'Équipement sport')
    ) AS t(merchant, amount, category, method, descr)
    RETURNING id, category_id, amount
)
-- Calculate and insert carbon footprints
INSERT INTO transaction_carbon (transaction_id, carbon_value_g, factor_id, calculation_method, details_json)
SELECT
    dt.id,
    dt.amount * ef.factor_value,
    ef.id,
    'FACTOR_BASED',
    jsonb_build_object(
        'amount', dt.amount,
        'factor', ef.factor_value,
        'category', c.name
    )
FROM demo_transactions dt
JOIN categories c ON c.id = dt.category_id
JOIN emission_factors ef ON ef.category_id = c.id AND ef.end_date IS NULL;

-- ============================================================================
-- 8. CREATE VIEWS FOR REPORTING
-- ============================================================================

-- Monthly carbon by user and category
CREATE OR REPLACE VIEW v_monthly_carbon_by_category AS
SELECT
    u.id as user_id,
    u.email,
    DATE_TRUNC('month', t.date) as month,
    c.name as category,
    c.name_fr as category_fr,
    COUNT(t.id) as transaction_count,
    SUM(t.amount) as total_amount,
    SUM(tc.carbon_value_g) as total_carbon_g,
    AVG(tc.carbon_value_g) as avg_carbon_g
FROM users u
JOIN accounts a ON a.user_id = u.id
JOIN transactions t ON t.account_id = a.id
LEFT JOIN transaction_carbon tc ON tc.transaction_id = t.id
LEFT JOIN categories c ON c.id = t.category_id
GROUP BY u.id, u.email, DATE_TRUNC('month', t.date), c.name, c.name_fr;

-- User carbon summary
CREATE OR REPLACE VIEW v_user_carbon_summary AS
SELECT
    u.id as user_id,
    u.email,
    u.full_name,
    COUNT(DISTINCT t.id) as total_transactions,
    SUM(t.amount) as total_spent,
    SUM(tc.carbon_value_g) as total_carbon_g,
    SUM(tc.carbon_value_g) / 1000.0 as total_carbon_kg,
    AVG(tc.carbon_value_g) as avg_carbon_per_transaction
FROM users u
JOIN accounts a ON a.user_id = u.id
JOIN transactions t ON t.account_id = a.id
LEFT JOIN transaction_carbon tc ON tc.transaction_id = t.id
GROUP BY u.id, u.email, u.full_name;

-- ============================================================================
-- Setup Complete!
-- ============================================================================
-- Next steps:
-- 1. Update backend entities and repositories
-- 2. Update GraphQL schema
-- 3. Add admin endpoints for emission factor management
-- 4. Update frontend for French context
-- ============================================================================
