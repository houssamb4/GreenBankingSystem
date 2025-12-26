-- ============================================================================
-- Reset Database - Drop all tables and recreate
-- ============================================================================

-- Drop all tables in reverse order of dependencies
DROP TABLE IF EXISTS admin_audit_log CASCADE;
DROP TABLE IF EXISTS eco_suggestions CASCADE;
DROP TABLE IF EXISTS carbon_reports CASCADE;
DROP TABLE IF EXISTS transaction_carbon CASCADE;
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS merchant_rules CASCADE;
DROP TABLE IF EXISTS emission_factors CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Drop old tables if they exist
DROP TABLE IF EXISTS carbon_factors CASCADE;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Now run the enhanced schema creation script
-- This should be followed by running setup_database_enhanced.sql
