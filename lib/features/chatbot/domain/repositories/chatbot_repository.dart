import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/entities.dart';

abstract class ChatbotRepository {
  Future<Either<Failure, String>> sendMessage({
    required String message,
    required List<MessageEntity> conversationHistory,
  });
  
  Future<Either<Failure, bool>> checkConnection();
  
  Future<Either<Failure, List<AnimeSuggestionEntity>>> searchAnime({
    required String query,
    int limit = 10,
  });
  
  Future<Either<Failure, List<AnimeSuggestionEntity>>> getTopAnime({
    String? genre,
    int limit = 10,
  });
  
  Future<Either<Failure, List<AnimeSuggestionEntity>>> getRecommendations({
    required int animeId,
    int limit = 5,
  });
}
