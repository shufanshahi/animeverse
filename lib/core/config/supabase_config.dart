// Supabase Configuration
// DO NOT commit this file with real credentials to version control
// Add this file to .gitignore

class SupabaseConfig {
  // Get these values from your Supabase project dashboard
  // Settings → API
  
  static const String supabaseUrl = 'https://alehkfzvhjhrtukqlqmt.supabase.co';
  
  // IMPORTANT: Use service_role key for backend operations to bypass RLS
  // Get this from: Supabase Dashboard → Settings → API → service_role key (secret)
  // NEVER expose service_role key in client-side code - only for server/backend
  static const String supabaseServiceKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFsZWhrZnp2aGpocnR1a3FscW10Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDQ0MzkwNSwiZXhwIjoyMDc2MDE5OTA1fQ.OqT4CeUF6P0IL2zKk8X3F2zzF6JgdX2gfTknUzEj65A';
  
  // Anon key (public key) - safe to use in client apps but has RLS restrictions
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFsZWhrZnp2aGpocnR1a3FscW10Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA0NDM5MDUsImV4cCI6MjA3NjAxOTkwNX0.IqrjKUaXvkm2cSAFrg00FcRDL2CP581mCP951zPh6Ww';
  
  // For development/testing with Firebase Auth + Supabase:
  // Option 1: Use service_role key (bypasses RLS) - RECOMMENDED for this setup
  // Option 2: Keep anon key but ensure RLS policies allow authenticated users
}
