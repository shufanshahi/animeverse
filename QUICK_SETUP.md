# Quick Setup Guide - Supabase Wishlist

## 🚀 Quick Start (5 minutes)

### Step 1: Create Supabase Project
1. Visit https://supabase.com/dashboard
2. Click "New Project"
3. Copy your **URL** and **anon key** from Settings → API

### Step 2: Update Configuration
Edit `lib/core/config/supabase_config.dart`:
```dart
static const String supabaseUrl = 'https://your-project.supabase.co';
static const String supabaseAnonKey = 'your-anon-key-here';
```

### Step 3: Create Database Table
In Supabase Dashboard → SQL Editor, run this:

```sql
CREATE TABLE wishlists (
  id BIGSERIAL PRIMARY KEY,
  user_id TEXT NOT NULL,
  anime_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  image_url TEXT,
  score DOUBLE PRECISION,
  type TEXT,
  episodes INTEGER,
  added_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, anime_id)
);

CREATE INDEX idx_wishlists_user_id ON wishlists(user_id);
CREATE INDEX idx_wishlists_added_at ON wishlists(added_at DESC);

ALTER TABLE wishlists ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage own wishlists"
  ON wishlists FOR ALL
  USING (user_id = auth.uid()::text);
```

### Step 4: Run Your App
```bash
flutter run
```

## ✅ Features

- ✨ Add anime to wishlist from details page
- 🗑️ Remove anime from wishlist (toggle button)
- 📋 View all wishlisted anime
- 🔒 User-specific (each user sees only their data)
- 💾 Data persists across app restarts
- 🔄 Real-time updates support

## 🎯 Usage

1. **Add to Wishlist**: Click bookmark icon on anime detail page
2. **Remove from Wishlist**: Click filled bookmark icon again
3. **View Wishlist**: Click bookmark icon in home screen app bar
4. **Delete Item**: Click bookmark icon on wishlist item

## 📁 Project Structure

```
lib/features/anime_wishlist/
├── data/
│   ├── datasources/
│   │   └── anime_wishlist_data_source.dart (Supabase queries)
│   ├── models/
│   │   └── anime_wishlist_model.dart (JSON serialization)
│   └── repositories/
│       └── anime_wishlist_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── anime_wishlist.dart
│   ├── repositories/
│   │   └── anime_wishlist_repository.dart
│   └── usecases/
│       ├── add_to_wishlist.dart
│       ├── remove_from_wishlist.dart
│       ├── get_user_wishlist.dart
│       └── is_in_wishlist.dart
└── presentation/
    ├── providers/
    │   └── anime_wishlist_provider.dart (Riverpod state)
    └── screens/
        └── anime_wishlist_screen.dart
```

## 🔍 Troubleshooting

**App crashes on startup?**
- Check if Supabase URL and key are correct
- Make sure table is created in Supabase

**Wishlist is empty after restart?**
- Verify data exists in Supabase Dashboard → Table Editor
- Check RLS policies are enabled
- Ensure you're logged in with the same Firebase Auth account

**Can't add items?**
- Check Flutter console for error messages
- Verify RLS policies match Firebase Auth UID
- Test the table directly in Supabase SQL Editor

## 🎉 That's it!

Your wishlist feature is now powered by Supabase with proper data persistence!
