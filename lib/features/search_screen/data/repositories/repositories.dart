import '../../domain/repositories/repositories.dart';
import '../../domain/domain.dart';
import '../datasources/datasources.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDatasource datasource;

  SearchRepositoryImpl(this.datasource);

  @override
  Future<List<Anime>> searchAnime(String query) {
    return datasource.searchAnime(query);
  }
}