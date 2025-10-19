# 🔐 Environment Variables Setup Guide

This guide explains how to set up your `.env` file for the AnimeVerse application.

## 📋 Overview

The `.env` file stores sensitive configuration values like API keys, database URLs, and other secrets. This file is **gitignored** to prevent accidental exposure of credentials.

## 🚀 Quick Setup

### Step 1: Create .env File

A template `.env` file has been created in the project root. You need to replace the placeholder values with your actual credentials.

### Step 2: Get Your Credentials

#### **Supabase Configuration** (Required)

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project: `alehkfzvhjhrtukqlqmt`
3. Navigate to **Settings** → **API**
4. Copy the following values:
   - **Project URL** → `SUPABASE_URL`
   - **anon/public key** → `SUPABASE_ANON_KEY`
   - **service_role key** → `SUPABASE_SERVICE_KEY` (⚠️ Keep this secret!)

#### **Firebase Configuration** (Required)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Project Settings** → **General**
4. Scroll to "Your apps" section
5. Copy the config values:
   ```javascript
   apiKey: "..." → FIREBASE_API_KEY
   authDomain: "..." → FIREBASE_AUTH_DOMAIN
   projectId: "..." → FIREBASE_PROJECT_ID
   storageBucket: "..." → FIREBASE_STORAGE_BUCKET
   messagingSenderId: "..." → FIREBASE_MESSAGING_SENDER_ID
   appId: "..." → FIREBASE_APP_ID
   ```

#### **OpenAI API** (Optional - for chatbot)

1. Go to [OpenAI Platform](https://platform.openai.com/)
2. Navigate to **API Keys**
3. Create a new secret key
4. Copy to `OPENAI_API_KEY`

### Step 3: Update .env File

Open `.env` and replace all placeholder values:

```env
# Firebase Configuration
FIREBASE_API_KEY=AIzaSyC_your_actual_api_key_here
FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-project.appspot.com
FIREBASE_MESSAGING_SENDER_ID=123456789
FIREBASE_APP_ID=1:123456789:web:abcdef123456

# Supabase Configuration
SUPABASE_URL=https://alehkfzvhjhrtukqlqmt.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# OpenAI API (for chatbot)
OPENAI_API_KEY=sk-your-openai-api-key-here
```

### Step 4: Run Flutter Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

## ⚠️ Important Security Notes

### 🔴 NEVER commit these files to Git:
- `.env` (already in `.gitignore`)
- `firebase_options.dart`
- `google-services.json`
- `GoogleService-Info.plist`

### 🟡 Service Role Key Warning

The `SUPABASE_SERVICE_KEY` bypasses ALL Row Level Security policies. 

**For Development/Testing:**
- ✅ Use service_role key to bypass RLS issues
- ✅ Faster development and testing

**For Production:**
- ❌ Never use service_role key in client apps
- ✅ Use anon key with proper RLS policies
- ✅ Move service_role key to backend/server

### 🟢 Current Setup

The app currently uses:
- Service role key (if available) for development
- Falls back to anon key if service key not set

## 🔧 Troubleshooting

### Issue 1: "Environment variable not found"

**Solution**: Make sure `.env` file exists in project root and contains all required variables.

```bash
# Check if .env exists
ls -la .env

# Verify contents
cat .env
```

### Issue 2: "Failed to load .env file"

**Solution**: Ensure `.env` is listed in `pubspec.yaml` assets:

```yaml
flutter:
  assets:
    - .env  # Must be here!
```

### Issue 3: Supabase RLS errors

**Solution**: 
1. Add your service_role key to `.env`
2. OR disable RLS temporarily (see `SUPABASE_FIX_GUIDE.md`)
3. OR update RLS policies (see `QUICK_FIX_RLS.sql`)

### Issue 4: Values not updating

**Solution**: After changing `.env`, you must:

```bash
# Stop the app
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Rebuild and run
flutter run
```

## 📁 File Structure

```
animeverse/
├── .env                          # ← Your credentials (gitignored)
├── .env.example                  # ← Template (optional, can commit)
├── .gitignore                    # ← Contains .env
├── lib/
│   ├── core/
│   │   └── config/
│   │       ├── env_config.dart   # ← Loads .env variables
│   │       └── supabase_config.dart # ← Uses env variables
│   └── main.dart                 # ← Loads env on startup
└── pubspec.yaml                  # ← Includes .env in assets
```

## 🎯 Testing Configuration

After setup, run the app and check the console output:

```bash
flutter run
```

You should see:

```
🔧 Loading environment variables...
📋 Environment Configuration:
   Supabase URL: ✓ Set
   Supabase Anon Key: ✓ Set
   Supabase Service Key: ✓ Set
   Firebase API Key: ✓ Set
   OpenAI API Key: ✓ Set
🔥 Initializing Firebase...
✅ Firebase initialized successfully
📊 Initializing Supabase...
✅ Supabase initialized successfully
🚀 Starting AnimeVerse...
```

If you see `✗ Missing` for required fields, update your `.env` file.

## 🌍 Multiple Environments (Optional)

You can create multiple `.env` files for different environments:

```
.env.development  # Development
.env.staging      # Staging
.env.production   # Production
```

Then update `EnvConfig.load()` to specify which file to use.

## 📞 Support

If you encounter issues:

1. Check `.env` file exists and has correct values
2. Verify all required variables are set
3. Run `flutter clean && flutter pub get`
4. Check console for error messages
5. Review `SUPABASE_FIX_GUIDE.md` for database issues

---

**Remember**: Keep your `.env` file secret and NEVER commit it to version control! 🔒
