import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
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

  HomeState({
    this.airingAnime = const [],
    this.seasonalAnime = const [],
    this.topAnime = const [],
    this.genreAnime = const [],
    this.selectedGenres = const [],
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    List<AnimeEntity>? airingAnime,
    List<AnimeEntity>? seasonalAnime,
    List<AnimeEntity>? topAnime,
    List<AnimeEntity>? genreAnime,
    List<String>? selectedGenres,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      airingAnime: airingAnime ?? this.airingAnime,
      seasonalAnime: seasonalAnime ?? this.seasonalAnime,
      topAnime: topAnime ?? this.topAnime,
      genreAnime: genreAnime ?? this.genreAnime,
      selectedGenres: selectedGenres ?? this.selectedGenres,
      isLoading: isLoading ?? this.isLoading,
      error: error,
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
      final airingResult = await _getAiringAnime(const NoParams() as GetAiringAnimeParams);
      final seasonalResult = await _getSeasonalAnime(const NoParams() as GetSeasonalAnimeParams);
      final topResult = await _getTopAnime(const NoParams() as GetTopAnimeParams);
      
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
    );
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
