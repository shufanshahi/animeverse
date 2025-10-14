import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/anime_detail.dart';
import '../../domain/repositories/anime_detail_repository.dart';
import '../datasources/anime_detail_remote_data_source.dart';

class AnimeDetailRepositoryImpl implements AnimeDetailRepository {
  final AnimeDetailRemoteDataSource remoteDataSource;

  AnimeDetailRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, AnimeDetail>> getAnimeDetail(int animeId) async {
    try {
      final animeDetail = await remoteDataSource.getAnimeDetail(animeId);
      return Right(animeDetail);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}