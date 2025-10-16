import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  final _searchController = TextEditingController();
  bool _showSearchBar = false;

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onGenreSelected(String genre) {
    final homeNotifier = ref.read(homeProvider.notifier);
    if (ref.read(homeProvider).selectedGenres.contains(genre)) {
      homeNotifier.clearGenreSelection();
    } else {
      homeNotifier.loadAnimeByGenre(genre);
    }
  }

  void _submitSearch() {
    final q = _searchController.text.trim();
    if (q.isEmpty) return;
    context.push('/search?q=${Uri.encodeComponent(q)}');
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
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
        actions: [
          // Wishlist button
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            tooltip: 'Wishlist',
            onPressed: () => context.push('/wishlist'),
          ),
          // Search toggle
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
              });
            },
          ),
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
        bottom: _showSearchBar
            ? PreferredSize(
                preferredSize: const Size.fromHeight(52),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search anime...',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            isDense: true,
                            prefixIcon: const Icon(Icons.search),
                          ),
                          onSubmitted: (_) => _submitSearch(),
                          textInputAction: TextInputAction.search,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _submitSearch,
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: const Text('Go'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : null,
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