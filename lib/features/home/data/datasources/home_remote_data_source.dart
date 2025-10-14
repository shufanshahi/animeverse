import '../models/models.dart';

abstract class HomeRemoteDataSource {
  Future<List<AnimeModel>> getTopAnime({int page = 1});
  Future<List<AnimeModel>> getAnimeByGenre({
    required String genre,
    int page = 1,
  });
  Future<List<AnimeModel>> getSeasonalAnime({
    required String year,
    required String season,
    int page = 1,
  });
  Future<List<AnimeModel>> searchAnime({
    required String query,
    int page = 1,
  });
  Future<List<AnimeModel>> getAiringAnime({int page = 1});
}