import 'package:flutter/material.dart';
import '/config/theme/app_theme.dart'; // ✅ import your custom theme folder

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimeHub',
      debugShowCheckedModeBanner: false,

      // ✅ Use your new theme setup
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: HomeScreen(
        isDarkMode: isDarkMode,
        onThemeChanged: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const HomeScreen({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimeHub'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => onThemeChanged(!isDarkMode),
            tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // Welcome Section
              // =========================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary.withOpacity(0.9),
                      colorScheme.secondary.withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to AnimeHub',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your anime discovery platform',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // Trending Section
              // =========================
              Text(
                'Trending Now',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.outline),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle,
                            size: 40,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Anime ${index + 1}',
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // Popular Section
              // =========================
              Text(
                'Popular',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.image,
                          color: colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        'Anime Title ${index + 1}',
                        style: theme.textTheme.bodyLarge,
                      ),
                      subtitle: const Text('Rating: 9.5/10'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Tapped on Anime ${index + 1}'),
                            backgroundColor: colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (_) {},
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        backgroundColor: colorScheme.surface,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Watchlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
