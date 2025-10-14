import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/app_provider.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _selectedGenres = [];

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const LoadHomeData());
  }

  void _onGenreSelected(String genre) {
    setState(() {
      if (_selectedGenres.contains(genre)) {
        _selectedGenres.remove(genre);
      } else {
        _selectedGenres.clear();
        _selectedGenres.add(genre);
        context.read<HomeBloc>().add(LoadAnimeByGenre(genre: genre));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appProvider = Provider.of<AppProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        elevation: 0,
        actions: [
          // Language Switcher
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => appProvider.toggleLanguage(),
            tooltip: localizations.language,
          ),
          // Theme Switcher
          IconButton(
            icon: Icon(appProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => appProvider.toggleTheme(),
            tooltip: appProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
          ),
        ],
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is HomeError) {
            return Center(
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
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(const RefreshHomeData());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(const RefreshHomeData());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Featured Carousel
                    if (state.topAnime.isNotEmpty) ...[
                      AnimeCarousel(
                        animeList: state.topAnime,
                        title: 'Featured Anime',
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Genre Selection
                    GenreChips(
                      selectedGenres: _selectedGenres,
                      onGenreSelected: _onGenreSelected,
                    ),
                    const SizedBox(height: 16),

                    // Genre-based Anime Lists
                    if (_selectedGenres.isNotEmpty) ...[
                      for (final genre in _selectedGenres)
                        if (state.genreAnime.containsKey(genre)) ...[
                          AnimeList(
                            animeList: state.genreAnime[genre]!,
                            title: '$genre Anime',
                            isLoading: state.genreLoading[genre] ?? false,
                            onLoadMore: () {
                              final currentPage = state.genrePages[genre] ?? 1;
                              context.read<HomeBloc>().add(
                                LoadMoreAnimeByGenre(
                                  genre: genre,
                                  page: currentPage + 1,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                    ],

                    // Currently Airing
                    if (state.airingAnime.isNotEmpty) ...[
                      AnimeList(
                        animeList: state.airingAnime,
                        title: 'Currently Airing',
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Seasonal Anime
                    if (state.seasonalAnime.isNotEmpty) ...[
                      AnimeList(
                        animeList: state.seasonalAnime,
                        title: 'This Season',
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Top Anime List
                    if (state.topAnime.isNotEmpty) ...[
                      AnimeList(
                        animeList: state.topAnime,
                        title: 'Top Rated',
                      ),
                      const SizedBox(height: 32),
                    ],
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}