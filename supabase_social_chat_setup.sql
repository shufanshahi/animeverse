-- =====================================================
-- SOCIAL CHAT FEATURE - COMPLETE DATABASE SCHEMA
-- =====================================================
-- This schema creates all necessary tables for the social chat feature
-- including friend requests, friendships, and real-time messaging
-- =====================================================

-- Create friend_requests table
CREATE TABLE IF NOT EXISTS friend_requests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  sender_id TEXT NOT NULL,
  sender_email TEXT NOT NULL,
  receiver_id TEXT NOT NULL,
  receiver_email TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT no_self_friend_request CHECK (sender_id != receiver_id),
  CONSTRAINT unique_friend_request UNIQUE (sender_id, receiver_id)
);

-- Create friendships table (bidirectional)
CREATE TABLE IF NOT EXISTS friendships (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id_1 TEXT NOT NULL,
  user_id_2 TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT no_self_friendship CHECK (user_id_1 != user_id_2),
  CONSTRAINT unique_friendship UNIQUE(user_id_1, user_id_2)
);

-- Create chat_messages table
CREATE TABLE IF NOT EXISTS chat_messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  sender_id TEXT NOT NULL,
  receiver_id TEXT NOT NULL,
  message TEXT NOT NULL CHECK (LENGTH(message) > 0),
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT no_self_message CHECK (sender_id != receiver_id)
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Friend Requests Indexes
CREATE INDEX IF NOT EXISTS idx_friend_requests_receiver ON friend_requests(receiver_id) WHERE status = 'pending';
CREATE INDEX IF NOT EXISTS idx_friend_requests_sender ON friend_requests(sender_id);
CREATE INDEX IF NOT EXISTS idx_friend_requests_status ON friend_requests(status);
CREATE INDEX IF NOT EXISTS idx_friend_requests_created ON friend_requests(created_at DESC);

-- Friendships Indexes
CREATE INDEX IF NOT EXISTS idx_friendships_user1 ON friendships(user_id_1);
CREATE INDEX IF NOT EXISTS idx_friendships_user2 ON friendships(user_id_2);
CREATE INDEX IF NOT EXISTS idx_friendships_created ON friendships(created_at DESC);

-- Chat Messages Indexes
CREATE INDEX IF NOT EXISTS idx_chat_messages_sender ON chat_messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_receiver ON chat_messages(receiver_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_created ON chat_messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_chat_messages_unread ON chat_messages(receiver_id, is_read) WHERE is_read = false;
CREATE INDEX IF NOT EXISTS idx_chat_messages_conversation ON chat_messages(sender_id, receiver_id, created_at);

-- =====================================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for friend_requests
DROP TRIGGER IF EXISTS update_friend_requests_updated_at ON friend_requests;
CREATE TRIGGER update_friend_requests_updated_at
    BEFORE UPDATE ON friend_requests
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Enable Row Level Security
ALTER TABLE friend_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own friend requests" ON friend_requests;
DROP POLICY IF EXISTS "Users can create friend requests" ON friend_requests;
DROP POLICY IF EXISTS "Users can update their received requests" ON friend_requests;
DROP POLICY IF EXISTS "Users can view their friendships" ON friendships;
DROP POLICY IF EXISTS "Users can create friendships" ON friendships;
DROP POLICY IF EXISTS "System can create friendships for accepted requests" ON friendships;
DROP POLICY IF EXISTS "Users can view their messages" ON chat_messages;
DROP POLICY IF EXISTS "Users can send messages" ON chat_messages;
DROP POLICY IF EXISTS "Users can update their received messages" ON chat_messages;
DROP POLICY IF EXISTS "Authenticated users can read friend requests" ON friend_requests;
DROP POLICY IF EXISTS "Authenticated users can insert friend requests" ON friend_requests;
DROP POLICY IF EXISTS "Authenticated users can update friend requests" ON friend_requests;
DROP POLICY IF EXISTS "Authenticated users can read friendships" ON friendships;
DROP POLICY IF EXISTS "Authenticated users can insert friendships" ON friendships;
DROP POLICY IF EXISTS "Authenticated users can read chat messages" ON chat_messages;
DROP POLICY IF EXISTS "Authenticated users can insert chat messages" ON chat_messages;
DROP POLICY IF EXISTS "Authenticated users can update chat messages" ON chat_messages;

-- Friend Requests RLS Policies (Allow authenticated users with proper service role)
-- Since we're using Firebase Auth UIDs stored in user_id field, we need to allow
-- authenticated users to access data, not rely on auth.uid() matching
CREATE POLICY "Authenticated users can read friend requests"
  ON friend_requests FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert friend requests"
  ON friend_requests FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update friend requests"
  ON friend_requests FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Friendships RLS Policies
CREATE POLICY "Authenticated users can read friendships"
  ON friendships FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert friendships"
  ON friendships FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Chat Messages RLS Policies
CREATE POLICY "Authenticated users can read chat messages"
  ON chat_messages FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Authenticated users can insert chat messages"
  ON chat_messages FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update chat messages"
  ON chat_messages FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- =====================================================
-- HELPER FUNCTIONS
-- =====================================================

-- Function to check if two users are friends
CREATE OR REPLACE FUNCTION are_friends(user_id_a TEXT, user_id_b TEXT)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM friendships
    WHERE (user_id_1 = user_id_a AND user_id_2 = user_id_b)
       OR (user_id_1 = user_id_b AND user_id_2 = user_id_a)
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get unread message count
CREATE OR REPLACE FUNCTION get_unread_count(user_id TEXT, friend_id TEXT)
RETURNS INTEGER AS $$
BEGIN
  RETURN (
    SELECT COUNT(*)::INTEGER
    FROM chat_messages
    WHERE receiver_id = user_id
      AND sender_id = friend_id
      AND is_read = false
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to mark all messages as read between two users
CREATE OR REPLACE FUNCTION mark_conversation_as_read(reader_id TEXT, sender_id TEXT)
RETURNS VOID AS $$
BEGIN
  UPDATE chat_messages
  SET is_read = true
  WHERE receiver_id = reader_id
    AND sender_id = sender_id
    AND is_read = false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- GRANT PERMISSIONS
-- =====================================================

-- Grant usage on tables to authenticated users
GRANT SELECT, INSERT, UPDATE ON friend_requests TO authenticated;
GRANT SELECT, INSERT ON friendships TO authenticated;
GRANT SELECT, INSERT, UPDATE ON chat_messages TO authenticated;

-- =====================================================
-- SAMPLE DATA FOR TESTING (OPTIONAL - COMMENT OUT IN PRODUCTION)
-- =====================================================

-- Uncomment below to insert sample data for testing
/*
-- Sample users would need to exist in your profiles table first
-- These are just examples showing the structure

INSERT INTO friend_requests (sender_id, sender_email, receiver_id, receiver_email, status)
VALUES 
  ('user1-uid', 'user1@example.com', 'user2-uid', 'user2@example.com', 'pending'),
  ('user2-uid', 'user2@example.com', 'user3-uid', 'user3@example.com', 'accepted');

INSERT INTO friendships (user_id_1, user_id_2)
VALUES 
  ('user2-uid', 'user3-uid'),
  ('user3-uid', 'user2-uid');

INSERT INTO chat_messages (sender_id, receiver_id, message, is_read)
VALUES 
  ('user2-uid', 'user3-uid', 'Hello! How are you?', false),
  ('user3-uid', 'user2-uid', 'I am good, thanks!', true);
*/

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Run these queries to verify the setup:
-- SELECT * FROM friend_requests;
-- SELECT * FROM friendships;
-- SELECT * FROM chat_messages;
-- SELECT are_friends('user1-uid', 'user2-uid');
-- SELECT get_unread_count('user1-uid', 'user2-uid');
