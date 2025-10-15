import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../providers/home_provider.dart';
import '../widgets/widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load home data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(homeProvider.notifier).loadHomeData();
      }
    });
  }

  void _onGenreSelected(String genre) {
    final homeNotifier = ref.read(homeProvider.notifier);
    if (ref.read(homeProvider).selectedGenres.contains(genre)) {
      homeNotifier.clearGenreSelection();
    } else {
      homeNotifier.loadAnimeByGenre(genre);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    final lang = locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.translate('app_title', lang)),
        elevation: 0,
        actions: [
          // Language Switcher
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => ref.read(localeProvider.notifier).toggleLanguage(),
            tooltip: AppLocalizations.translate('language', lang),
          ),
          // Theme Switcher
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
            tooltip: themeMode == ThemeMode.dark ? 'Light Mode' : 'Dark Mode',
          ),
        ],
      ),
      body: homeState.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    homeState.error!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => ref.read(homeProvider.notifier).loadHomeData(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            )
          : homeState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async {
                    ref.read(homeProvider.notifier).loadHomeData();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Anime Carousel
                          if (homeState.topAnime.isNotEmpty) ...[
                            AnimeCarousel(
                              animeList: homeState.topAnime,
                              title: AppLocalizations.translate('featured_anime', lang),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Genre Selection
                          GenreChips(
                            selectedGenres: homeState.selectedGenres,
                            onGenreSelected: _onGenreSelected,
                          ),
                          const SizedBox(height: 24),

                          // Genre-based Anime
                          if (homeState.selectedGenres.isNotEmpty) ...[
                            Text(
                              '${homeState.selectedGenres.first} Anime',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            AnimeList(
                              animeList: homeState.genreAnime,
                              title: '${homeState.selectedGenres.first} Anime',
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Currently Airing
                          if (homeState.airingAnime.isNotEmpty) ...[
                            Text(
                              AppLocalizations.translate('currently_airing', lang),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            AnimeList(
                              animeList: homeState.airingAnime,
                              title: AppLocalizations.translate('currently_airing', lang),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Seasonal Anime
                          if (homeState.seasonalAnime.isNotEmpty) ...[
                            Text(
                              AppLocalizations.translate('seasonal_anime', lang),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            AnimeList(
                              animeList: homeState.seasonalAnime,
                              title: AppLocalizations.translate('seasonal_anime', lang),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Top Anime
                          if (homeState.topAnime.isNotEmpty) ...[
                            Text(
                              AppLocalizations.translate('top_anime', lang),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            AnimeList(
                              animeList: homeState.topAnime,
                              title: AppLocalizations.translate('top_anime', lang),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}