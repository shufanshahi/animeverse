-- ================================
-- MINIMAL SUPABASE SETUP FOR TESTING
-- ================================
-- Run this in your Supabase SQL Editor

-- Step 1: Drop existing table if needed (CAREFUL in production!)
DROP TABLE IF EXISTS profiles CASCADE;

-- Step 2: Create profiles table (simple version)
CREATE TABLE profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL UNIQUE,
  user_id TEXT,
  first_name TEXT,
  last_name TEXT,
  street TEXT,
  zip TEXT,
  state TEXT,
  phone TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 3: Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles (email);
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON profiles (user_id);

-- Step 4: DISABLE RLS completely for testing
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Step 5: Insert test data for sunwookoong@gmail.com
INSERT INTO profiles (
    email,
    user_id,
    first_name,
    last_name,
    street,
    zip,
    state,
    phone
) VALUES (
    'sunwookoong@gmail.com',
    'firebase_test_uid',
    'Sun Woo',
    'Kong',
    '123 Anime Street',
    '12345',
    'California',
    '+1-555-0123'
) ON CONFLICT (email) DO UPDATE SET
    user_id = EXCLUDED.user_id,
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    updated_at = NOW();

-- Step 6: Verify the setup
SELECT 
    'Table created successfully' as status,
    COUNT(*) as total_profiles
FROM profiles;

-- Step 7: Show the test data
SELECT * FROM profiles WHERE email = 'sunwookoong@gmail.com';