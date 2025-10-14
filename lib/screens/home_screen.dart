// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/app_provider.dart';
// import '../l10n/app_localizations.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final appProvider = Provider.of<AppProvider>(context);
//     final localizations = AppLocalizations.of(context)!;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(localizations.appTitle),
//         elevation: 0,
//         actions: [
//           // Language Switcher
//           IconButton(
//             icon: const Icon(Icons.language),
//             onPressed: () => appProvider.toggleLanguage(),
//             tooltip: localizations.language,
//           ),
//           // Theme Switcher
//           IconButton(
//             icon: Icon(appProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
//             onPressed: () => appProvider.toggleTheme(),
//             tooltip: appProvider.isDarkMode ? localizations.lightMode : localizations.darkMode,
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // =========================
//               // Welcome Section
//               // =========================
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       colorScheme.primary.withValues(alpha: 0.9),
//                       colorScheme.secondary.withValues(alpha: 0.9),
//                     ],
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       localizations.welcomeTitle,
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       localizations.welcomeSubtitle,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // =========================
//               // Trending Section
//               // =========================
//               Text(
//                 localizations.trendingNow,
//                 style: theme.textTheme.displayMedium,
//               ),
//               const SizedBox(height: 12),
//               SizedBox(
//                 height: 180,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 5,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                       onTap: () {
//                         // Navigate to anime details with different trending anime IDs
//                         final trendingAnimeIds = [5114, 11757, 37779, 43608, 50172]; // Different trending anime
//                         context.go('/anime/${trendingAnimeIds[index]}');
//                       },
//                       child: Container(
//                         width: 120,
//                         margin: const EdgeInsets.only(right: 12),
//                         decoration: BoxDecoration(
//                           color: colorScheme.primaryContainer,
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                             color: colorScheme.outline,
//                           ),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.play_circle,
//                               size: 40,
//                               color: colorScheme.primary,
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Anime ${index + 1}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // =========================
//               // Popular Section
//               // =========================
//               Text(
//                 localizations.popular,
//                 style: theme.textTheme.displayMedium,
//               ),
//               const SizedBox(height: 12),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: 3,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 12),
//                     child: ListTile(
//                       leading: Container(
//                         width: 50,
//                         decoration: BoxDecoration(
//                           color: colorScheme.primary.withValues(alpha: 0.15),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Icon(
//                           Icons.image,
//                           color: colorScheme.primary,
//                         ),
//                       ),
//                       title: Text(
//                         'Anime Title ${index + 1}',
//                         style: theme.textTheme.bodyLarge,
//                       ),
//                       subtitle: const Text('Rating: 9.5/10'),
//                       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                       onTap: () {
//                         // Navigate to anime details with sample anime IDs
//                         final animeIds = [1, 20, 16498, 38524, 40748]; // Popular anime IDs
//                         context.go('/anime/${animeIds[index]}');
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: 0,
//         type: BottomNavigationBarType.fixed,
//         onTap: (_) {},
//         selectedItemColor: colorScheme.primary,
//         unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
//         backgroundColor: colorScheme.surface,
//         items: [
//           BottomNavigationBarItem(icon: const Icon(Icons.home), label: localizations.home),
//           BottomNavigationBarItem(icon: const Icon(Icons.search), label: localizations.search),
//           BottomNavigationBarItem(icon: const Icon(Icons.bookmark), label: localizations.watchlist),
//           BottomNavigationBarItem(icon: const Icon(Icons.person), label: localizations.profile),
//         ],
//       ),
//     );
//   }
// }