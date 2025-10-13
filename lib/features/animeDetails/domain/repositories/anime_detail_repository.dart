import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/anime_detail.dart';

abstract class AnimeDetailRepository {
  Future<Either<Failure, AnimeDetail>> getAnimeDetail(int animeId);
}