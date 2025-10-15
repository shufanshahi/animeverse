import '../entities/entities.dart';

abstract class ChatbotRemoteDataSource {
  Future<String> sendMessage({
    required String message,
    required List<MessageEntity> conversationHistory,
  });
  
  Future<bool> checkConnection();
  
  Future<List<AnimeSuggestionEntity>> searchAnime({
    required String query,
    int limit = 10,
  });
  
  Future<List<AnimeSuggestionEntity>> getTopAnime({
    String? genre,
    int limit = 10,
  });
  
  Future<List<AnimeSuggestionEntity>> getRecommendations({
    required int animeId,
    int limit = 5,
  });
}