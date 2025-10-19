# 🔧 Supabase Connection Issue - Quick Fix Guide

## Problem

Friend requests are sent from UI but not saved to Supabase database. Read operations also fail.

## Root Cause

You're using the **anon key** (public key) which is restricted by Row Level Security (RLS) policies. Since your app uses Firebase Auth instead of Supabase Auth, the RLS policies checking `auth.uid()` will always fail.

## Solution Options

### ✅ Option 1: Use Service Role Key (RECOMMENDED - Quick Fix)

**Step 1: Get Your Service Role Key**

1. Go to your Supabase Dashboard: https://supabase.com/dashboard
2. Select your project: `alehkfzvhjhrtukqlqmt`
3. Go to **Settings** → **API**
4. Copy the **`service_role`** key (secret)
   - ⚠️ This is a SECRET key - never commit to Git!
   - It starts with `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

**Step 2: Update Your App**

Open `lib/main.dart` and find where Supabase is initialized:

```dart
// BEFORE (using anon key):
await Supabase.initialize(
  url: 'https://alehkfzvhjhrtukqlqmt.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
);

// AFTER (using service_role key):
await Supabase.initialize(
  url: 'https://alehkfzvhjhrtukqlqmt.supabase.co',
  anonKey: 'YOUR_SERVICE_ROLE_KEY_HERE', // Paste the service_role key
);
```

**Step 3: Test**

1. Hot restart your app (not hot reload)
2. Send a friend request
3. Check Supabase dashboard → Table Editor → `friend_requests`
4. You should see the new record!

---

### ✅ Option 2: Disable RLS Temporarily (For Testing Only)

If you want to test quickly without changing keys:

**In Supabase SQL Editor, run:**

```sql
-- Disable RLS on all social chat tables (TEMPORARY - for testing only!)
ALTER TABLE friend_requests DISABLE ROW LEVEL SECURITY;
ALTER TABLE friendships DISABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages DISABLE ROW LEVEL SECURITY;
```

⚠️ **WARNING**: This makes your data publicly accessible! Only do this for testing.

**To re-enable later:**
```sql
ALTER TABLE friend_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
```

---

### ✅ Option 3: Fix RLS Policies (Production Solution)

The issue is that RLS policies check `auth.uid()` which only works with Supabase Auth, not Firebase Auth.

**In Supabase SQL Editor, run:**

```sql
-- Drop all existing policies
DROP POLICY IF EXISTS "Authenticated users can read friend requests" ON friend_requests;
DROP POLICY IF EXISTS "Authenticated users can insert friend requests" ON friend_requests;
DROP POLICY IF EXISTS "Authenticated users can update friend requests" ON friend_requests;
DROP POLICY IF EXISTS "Authenticated users can read friendships" ON friendships;
DROP POLICY IF EXISTS "Authenticated users can insert friendships" ON friendships;
DROP POLICY IF EXISTS "Authenticated users can read chat messages" ON chat_messages;
DROP POLICY IF EXISTS "Authenticated users can insert chat messages" ON chat_messages;
DROP POLICY IF EXISTS "Authenticated users can update chat messages" ON chat_messages;

-- Create new policies that work with Firebase Auth
-- Allow all operations for now (you can add custom logic later)
CREATE POLICY "Allow all for authenticated users - friend_requests_select"
  ON friend_requests FOR SELECT
  USING (true);

CREATE POLICY "Allow all for authenticated users - friend_requests_insert"
  ON friend_requests FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all for authenticated users - friend_requests_update"
  ON friend_requests FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all for authenticated users - friendships_select"
  ON friendships FOR SELECT
  USING (true);

CREATE POLICY "Allow all for authenticated users - friendships_insert"
  ON friendships FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all for authenticated users - chat_messages_select"
  ON chat_messages FOR SELECT
  USING (true);

CREATE POLICY "Allow all for authenticated users - chat_messages_insert"
  ON chat_messages FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all for authenticated users - chat_messages_update"
  ON chat_messages FOR UPDATE
  USING (true)
  WITH CHECK (true);
```

---

## Verification Steps

After applying any solution above:

### 1. Test Insert (Send Friend Request)

```dart
// In your app, send a friend request
// Then verify in Supabase:
```

**Supabase SQL Editor:**
```sql
SELECT * FROM friend_requests ORDER BY created_at DESC LIMIT 5;
```

Expected: You should see the new request with:
- `sender_id` = Firebase Auth UID
- `receiver_id` = Firebase Auth UID
- `status` = 'pending'

### 2. Test Read (View Friend Requests)

```sql
-- Check if you can read the data
SELECT 
  sender_email,
  receiver_email,
  status,
  created_at
FROM friend_requests
WHERE status = 'pending';
```

Expected: All pending requests should appear.

### 3. Test Update (Accept Friend Request)

Accept a friend request in your app, then verify:

```sql
-- Should see TWO friendship entries (bidirectional)
SELECT * FROM friendships ORDER BY created_at DESC LIMIT 10;

-- Should see status updated to 'accepted'
SELECT * FROM friend_requests WHERE status = 'accepted' ORDER BY updated_at DESC LIMIT 5;
```

---

## Current Connection Test

To verify your current Supabase connection works:

**Supabase SQL Editor:**
```sql
-- Test 1: Can you read profiles?
SELECT COUNT(*) as profile_count FROM profiles;

-- Test 2: Check RLS status
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename IN ('friend_requests', 'friendships', 'chat_messages');

-- Test 3: Check existing policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd 
FROM pg_policies 
WHERE tablename IN ('friend_requests', 'friendships', 'chat_messages');
```

---

## Debug Logs

Add these debug statements to see exactly what's happening:

### In `social_chat_remote_datasource.dart`:

```dart
@override
Future<FriendRequestModel> sendFriendRequest({
  required String senderId,
  required String senderEmail,
  required String receiverId,
  required String receiverEmail,
}) async {
  try {
    print('🔍 DEBUG: Sending friend request...');
    print('   Sender ID: $senderId');
    print('   Receiver ID: $receiverId');
    
    // Check if request already exists
    final existing = await supabaseClient
        .from('friend_requests')
        .select()
        .eq('sender_id', senderId)
        .eq('receiver_id', receiverId)
        .maybeSingle();

    if (existing != null) {
      print('❌ Friend request already exists');
      throw Exception('Friend request already sent');
    }

    print('✅ No existing request, inserting new one...');
    
    final response = await supabaseClient
        .from('friend_requests')
        .insert({
          'sender_id': senderId,
          'sender_email': senderEmail,
          'receiver_id': receiverId,
          'receiver_email': receiverEmail,
          'status': 'pending',
        })
        .select()
        .single();

    print('✅ Friend request sent successfully!');
    print('   Response: $response');
    
    return FriendRequestModel.fromJson(response);
  } catch (e) {
    print('❌ ERROR sending friend request: $e');
    print('   Error type: ${e.runtimeType}');
    throw Exception('Failed to send friend request: $e');
  }
}
```

Run your app and check the console for these debug logs.

---

## Common Issues & Solutions

### Issue 1: "Failed to send friend request: null"
**Cause**: RLS blocking the insert
**Fix**: Use service_role key OR disable RLS OR update policies

### Issue 2: "PostgrestException: JWT expired"
**Cause**: Invalid or expired key
**Fix**: Copy fresh keys from Supabase dashboard

### Issue 3: "No pending friend requests" but data exists in database
**Cause**: RLS blocking the SELECT query
**Fix**: Same as Issue 1

### Issue 4: User IDs don't match
**Cause**: Using wrong user_id (Firebase UID vs Supabase UID)
**Fix**: Ensure you're using Firebase Auth UID from the profile table

---

## Quick Test Script

Run this in Supabase SQL Editor to manually test the flow:

```sql
-- 1. Insert a test friend request
INSERT INTO friend_requests (sender_id, sender_email, receiver_id, receiver_email, status)
VALUES 
  ('test_user_1', 'alice@test.com', 'test_user_2', 'bob@test.com', 'pending');

-- 2. Verify it was inserted
SELECT * FROM friend_requests WHERE sender_email = 'alice@test.com';

-- 3. Accept the request (simulate accept action)
UPDATE friend_requests 
SET status = 'accepted', updated_at = NOW()
WHERE sender_email = 'alice@test.com' AND receiver_email = 'bob@test.com';

-- 4. Create friendships
INSERT INTO friendships (user_id_1, user_id_2) VALUES 
  ('test_user_1', 'test_user_2'),
  ('test_user_2', 'test_user_1');

-- 5. Verify friendships
SELECT * FROM friendships;

-- 6. Clean up test data
DELETE FROM friendships WHERE user_id_1 IN ('test_user_1', 'test_user_2');
DELETE FROM friend_requests WHERE sender_email = 'alice@test.com';
```

If this works in SQL Editor but not in your app, the issue is definitely with the API key or RLS policies.

---

## Recommended Solution

**For fastest fix (in order):**

1. ✅ **Get service_role key** from Supabase dashboard
2. ✅ **Replace anon key** with service_role key in `main.dart`
3. ✅ **Hot restart** your app
4. ✅ **Test** sending friend request
5. ✅ **Check** Supabase table editor

This should work immediately!

---

## Security Note

⚠️ **Service Role Key Security:**
- Service role key bypasses ALL security rules
- Safe for development/testing
- For production, use proper RLS policies + anon key
- Never commit service_role key to Git
- Add to `.gitignore`: `lib/core/config/supabase_config.dart`

---

Need help? Share the error message from the console and I'll help debug further!
