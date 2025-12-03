-- Add missing columns to match Spring Boot JPA entities
-- Run this script on your existing database

-- Add created_at and updated_at to carbon_factors table
ALTER TABLE carbon_factors
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Update existing rows to have timestamps
UPDATE carbon_factors
SET created_at = COALESCE(last_updated, CURRENT_TIMESTAMP),
    updated_at = COALESCE(last_updated, CURRENT_TIMESTAMP)
WHERE created_at IS NULL OR updated_at IS NULL;

-- Add the remaining carbon factors from backend/src/main/resources/data.sql
INSERT INTO carbon_factors (category, emission_factor, description, created_at, updated_at)
VALUES
    ('ENTERTAINMENT', 0.6000, 'Entertainment, dining out, events', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('TRAVEL', 3.5000, 'Air travel, hotels, tourism - high emissions', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('HEALTHCARE', 0.4000, 'Healthcare and medical expenses', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('EDUCATION', 0.2000, 'Education and learning resources', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('TECHNOLOGY', 1.2000, 'Electronics and tech purchases', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('FASHION', 1.0000, 'Clothing and accessories', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('HOME', 0.9000, 'Home improvement and furniture', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('GREEN', 0.1000, 'Eco-friendly and sustainable purchases - lowest emissions', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('OTHER', 0.5000, 'Miscellaneous transactions - default factor', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (category) DO UPDATE SET
    emission_factor = EXCLUDED.emission_factor,
    description = EXCLUDED.description,
    updated_at = CURRENT_TIMESTAMP;

-- Verify the data
SELECT category, emission_factor, description
FROM carbon_factors
ORDER BY emission_factor DESC;

-- You should now see all 14 categories
