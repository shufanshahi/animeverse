import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/routes/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/config/env_config.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Load environment variables from .env file
    print('🔧 Loading environment variables...');
    await EnvConfig.load();
    
    // 2. Validate environment configuration
    if (!EnvConfig.validate()) {
      print('⚠️ WARNING: Some environment variables are missing!');
      print('Please check your .env file and ensure all required values are set.');
    }
    
    // Print configuration status (only in debug mode)
    EnvConfig.printStatus();

    // 3. Initialize Firebase with options from firebase_options.dart
    print('🔥 Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');

    // 4. Initialize Supabase with environment variables
    print('📊 Initializing Supabase...');
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );
    print('✅ Supabase initialized successfully');

    // 5. Initialize dependency injection
    print('💉 Initializing dependencies...');
    await di.init();
    print('✅ Dependencies initialized successfully');

    // 6. Initialize SharedPreferences
    print('💾 Initializing SharedPreferences...');
    await SharedPreferences.getInstance();
    print('✅ SharedPreferences initialized successfully');

    print('🚀 Starting AnimeVerse...\n');

    // 7. Run the app
    runApp(const ProviderScope(child: MyApp()));
  } catch (e, stackTrace) {
    print('❌ Error during app initialization: $e');
    print('Stack trace: $stackTrace');
    
    // Show error screen
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to initialize app',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Please check:\n'
                    '1. .env file exists in project root\n'
                    '2. All required variables are set\n'
                    '3. Firebase is properly configured',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: EnvConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
    );
  }
}

