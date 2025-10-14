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

// StateNotifier for search state
class SearchState extends StateNotifier<AsyncValue<List<Anime>>> {
  final SearchAnimeUseCase useCase;

  SearchState(this.useCase) : super(const AsyncValue.data([]));

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final result = await useCase(query);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final searchStateProvider =
    StateNotifierProvider<SearchState, AsyncValue<List<Anime>>>((ref) {
  final useCase = ref.watch(searchAnimeUseCaseProvider);
  return SearchState(useCase);
});