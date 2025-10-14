import '../domain.dart';
import '../repositories/repositories.dart';

class SearchAnimeUseCase {
  final SearchRepository repository;

  SearchAnimeUseCase(this.repository);

  Future<List<Anime>> call(String query) {
    return repository.searchAnime(query);
  }
}