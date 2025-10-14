import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetAnimeByGenre implements UseCase<List<AnimeEntity>, GetAnimeByGenreParams> {
  final HomeRepository repository;

  GetAnimeByGenre(this.repository);

  @override
  Future<Either<Failure, List<AnimeEntity>>> call(GetAnimeByGenreParams params) async {
    return await repository.getAnimeByGenre(genre: params.genre, page: params.page);
  }
}

class GetAnimeByGenreParams {
  final String genre;
  final int page;

  GetAnimeByGenreParams({required this.genre, required this.page});
}