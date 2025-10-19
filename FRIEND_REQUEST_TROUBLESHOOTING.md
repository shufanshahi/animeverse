# Friend Request System - Troubleshooting Guide

## Problem: Friend Requests Not Showing Up

### Root Cause
The friend request system uses **Supabase profiles** to manage relationships. If a user hasn't created their profile in Supabase yet, they won't receive friend requests.

### How It Works

1. **User Registration (Firebase Auth)**
   - User signs up with email/password
   - Firebase Auth creates user with UID (e.g., `abc123`)

2. **Profile Creation (Supabase)**
   - User navigates to Profile screen
   - Creates profile with personal info
   - Supabase stores profile with `user_id = Firebase Auth UID`

3. **Friend Requests**
   - User A searches for User B by name
   - Sends friend request: `sender_id = A's user_id`, `receiver_id = B's user_id`
   - Supabase stores in `friend_requests` table

4. **Viewing Friend Requests**
   - User B opens Friend Requests screen
   - App queries: `WHERE receiver_id = B's user_id AND status = 'pending'`
   - **PROBLEM**: If User B's profile doesn't exist in Supabase, no match!

## Solution Steps

### Step 1: Ensure Both Users Have Profiles

**User A (Sender):**
1. Sign in to the app
2. Go to Profile screen
3. Fill out the profile form with:
   - First Name
   - Last Name
   - Email (auto-filled from Firebase Auth)
   - Address details
   - Phone
4. Click "Create Profile" or "Save Changes"
5. Verify profile is saved (screen should show your info)

**User B (Receiver):**
1. Sign in to the app
2. **IMPORTANT**: Go to Profile screen first!
3. Create your profile (same as above)
4. Only then can you receive friend requests

### Step 2: Verify Profiles in Supabase

Open your Supabase dashboard and check the `profiles` table:

```sql
SELECT user_id, email, first_name, last_name, created_at 
FROM profiles 
ORDER BY created_at DESC;
```

You should see entries like:
| user_id | email | first_name | last_name | created_at |
|---------|-------|------------|-----------|------------|
| abc123 | user1@example.com | John | Doe | 2025-10-19 |
| xyz789 | user2@example.com | Jane | Smith | 2025-10-19 |

### Step 3: Send Friend Request

**User A:**
1. Go to Profile screen
2. Click "Search Users"
3. Search for User B by name (e.g., "Jane")
4. Click "Add Friend" button
5. You should see a success message

### Step 4: Verify Friend Request in Database

Check the `friend_requests` table:

```sql
SELECT id, sender_id, sender_email, receiver_id, receiver_email, status, created_at
FROM friend_requests
WHERE status = 'pending'
ORDER BY created_at DESC;
```

You should see:
| id | sender_id | sender_email | receiver_id | receiver_email | status | created_at |
|----|-----------|--------------|-------------|----------------|--------|------------|
| req1 | abc123 | user1@example.com | xyz789 | user2@example.com | pending | 2025-10-19 |

### Step 5: View and Accept Friend Request

**User B:**
1. Go to Profile screen
2. Click "Friend Requests"
3. You should see User A's request with their full name
4. Click the green checkmark to accept
5. Friendship is created in both directions

### Step 6: Verify Friendships

Check the `friendships` table:

```sql
SELECT user_id_1, user_id_2, created_at
FROM friendships
ORDER BY created_at DESC;
```

You should see two entries (bidirectional):
| user_id_1 | user_id_2 | created_at |
|-----------|-----------|------------|
| abc123 | xyz789 | 2025-10-19 |
| xyz789 | abc123 | 2025-10-19 |

### Step 7: Chat with Friend

**Either User:**
1. Go to Profile screen
2. Click "Friends"
3. You should see your friend listed
4. Click the chat icon next to their name
5. Start messaging!

## Common Issues

### Issue 1: "No pending friend requests" but request was sent

**Cause**: Receiver hasn't created their profile in Supabase yet.

**Fix**: 
- Receiver must go to Profile screen and create/save their profile first
- Then the friend request will appear

### Issue 2: User not appearing in search results

**Causes**:
- User hasn't created profile in Supabase
- Search query doesn't match first or last name
- Database hasn't synced yet

**Fix**:
- Ensure user has created profile
- Try searching with different terms
- Refresh the search

### Issue 3: "Failed to send friend request" error

**Causes**:
- Trying to send to yourself
- Already sent a request to this user
- Network/database error

**Fix**:
- Can't send friend requests to yourself
- Check if request already exists
- Try again or check network connection

### Issue 4: Friend request sent but sender's name shows as email

**Cause**: Sender's profile isn't fully loaded when displaying the request.

**Fix**: This is cosmetic - the request still works. The name should load after a moment.

## Testing the Full Flow

### Test with Two Accounts

1. **Create Account 1**
   ```
   Email: test1@example.com
   Password: Test123!
   ```

2. **Create Profile 1**
   ```
   First Name: Alice
   Last Name: Smith
   Street: 123 Main St
   State: CA
   Zip: 90210
   Phone: 555-0001
   ```

3. **Create Account 2 (different browser/incognito)**
   ```
   Email: test2@example.com
   Password: Test123!
   ```

4. **Create Profile 2**
   ```
   First Name: Bob
   Last Name: Johnson
   Street: 456 Oak Ave
   State: NY
   Zip: 10001
   Phone: 555-0002
   ```

5. **From Account 1:**
   - Search for "Bob"
   - Send friend request

6. **From Account 2:**
   - View Friend Requests
   - Accept Alice's request

7. **From Either Account:**
   - Go to Friends
   - Start chat
   - Send messages

## Database Schema Reference

### profiles table
```sql
CREATE TABLE profiles (
  user_id TEXT PRIMARY KEY,  -- Firebase Auth UID
  email TEXT UNIQUE NOT NULL,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  street TEXT,
  zip TEXT,
  state TEXT,
  phone TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### friend_requests table
```sql
CREATE TABLE friend_requests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  sender_id TEXT NOT NULL,      -- Supabase profile user_id
  sender_email TEXT NOT NULL,
  receiver_id TEXT NOT NULL,     -- Supabase profile user_id
  receiver_email TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### friendships table
```sql
CREATE TABLE friendships (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id_1 TEXT NOT NULL,      -- Bidirectional relationships
  user_id_2 TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id_1, user_id_2)
);
```

## Quick Debug Checklist

- [ ] Both users have signed in to Firebase Auth
- [ ] Both users have created profiles in Supabase
- [ ] Profiles table has entries for both users
- [ ] user_id in profiles matches Firebase Auth UID
- [ ] Search returns the target user
- [ ] Friend request is stored in friend_requests table
- [ ] Receiver's user_id matches the receiver_id in friend_requests
- [ ] Friend Requests screen is querying with correct user_id
- [ ] RLS policies allow reading friend requests

## Support

If you're still experiencing issues after following this guide:

1. Check Supabase logs for errors
2. Verify RLS policies are correct
3. Ensure both users are authenticated
4. Clear app cache and retry
5. Check network connectivity

Remember: **Both users MUST create their profiles in Supabase before using social features!**
