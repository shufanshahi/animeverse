import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/anime_detail.dart';
import '../../domain/usecases/get_anime_detail.dart';

// Use case provider
final getAnimeDetailProvider = Provider<GetAnimeDetail>((ref) {
  try {
    return GetIt.instance<GetAnimeDetail>();
  } catch (e) {
    throw StateError('GetAnimeDetail not initialized. Did you call init()?');
  }
});

// State class for anime details
class AnimeDetailState {
  final AnimeDetail? animeDetail;
  final bool isLoading;
  final String? error;

  const AnimeDetailState({
    this.animeDetail,
    this.isLoading = false,
    this.error,
  });

  AnimeDetailState copyWith({
    AnimeDetail? animeDetail,
    bool? isLoading,
    String? error,
  }) {
    return AnimeDetailState(
      animeDetail: animeDetail ?? this.animeDetail,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// State notifier for anime details
class AnimeDetailNotifier extends StateNotifier<AnimeDetailState> {
  final GetAnimeDetail _getAnimeDetail;

  AnimeDetailNotifier({
    required GetAnimeDetail getAnimeDetail,
  })  : _getAnimeDetail = getAnimeDetail,
        super(const AnimeDetailState()) {
    // Initialize with loading state
    state = const AnimeDetailState(isLoading: false);
  }

  Future<void> getAnimeDetail(GetAnimeDetailParams params) async {
    // Set loading state
    state = state.copyWith(isLoading: true, error: null, animeDetail: null);
    
    try {
      final result = await _getAnimeDetail(params);
      
      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            error: _mapFailureToMessage(failure),
            animeDetail: null,
          );
        },
        (animeDetail) {
          state = state.copyWith(
            animeDetail: animeDetail,
            isLoading: false,
            error: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        animeDetail: null,
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Error';
      case NetworkFailure:
        return 'Network Error';
      case CacheFailure:
        return 'Cache Error';
      default:
        return 'Unexpected Error';
    }
  }
}

// Global provider for anime detail state
final animeDetailProvider =
    StateNotifierProvider<AnimeDetailNotifier, AnimeDetailState>((ref) {
  return AnimeDetailNotifier(
    getAnimeDetail: ref.watch(getAnimeDetailProvider),
  );
});
