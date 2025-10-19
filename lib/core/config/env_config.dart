import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration class that loads values from .env file
/// This keeps sensitive API keys and URLs secure and out of version control
class EnvConfig {
  // Private constructor to prevent instantiation
  EnvConfig._();

  /// Load environment variables from .env file
  /// Call this in main() before runApp()
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  // Firebase Configuration (Web/Default)
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
  static String get firebaseAuthDomain => dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '';
  static String get firebaseProjectId => dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
  static String get firebaseStorageBucket => dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';
  static String get firebaseMessagingSenderId => dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseAppId => dotenv.env['FIREBASE_APP_ID'] ?? '';

  // Firebase Android
  static String get firebaseAndroidApiKey => dotenv.env['FIREBASE_ANDROID_API_KEY'] ?? firebaseApiKey;
  static String get firebaseAndroidAppId => dotenv.env['FIREBASE_ANDROID_APP_ID'] ?? '';

  // Firebase iOS
  static String get firebaseIosApiKey => dotenv.env['FIREBASE_IOS_API_KEY'] ?? '';
  static String get firebaseIosAppId => dotenv.env['FIREBASE_IOS_APP_ID'] ?? '';
  static String get firebaseIosBundleId => dotenv.env['FIREBASE_IOS_BUNDLE_ID'] ?? '';

  // Firebase macOS
  static String get firebaseMacosAppId => dotenv.env['FIREBASE_MACOS_APP_ID'] ?? '';
  static String get firebaseMacosBundleId => dotenv.env['FIREBASE_MACOS_BUNDLE_ID'] ?? '';

  // Firebase Windows
  static String get firebaseWindowsAppId => dotenv.env['FIREBASE_WINDOWS_APP_ID'] ?? '';
  static String get firebaseWindowsMeasurementId => dotenv.env['FIREBASE_WINDOWS_MEASUREMENT_ID'] ?? '';

  // Supabase Configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get supabaseServiceKey => dotenv.env['SUPABASE_SERVICE_KEY'] ?? '';

  // Jikan API Configuration
  static String get jikanApiBaseUrl => dotenv.env['JIKAN_API_BASE_URL'] ?? 'https://api.jikan.moe/v4';

  // OpenAI API Configuration
  static String get openAiApiKey => dotenv.env['OPENAI_API_KEY'] ?? '';

  // App Configuration
  static String get appName => dotenv.env['APP_NAME'] ?? 'AnimeVerse';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';

  /// Validate that all required environment variables are set
  static bool validate() {
    final requiredVars = [
      'FIREBASE_API_KEY',
      'FIREBASE_PROJECT_ID',
      'SUPABASE_URL',
      'SUPABASE_ANON_KEY',
    ];

    for (final varName in requiredVars) {
      if (dotenv.env[varName] == null || dotenv.env[varName]!.isEmpty) {
        print('⚠️ WARNING: $varName is not set in .env file');
        return false;
      }
    }

    return true;
  }

  /// Print configuration status (for debugging)
  static void printStatus() {
    print('📋 Environment Configuration:');
    print('   Firebase Project: ${firebaseProjectId.isNotEmpty ? "✓ Set" : "✗ Missing"}');
    print('   Firebase API Key: ${firebaseApiKey.isNotEmpty ? "✓ Set" : "✗ Missing"}');
    print('   Supabase URL: ${supabaseUrl.isNotEmpty ? "✓ Set" : "✗ Missing"}');
    print('   Supabase Anon Key: ${supabaseAnonKey.isNotEmpty ? "✓ Set" : "✗ Missing"}');
    print('   Supabase Service Key: ${supabaseServiceKey.isNotEmpty ? "✓ Set" : "✗ Missing"}');
    print('   OpenAI API Key: ${openAiApiKey.isNotEmpty ? "✓ Set" : "✗ Missing"}');
  }
}
