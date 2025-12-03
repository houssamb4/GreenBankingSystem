-- Green Banking System - Initial Data
-- Carbon emission factors for different transaction categories
-- Values represent kg CO2 per currency unit spent

-- Insert carbon factors for main categories
INSERT INTO carbon_factors (id, category, emission_factor, description, created_at, updated_at)
VALUES
    (gen_random_uuid(), 'FOOD', 0.5000, 'Food and groceries purchases - average emissions per dollar', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'TRANSPORT', 2.1000, 'Transportation including fuel, rideshare, public transit', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'SHOPPING', 0.8000, 'General shopping and retail purchases', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'ENERGY', 1.7000, 'Utilities - electricity, gas, water', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'SERVICES', 0.3000, 'Services and subscriptions', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'ENTERTAINMENT', 0.6000, 'Entertainment, dining out, events', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'TRAVEL', 3.5000, 'Air travel, hotels, tourism - high emissions', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'HEALTHCARE', 0.4000, 'Healthcare and medical expenses', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'EDUCATION', 0.2000, 'Education and learning resources', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'TECHNOLOGY', 1.2000, 'Electronics and tech purchases', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'FASHION', 1.0000, 'Clothing and accessories', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'HOME', 0.9000, 'Home improvement and furniture', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'GREEN', 0.1000, 'Eco-friendly and sustainable purchases - lowest emissions', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'OTHER', 0.5000, 'Miscellaneous transactions - default factor', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (category) DO UPDATE SET
    emission_factor = EXCLUDED.emission_factor,
    description = EXCLUDED.description,
    updated_at = CURRENT_TIMESTAMP;
