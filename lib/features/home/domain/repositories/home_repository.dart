import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/entities.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<AnimeEntity>>> getTopAnime({int page = 1});
  Future<Either<Failure, List<AnimeEntity>>> getAnimeByGenre({
    required String genre,
    int page = 1,
  });
  Future<Either<Failure, List<AnimeEntity>>> getSeasonalAnime({
    required String year,
    required String season,
    int page = 1,
  });
  Future<Either<Failure, List<AnimeEntity>>> searchAnime({
    required String query,
    int page = 1,
  });
  Future<Either<Failure, List<AnimeEntity>>> getAiringAnime({int page = 1});
}
