import '../../domain/domain.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDatasource datasource;

  SearchRepositoryImpl(this.datasource);

  @override
  Future<List<Anime>> searchAnime(String query) {
    return datasource.searchAnime(query);
  }
}