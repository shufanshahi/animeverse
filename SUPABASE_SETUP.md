# Supabase Setup for Anime Wishlist Feature

## ⚠️ IMPORTANT: Read This First!

This setup uses **email-based user identification** instead of Firebase Auth UID.

---

## Step 1: Create a Supabase Project (2 minutes)

1. Go to https://supabase.com/
2. Sign up or log in to your account
3. Click **"New Project"**
4. Fill in the details:
   - **Name**: anime-verse (or your preferred name)
   - **Database Password**: Create a strong password (save it!)
   - **Region**: Choose the closest to your users
5. Click **"Create new project"**
6. Wait for the project to initialize (takes ~2 minutes)

---

## Step 2: Get Your Supabase Credentials (30 seconds)

1. Once the project is ready, go to **Settings** → **API**
2. Copy the following:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon/public key**: `eyJhbGciOiJIUzI1...` (long string)

---

## Step 3: Update Your Flutter App Configuration

Open `lib/core/config/supabase_config.dart` and replace the placeholders:

```dart
static const String supabaseUrl = 'YOUR_PROJECT_URL_HERE';
static const String supabaseAnonKey = 'YOUR_ANON_KEY_HERE';
```

---

## Step 4: Create the Wishlists Table (IMPORTANT!)

1. In Supabase Dashboard, go to **SQL Editor**
2. Click **"New Query"**
3. Copy and paste the following SQL:

```sql
-- Create wishlists table with email-based user identification
CREATE TABLE IF NOT EXISTS wishlists (
  id BIGSERIAL PRIMARY KEY,
  user_email TEXT NOT NULL,
  anime_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  image_url TEXT,
  score DOUBLE PRECISION,
  type TEXT,
  episodes INTEGER,
  added_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT unique_user_anime UNIQUE(user_email, anime_id)
);

-- Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_wishlists_user_email ON wishlists(user_email);
CREATE INDEX IF NOT EXISTS idx_wishlists_added_at ON wishlists(added_at DESC);
CREATE INDEX IF NOT EXISTS idx_wishlists_user_anime ON wishlists(user_email, anime_id);

-- Enable Row Level Security (RLS)
ALTER TABLE wishlists ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own wishlists" ON wishlists;
DROP POLICY IF EXISTS "Users can insert their own wishlists" ON wishlists;
DROP POLICY IF EXISTS "Users can update their own wishlists" ON wishlists;
DROP POLICY IF EXISTS "Users can delete their own wishlists" ON wishlists;
DROP POLICY IF EXISTS "Users manage own wishlists" ON wishlists;

-- Create policy: Allow all operations without auth (since we're using email)
-- In production, you should secure this better!
CREATE POLICY "Allow all operations for wishlists"
  ON wishlists
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- Enable Realtime for the table (optional, for live updates)
ALTER PUBLICATION supabase_realtime ADD TABLE wishlists;
```

4. Click **"Run"** to execute the SQL
5. You should see **"Success. No rows returned"**

---

## Step 5: Verify the Table Structure

1. Go to **Table Editor** in Supabase Dashboard
2. You should see the `wishlists` table
3. Click on it to verify the structure:
   - `id` (bigint, primary key, auto-increment)
   - `user_email` (text) - **Stores user's email**
   - `anime_id` (integer)
   - `title` (text)
   - `image_url` (text, nullable)
   - `score` (double precision, nullable)
   - `type` (text, nullable)
   - `episodes` (integer, nullable)
   - `added_at` (timestamp with timezone)

---

## Step 6: How It Works

### User Identification
- When a user logs in with Firebase Auth, their **email** is extracted
- This email is used as the identifier in all wishlist operations
- Each user's wishlist is isolated by their email address

### Data Flow
1. User logs in → Email is stored
2. User adds anime to wishlist → Saved with their email
3. User views wishlist → Filtered by their email
4. User closes app → Data persists in Supabase
5. User reopens app → Wishlist is loaded by email

---

## Step 7: Test the Integration

Run your Flutter app:

```bash
flutter run
```

### Testing Steps:
1. **Login** with an email account (e.g., test@example.com)
2. **Navigate** to an anime details page
3. **Click** the wishlist/bookmark button (outline icon)
4. The icon should fill and show "Added to wishlist"
5. **Go to Supabase Dashboard** → **Table Editor** → **wishlists**
6. You should see an entry with your email!
7. **Close the app** completely
8. **Restart** and login with the **same email**
9. Your wishlist should load automatically! 🎉

---

## Troubleshooting

### Error: "relation 'wishlists' does not exist"
- Make sure you ran the SQL in Step 4
- Check the SQL Editor for any errors
- Verify the table exists in Table Editor

### Error: "null is not a subtype of String"
- Make sure the user is logged in
- Check that the email is being extracted from Firebase Auth
- Look at Flutter console for detailed error messages

### Data not showing after restart
1. Check Supabase Dashboard → Table Editor → wishlists
2. Verify data is being saved with correct email
3. Check Flutter console for error messages
4. Make sure you're logging in with the **same email**

### "No user email found"
- User must be logged in with Firebase Auth
- Firebase Auth must return a valid email
- Check the auth provider is properly set up

---

## Security Considerations

### Current Setup (Development)
- The current RLS policy allows **all operations** for simplicity
- This is fine for development but **NOT for production**

### Production Security (Recommended)
For production, you should:
1. Use Firebase Auth tokens with Supabase Auth
2. Implement proper RLS policies based on authenticated users
3. Validate email addresses server-side

Example production RLS policy:
```sql
-- For production, use this instead:
CREATE POLICY "Users can only access their own wishlists"
  ON wishlists
  FOR ALL
  USING (user_email = current_setting('request.jwt.claims', true)::json->>'email');
```

---

## Database Schema Details

### Table: `wishlists`

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| id | BIGSERIAL | Auto-incrementing ID | PRIMARY KEY |
| user_email | TEXT | User's email address | NOT NULL |
| anime_id | INTEGER | MyAnimeList anime ID | NOT NULL |
| title | TEXT | Anime title | NOT NULL |
| image_url | TEXT | Cover image URL | NULLABLE |
| score | DOUBLE PRECISION | Anime rating (0-10) | NULLABLE |
| type | TEXT | TV, Movie, OVA, etc. | NULLABLE |
| episodes | INTEGER | Number of episodes | NULLABLE |
| added_at | TIMESTAMPTZ | When added | DEFAULT NOW() |

### Constraints:
- **UNIQUE(user_email, anime_id)** - Prevents duplicate entries
- User can't add the same anime twice

### Indexes:
- `idx_wishlists_user_email` - Fast filtering by email
- `idx_wishlists_added_at` - Sorted by newest first
- `idx_wishlists_user_anime` - Fast lookup for checking if anime is in wishlist

---

## Next Steps

Once everything is working:
1. ✅ Verify data persists after app restart
2. ✅ Test with multiple user accounts
3. ✅ Each user should see only their own wishlist
4. 🔒 Consider implementing proper authentication for production
5. 📊 Monitor usage in Supabase Dashboard

---

## Support

If you encounter issues:
1. Check Supabase Dashboard → **Logs** for database errors
2. Check Flutter console for application errors
3. Verify your Supabase credentials are correct
4. Make sure the table was created successfully
5. Check that the user is logged in before adding to wishlist

---

**Happy coding! 🚀**
