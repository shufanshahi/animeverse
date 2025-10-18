-- ================================
-- SUPABASE SQL SETUP FOR PROFILES WITH FIREBASE AUTH
-- ================================
-- This setup uses email as the primary identifier for profiles
-- Works with Firebase Auth where email is the main identifier

-- Drop existing table if it exists (be careful in production!)
-- DROP TABLE IF EXISTS profiles;

-- Create profiles table with email as primary key
CREATE TABLE profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL UNIQUE, -- Primary identifier, matches Firebase Auth email
  user_id TEXT, -- Firebase UID (optional, for reference)
  first_name TEXT,
  last_name TEXT,
  street TEXT,
  zip TEXT,
  state TEXT,
  phone TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Create index on email for faster lookups
CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles (email);

-- Create index on user_id for Firebase UID lookups (if needed)
CREATE INDEX IF NOT EXISTS idx_profiles_user_id ON profiles (user_id);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- ================================
-- RLS POLICIES FOR EMAIL-BASED ACCESS
-- ================================

-- Policy 1: Users can view their own profile by email
-- This assumes you have a way to identify the current user's email
-- You might need to adjust this based on your auth setup
CREATE POLICY "Users can view own profile by email" ON profiles 
FOR SELECT 
USING (true); -- For now, allow all reads. You can restrict this based on your auth logic

-- Policy 2: Users can insert their own profile
CREATE POLICY "Users can insert own profile" ON profiles 
FOR INSERT 
WITH CHECK (true); -- For now, allow all inserts. You can restrict this based on your auth logic

-- Policy 3: Users can update their own profile by email
CREATE POLICY "Users can update own profile by email" ON profiles 
FOR UPDATE 
USING (true); -- For now, allow all updates. You can restrict this based on your auth logic

-- Policy 4: Users can delete their own profile
CREATE POLICY "Users can delete own profile by email" ON profiles 
FOR DELETE 
USING (true); -- For now, allow all deletes. You can restrict this based on your auth logic

-- ================================
-- HELPER FUNCTIONS
-- ================================

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to automatically update updated_at
CREATE TRIGGER update_profiles_updated_at 
    BEFORE UPDATE ON profiles 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- ================================
-- SAMPLE DATA INSERTION
-- ================================

-- Insert a sample profile (replace with actual data)
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
    'firebase_uid_123', -- Replace with actual Firebase UID
    'Sun Woo',
    'Kong',
    '123 Anime Street',
    '12345',
    'California',
    '+1-555-0123'
) ON CONFLICT (email) DO NOTHING; -- Prevents duplicate emails

-- ================================
-- USEFUL QUERIES FOR TESTING
-- ================================

-- Get profile by email
-- SELECT * FROM profiles WHERE email = 'sunwookoong@gmail.com';

-- Get all profiles
-- SELECT * FROM profiles ORDER BY created_at DESC;

-- Update profile by email
-- UPDATE profiles 
-- SET first_name = 'Updated Name' 
-- WHERE email = 'sunwookoong@gmail.com';

-- Delete profile by email
-- DELETE FROM profiles WHERE email = 'sunwookoong@gmail.com';