import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AnimeEntity>>> getTopAnime({int page = 1}) async {
    try {
      final animeList = await remoteDataSource.getTopAnime(page: page);
      return Right(animeList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<AnimeEntity>>> getAnimeByGenre({
    required String genre,
    int page = 1,
  }) async {
    try {
      final animeList = await remoteDataSource.getAnimeByGenre(
        genre: genre,
        page: page,
      );
      return Right(animeList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<AnimeEntity>>> getSeasonalAnime({
    required String year,
    required String season,
    int page = 1,
  }) async {
    try {
      final animeList = await remoteDataSource.getSeasonalAnime(
        year: year,
        season: season,
        page: page,
      );
      return Right(animeList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<AnimeEntity>>> searchAnime({
    required String query,
    int page = 1,
  }) async {
    try {
      final animeList = await remoteDataSource.searchAnime(
        query: query,
        page: page,
      );
      return Right(animeList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<AnimeEntity>>> getAiringAnime({int page = 1}) async {
    try {
      final animeList = await remoteDataSource.getAiringAnime(page: page);
      return Right(animeList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }
}