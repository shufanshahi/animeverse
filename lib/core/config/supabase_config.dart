import '../config/env_config.dart';

/// Supabase Configuration
/// This file uses environment variables from .env file
/// DO NOT hardcode sensitive keys here!
class SupabaseConfig {
  // Private constructor to prevent instantiation
  SupabaseConfig._();
  
  /// Supabase project URL
  static String get supabaseUrl => EnvConfig.supabaseUrl;
  
  /// Supabase anon (public) key
  /// Safe to use in client apps but has RLS restrictions
  static String get supabaseAnonKey => EnvConfig.supabaseAnonKey;
  
  /// Supabase service role key
  /// ⚠️ IMPORTANT: This key bypasses ALL Row Level Security!
  /// Only use this for backend operations or development/testing
  /// NEVER expose this key in production client apps
  static String get supabaseServiceKey => EnvConfig.supabaseServiceKey;
  
  /// Get the appropriate key based on environment
  /// For production client apps, always use anon key
  /// For development/testing, you can use service key
  static String get apiKey {
    // Use service key if available, otherwise fall back to anon key
    // In production, you should ONLY use anon key in client apps
    return supabaseServiceKey.isNotEmpty ? supabaseServiceKey : supabaseAnonKey;
  }
  
  /// Print configuration status (for debugging)
  static void printConfig() {
    print('📊 Supabase Configuration:');
    print('   URL: $supabaseUrl');
    print('   Anon Key: ${supabaseAnonKey.isNotEmpty ? "✓ Set (${supabaseAnonKey.length} chars)" : "✗ Missing"}');
    print('   Service Key: ${supabaseServiceKey.isNotEmpty ? "✓ Set (${supabaseServiceKey.length} chars)" : "✗ Missing"}');
  }
}
