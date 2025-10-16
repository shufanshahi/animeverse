import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/usecases.dart';
import '../../data/datasources/datasources.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/domain.dart';

// Provider for the use case
final searchAnimeUseCaseProvider = Provider<SearchAnimeUseCase>((ref) {
  final datasource = JikanSearchDatasource();
  final repository = SearchRepositoryImpl(datasource);
  return SearchAnimeUseCase(repository);
});

// StateNotifier for search state with debounce
class SearchState extends StateNotifier<AsyncValue<List<Anime>>> {
  final SearchAnimeUseCase useCase;

  SearchState(this.useCase) : super(const AsyncValue.data([]));

  Timer? _debounce;
  static const _debounceDuration = Duration(milliseconds: 400);
  String _currentQuery = '';

  void onQueryChanged(String query) {
    _currentQuery = query.trim();
    _debounce?.cancel();

    if (_currentQuery.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    _debounce = Timer(_debounceDuration, () => _performSearch(_currentQuery));
  }

  // Optional explicit trigger (Enter/Go button)
  Future<void> search(String query) async {
    onQueryChanged(query);
  }

  Future<void> _performSearch(String query) async {
    state = const AsyncValue.loading();
    try {
      final result = await useCase(query);
      if (query == _currentQuery) {
        state = AsyncValue.data(result);
      }
    } catch (e, st) {
      if (query == _currentQuery) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final searchStateProvider =
    StateNotifierProvider<SearchState, AsyncValue<List<Anime>>>((ref) {
  final useCase = ref.watch(searchAnimeUseCaseProvider);
  return SearchState(useCase);
});