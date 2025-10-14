import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetAiringAnime implements UseCase<List<AnimeEntity>, GetAiringAnimeParams> {
  final HomeRepository repository;

  GetAiringAnime(this.repository);

  @override
  Future<Either<Failure, List<AnimeEntity>>> call(GetAiringAnimeParams params) async {
    return await repository.getAiringAnime(page: params.page);
  }
}

class GetAiringAnimeParams {
  final int page;

  GetAiringAnimeParams({required this.page});
}