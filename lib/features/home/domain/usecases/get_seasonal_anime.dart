import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetSeasonalAnime implements UseCase<List<AnimeEntity>, GetSeasonalAnimeParams> {
  final HomeRepository repository;

  GetSeasonalAnime(this.repository);

  @override
  Future<Either<Failure, List<AnimeEntity>>> call(GetSeasonalAnimeParams params) async {
    return await repository.getSeasonalAnime(
      year: params.year,
      season: params.season,
      page: params.page,
    );
  }
}

class GetSeasonalAnimeParams {
  final String year;
  final String season;
  final int page;

  GetSeasonalAnimeParams({
    required this.year,
    required this.season,
    required this.page,
  });
}