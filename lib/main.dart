import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'injection_container.dart' as di;
import 'config/theme/app_theme.dart';
import 'config/routes/app_router.dart';
import 'providers/app_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp.router(
            title: 'AnimeHub',
            debugShowCheckedModeBanner: false,
            
            // Localization setup
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('bn'),
            ],
            locale: appProvider.locale,

            // Theme setup
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: appProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            // Router setup
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}

