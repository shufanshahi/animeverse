import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/anime_entity.dart';
import '../../domain/usecases/get_airing_anime.dart';
import '../../domain/usecases/get_anime_by_genre.dart';
import '../../domain/usecases/get_seasonal_anime.dart';
import '../../domain/usecases/get_top_anime.dart';

// Use case providers
final getAiringAnimeProvider = Provider<GetAiringAnime>((ref) {
  try {
    return GetIt.instance<GetAiringAnime>();
  } catch (e) {
    throw StateError('GetAiringAnime not initialized. Did you call init()?');
  }
});

final getSeasonalAnimeProvider = Provider<GetSeasonalAnime>((ref) {
  try {
    return GetIt.instance<GetSeasonalAnime>();
  } catch (e) {
    throw StateError('GetSeasonalAnime not initialized. Did you call init()?');
  }
});

final getTopAnimeProvider = Provider<GetTopAnime>((ref) {
  try {
    return GetIt.instance<GetTopAnime>();
  } catch (e) {
    throw StateError('GetTopAnime not initialized. Did you call init()?');
  }
});

final getAnimeByGenreProvider = Provider<GetAnimeByGenre>((ref) {
  try {
    return GetIt.instance<GetAnimeByGenre>();
  } catch (e) {
    throw StateError('GetAnimeByGenre not initialized. Did you call init()?');
  }
});

// State notifier for managing home screen state
class HomeState {
  final List<AnimeEntity> airingAnime;
  final List<AnimeEntity> seasonalAnime;
  final List<AnimeEntity> topAnime;
  final List<AnimeEntity> genreAnime;
  final List<String> selectedGenres;
  final bool isLoading;
  final String? error;
  
  // Pagination state for each section
  final int airingPage;
  final int seasonalPage;
  final int topPage;
  final int genrePage;
  final bool isLoadingMoreAiring;
  final bool isLoadingMoreSeasonal;
  final bool isLoadingMoreTop;
  final bool isLoadingMoreGenre;

  HomeState({
    this.airingAnime = const [],
    this.seasonalAnime = const [],
    this.topAnime = const [],
    this.genreAnime = const [],
    this.selectedGenres = const [],
    this.isLoading = false,
    this.error,
    this.airingPage = 1,
    this.seasonalPage = 1,
    this.topPage = 1,
    this.genrePage = 1,
    this.isLoadingMoreAiring = false,
    this.isLoadingMoreSeasonal = false,
    this.isLoadingMoreTop = false,
    this.isLoadingMoreGenre = false,
  });

  HomeState copyWith({
    List<AnimeEntity>? airingAnime,
    List<AnimeEntity>? seasonalAnime,
    List<AnimeEntity>? topAnime,
    List<AnimeEntity>? genreAnime,
    List<String>? selectedGenres,
    bool? isLoading,
    String? error,
    int? airingPage,
    int? seasonalPage,
    int? topPage,
    int? genrePage,
    bool? isLoadingMoreAiring,
    bool? isLoadingMoreSeasonal,
    bool? isLoadingMoreTop,
    bool? isLoadingMoreGenre,
  }) {
    return HomeState(
      airingAnime: airingAnime ?? this.airingAnime,
      seasonalAnime: seasonalAnime ?? this.seasonalAnime,
      topAnime: topAnime ?? this.topAnime,
      genreAnime: genreAnime ?? this.genreAnime,
      selectedGenres: selectedGenres ?? this.selectedGenres,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      airingPage: airingPage ?? this.airingPage,
      seasonalPage: seasonalPage ?? this.seasonalPage,
      topPage: topPage ?? this.topPage,
      genrePage: genrePage ?? this.genrePage,
      isLoadingMoreAiring: isLoadingMoreAiring ?? this.isLoadingMoreAiring,
      isLoadingMoreSeasonal: isLoadingMoreSeasonal ?? this.isLoadingMoreSeasonal,
      isLoadingMoreTop: isLoadingMoreTop ?? this.isLoadingMoreTop,
      isLoadingMoreGenre: isLoadingMoreGenre ?? this.isLoadingMoreGenre,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final GetAiringAnime _getAiringAnime;
  final GetSeasonalAnime _getSeasonalAnime;
  final GetTopAnime _getTopAnime;
  final GetAnimeByGenre _getAnimeByGenre;

  HomeNotifier({
    required GetAiringAnime getAiringAnime,
    required GetSeasonalAnime getSeasonalAnime,
    required GetTopAnime getTopAnime,
    required GetAnimeByGenre getAnimeByGenre,
  })  : _getAiringAnime = getAiringAnime,
        _getSeasonalAnime = getSeasonalAnime,
        _getTopAnime = getTopAnime,
        _getAnimeByGenre = getAnimeByGenre,
        super(HomeState());

  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final airingResult = await _getAiringAnime(GetAiringAnimeParams(page: 1));
      final seasonalResult = await _getSeasonalAnime(GetSeasonalAnimeParams(
        year: DateTime.now().year.toString(),
        season: _getCurrentSeason(),
        page: 1,
      ));
      final topResult = await _getTopAnime(GetTopAnimeParams(page: 1));
      
      airingResult.fold(
        (failure) => state = state.copyWith(
          isLoading: false,
          error: _mapFailureToMessage(failure),
        ),
        (animeList) => state = state.copyWith(airingAnime: animeList),
      );

      seasonalResult.fold(
        (failure) => state = state.copyWith(
          error: _mapFailureToMessage(failure),
        ),
        (animeList) => state = state.copyWith(seasonalAnime: animeList),
      );

      topResult.fold(
        (failure) => state = state.copyWith(
          error: _mapFailureToMessage(failure),
        ),
        (animeList) => state = state.copyWith(topAnime: animeList),
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadAnimeByGenre(String genre) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      selectedGenres: [genre],
    );
    
    try {
      final result = await _getAnimeByGenre(GetAnimeByGenreParams(genre: genre, page: 1));
      result.fold(
        (failure) => state = state.copyWith(
          isLoading: false,
          error: _mapFailureToMessage(failure),
        ),
        (animeList) => state = state.copyWith(
          genreAnime: animeList,
          isLoading: false,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  String _getCurrentSeason() {
    final now = DateTime.now();
    final month = now.month;
    
    if (month >= 3 && month <= 5) {
      return 'spring';
    } else if (month >= 6 && month <= 8) {
      return 'summer';
    } else if (month >= 9 && month <= 11) {
      return 'fall';
    } else {
      return 'winter';
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Server Error';
      case NetworkFailure _:
        return 'Network Error';
      case CacheFailure _:
        return 'Cache Error';
      default:
        return 'Unexpected Error';
    }
  }

  void clearGenreSelection() {
    state = state.copyWith(
      selectedGenres: [],
      genreAnime: [],
      genrePage: 1,
    );
  }

  // Load more methods for each section
  Future<void> loadMoreAiringAnime() async {
    if (state.isLoadingMoreAiring) return;
    
    state = state.copyWith(isLoadingMoreAiring: true);
    
    try {
      final nextPage = state.airingPage + 1;
      final result = await _getAiringAnime(GetAiringAnimeParams(page: nextPage));
      
      result.fold(
        (failure) => state = state.copyWith(isLoadingMoreAiring: false),
        (animeList) => state = state.copyWith(
          airingAnime: [...state.airingAnime, ...animeList],
          airingPage: nextPage,
          isLoadingMoreAiring: false,
        ),
      );
    } catch (e) {
      state = state.copyWith(isLoadingMoreAiring: false);
    }
  }

  Future<void> loadMoreSeasonalAnime() async {
    if (state.isLoadingMoreSeasonal) return;
    
    state = state.copyWith(isLoadingMoreSeasonal: true);
    
    try {
      final nextPage = state.seasonalPage + 1;
      final result = await _getSeasonalAnime(GetSeasonalAnimeParams(
        year: DateTime.now().year.toString(),
        season: _getCurrentSeason(),
        page: nextPage,
      ));
      
      result.fold(
        (failure) => state = state.copyWith(isLoadingMoreSeasonal: false),
        (animeList) => state = state.copyWith(
          seasonalAnime: [...state.seasonalAnime, ...animeList],
          seasonalPage: nextPage,
          isLoadingMoreSeasonal: false,
        ),
      );
    } catch (e) {
      state = state.copyWith(isLoadingMoreSeasonal: false);
    }
  }

  Future<void> loadMoreTopAnime() async {
    if (state.isLoadingMoreTop) return;
    
    state = state.copyWith(isLoadingMoreTop: true);
    
    try {
      final nextPage = state.topPage + 1;
      final result = await _getTopAnime(GetTopAnimeParams(page: nextPage));
      
      result.fold(
        (failure) => state = state.copyWith(isLoadingMoreTop: false),
        (animeList) => state = state.copyWith(
          topAnime: [...state.topAnime, ...animeList],
          topPage: nextPage,
          isLoadingMoreTop: false,
        ),
      );
    } catch (e) {
      state = state.copyWith(isLoadingMoreTop: false);
    }
  }

  Future<void> loadMoreGenreAnime() async {
    if (state.isLoadingMoreGenre || state.selectedGenres.isEmpty) return;
    
    state = state.copyWith(isLoadingMoreGenre: true);
    
    try {
      final nextPage = state.genrePage + 1;
      final result = await _getAnimeByGenre(GetAnimeByGenreParams(
        genre: state.selectedGenres.first,
        page: nextPage,
      ));
      
      result.fold(
        (failure) => state = state.copyWith(isLoadingMoreGenre: false),
        (animeList) => state = state.copyWith(
          genreAnime: [...state.genreAnime, ...animeList],
          genrePage: nextPage,
          isLoadingMoreGenre: false,
        ),
      );
    } catch (e) {
      state = state.copyWith(isLoadingMoreGenre: false);
    }
  }
}

// Global provider for home state
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(
    getAiringAnime: ref.watch(getAiringAnimeProvider),
    getSeasonalAnime: ref.watch(getSeasonalAnimeProvider),
    getTopAnime: ref.watch(getTopAnimeProvider),
    getAnimeByGenre: ref.watch(getAnimeByGenreProvider),
  );
});
