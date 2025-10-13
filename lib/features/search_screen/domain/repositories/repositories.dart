import '../domain.dart';

abstract class SearchRepository {
  Future<List<Anime>> searchAnime(String query);
}