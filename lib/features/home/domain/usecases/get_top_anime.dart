import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetTopAnime implements UseCase<List<AnimeEntity>, GetTopAnimeParams> {
  final HomeRepository repository;

  GetTopAnime(this.repository);

  @override
  Future<Either<Failure, List<AnimeEntity>>> call(GetTopAnimeParams params) async {
    return await repository.getTopAnime(page: params.page);
  }
}

class GetTopAnimeParams {
  final int page;

  GetTopAnimeParams({required this.page});
}