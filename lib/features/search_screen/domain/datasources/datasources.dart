import '../domain.dart';

abstract class SearchDatasource {
  Future<List<Anime>> searchAnime(String query);
}