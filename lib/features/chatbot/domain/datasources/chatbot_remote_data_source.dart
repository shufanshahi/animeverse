import '../entities/entities.dart';

abstract class ChatbotRemoteDataSource {
  Future<String> sendMessage({
    required String message,
    required List<MessageEntity> conversationHistory,
  });
  
  Future<bool> checkConnection();
}