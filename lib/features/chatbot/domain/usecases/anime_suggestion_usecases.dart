import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class SearchAnimeUseCase implements UseCase<List<AnimeSuggestionEntity>, SearchAnimeParams> {
  final ChatbotRepository repository;

  SearchAnimeUseCase(this.repository);

  @override
  Future<Either<Failure, List<AnimeSuggestionEntity>>> call(SearchAnimeParams params) async {
    return await repository.searchAnime(
      query: params.query,
      limit: params.limit,
    );
  }
}

class SearchAnimeParams {
  final String query;
  final int limit;

  SearchAnimeParams({
    required this.query,
    this.limit = 10,
  });
}

class GetTopAnimeUseCase implements UseCase<List<AnimeSuggestionEntity>, GetTopAnimeParams> {
  final ChatbotRepository repository;

  GetTopAnimeUseCase(this.repository);

  @override
  Future<Either<Failure, List<AnimeSuggestionEntity>>> call(GetTopAnimeParams params) async {
    return await repository.getTopAnime(
      genre: params.genre,
      limit: params.limit,
    );
  }
}

class GetTopAnimeParams {
  final String? genre;
  final int limit;

  GetTopAnimeParams({
    this.genre,
    this.limit = 10,
  });
}

class GetRecommendationsUseCase implements UseCase<List<AnimeSuggestionEntity>, GetRecommendationsParams> {
  final ChatbotRepository repository;

  GetRecommendationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AnimeSuggestionEntity>>> call(GetRecommendationsParams params) async {
    return await repository.getRecommendations(
      animeId: params.animeId,
      limit: params.limit,
    );
  }
}

class GetRecommendationsParams {
  final int animeId;
  final int limit;

  GetRecommendationsParams({
    required this.animeId,
    this.limit = 5,
  });
}