import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTopAnime getTopAnime;
  final GetAnimeByGenre getAnimeByGenre;
  final GetSeasonalAnime getSeasonalAnime;
  final GetAiringAnime getAiringAnime;

  HomeBloc({
    required this.getTopAnime,
    required this.getAnimeByGenre,
    required this.getSeasonalAnime,
    required this.getAiringAnime,
  }) : super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<LoadAnimeByGenre>(_onLoadAnimeByGenre);
    on<LoadMoreAnimeByGenre>(_onLoadMoreAnimeByGenre);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    try {
      // Get current year and season for seasonal anime
      final now = DateTime.now();
      final currentYear = now.year.toString();
      final currentSeason = _getCurrentSeason(now.month);

      // Load all data concurrently
      final results = await Future.wait([
        getTopAnime(GetTopAnimeParams(page: 1)),
        getAiringAnime(GetAiringAnimeParams(page: 1)),
        getSeasonalAnime(GetSeasonalAnimeParams(
          year: currentYear,
          season: currentSeason,
          page: 1,
        )),
      ]);

      final topResult = results[0];
      final airingResult = results[1];
      final seasonalResult = results[2];

      if (topResult.isRight() && airingResult.isRight() && seasonalResult.isRight()) {
        emit(HomeLoaded(
          topAnime: topResult.getOrElse(() => []),
          airingAnime: airingResult.getOrElse(() => []),
          seasonalAnime: seasonalResult.getOrElse(() => []),
        ));
      } else {
        emit(const HomeError(message: 'Failed to load home data'));
      }
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onLoadAnimeByGenre(
    LoadAnimeByGenre event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      
      // Update loading state for this genre
      final updatedLoading = Map<String, bool>.from(currentState.genreLoading);
      updatedLoading[event.genre] = true;
      
      emit(currentState.copyWith(genreLoading: updatedLoading));

      final result = await getAnimeByGenre(GetAnimeByGenreParams(
        genre: event.genre,
        page: event.page,
      ));

      result.fold(
        (failure) {
          final updatedLoading = Map<String, bool>.from(currentState.genreLoading);
          updatedLoading[event.genre] = false;
          emit(currentState.copyWith(genreLoading: updatedLoading));
        },
        (animeList) {
          final updatedGenreAnime = Map<String, List<AnimeEntity>>.from(currentState.genreAnime);
          final updatedLoading = Map<String, bool>.from(currentState.genreLoading);
          final updatedPages = Map<String, int>.from(currentState.genrePages);
          
          updatedGenreAnime[event.genre] = animeList;
          updatedLoading[event.genre] = false;
          updatedPages[event.genre] = event.page;
          
          emit(currentState.copyWith(
            genreAnime: updatedGenreAnime,
            genreLoading: updatedLoading,
            genrePages: updatedPages,
          ));
        },
      );
    }
  }

  Future<void> _onLoadMoreAnimeByGenre(
    LoadMoreAnimeByGenre event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      
      final result = await getAnimeByGenre(GetAnimeByGenreParams(
        genre: event.genre,
        page: event.page,
      ));

      result.fold(
        (failure) {
          // Handle error if needed
        },
        (newAnimeList) {
          final updatedGenreAnime = Map<String, List<AnimeEntity>>.from(currentState.genreAnime);
          final updatedPages = Map<String, int>.from(currentState.genrePages);
          
          final existingList = updatedGenreAnime[event.genre] ?? [];
          updatedGenreAnime[event.genre] = [...existingList, ...newAnimeList];
          updatedPages[event.genre] = event.page;
          
          emit(currentState.copyWith(
            genreAnime: updatedGenreAnime,
            genrePages: updatedPages,
          ));
        },
      );
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    add(const LoadHomeData());
  }

  String _getCurrentSeason(int month) {
    switch (month) {
      case 12:
      case 1:
      case 2:
        return 'winter';
      case 3:
      case 4:
      case 5:
        return 'spring';
      case 6:
      case 7:
      case 8:
        return 'summer';
      case 9:
      case 10:
      case 11:
        return 'fall';
      default:
        return 'spring';
    }
  }
}