import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSourceImpl remoteDataSource;

  ChatbotRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> sendMessage({
    required String message,
    required List<MessageEntity> conversationHistory,
  }) async {
    try {
      final response = await remoteDataSource.sendMessage(
        message: message,
        conversationHistory: conversationHistory,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure('Failed to send message: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkConnection() async {
    try {
      final isConnected = await remoteDataSource.checkConnection();
      return Right(isConnected);
    } catch (e) {
      return Left(ServerFailure('Failed to check connection: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AnimeSuggestionEntity>>> searchAnime({
    required String query,
    int limit = 10,
  }) async {
    try {
      final results = await remoteDataSource.searchAnime(
        query: query,
        limit: limit,
      );
      return Right(results);
    } catch (e) {
      return Left(ServerFailure('Failed to search anime: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AnimeSuggestionEntity>>> getTopAnime({
    String? genre,
    int limit = 10,
  }) async {
    try {
      final results = await remoteDataSource.getTopAnime(
        genre: genre,
        limit: limit,
      );
      return Right(results);
    } catch (e) {
      return Left(ServerFailure('Failed to get top anime: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AnimeSuggestionEntity>>> getRecommendations({
    required int animeId,
    int limit = 5,
  }) async {
    try {
      final results = await remoteDataSource.getRecommendations(
        animeId: animeId,
        limit: limit,
      );
      return Right(results);
    } catch (e) {
      return Left(ServerFailure('Failed to get recommendations: $e'));
    }
  }
}
