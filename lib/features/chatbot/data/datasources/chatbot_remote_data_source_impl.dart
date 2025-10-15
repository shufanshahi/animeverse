import '../../domain/datasources/datasources.dart';
import '../../domain/entities/entities.dart';
import '../models/models.dart';
import '../services/services.dart';

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  final LMStudioService lmStudioService;

  ChatbotRemoteDataSourceImpl({required this.lmStudioService});

  @override
  Future<String> sendMessage({
    required String message,
    required List<MessageEntity> conversationHistory,
  }) async {
    // Create system prompt for anime assistance
    final systemPrompt = LMStudioMessage(
      role: 'system',
      content: '''You are an expert anime assistant chatbot for AnimeVerse app. You provide helpful, accurate, and engaging information about anime, manga, characters, studios, genres, recommendations, and anything related to anime culture. 

Your responses should be:
- Informative and accurate
- Friendly and enthusiastic about anime
- Concise but comprehensive
- Include specific details when possible
- Offer recommendations when appropriate

When users ask about anime, provide details like release year, studio, genre, plot summary, main characters, and why it's notable. For recommendations, consider the user's preferences and suggest similar anime with brief explanations.''',
    );

    // Convert conversation history to LM Studio format
    final messages = <LMStudioMessage>[systemPrompt];
    
    for (final msg in conversationHistory) {
      messages.add(LMStudioMessage(
        role: msg.type == MessageType.user ? 'user' : 'assistant',
        content: msg.content,
      ));
    }

    // Add the current message
    messages.add(LMStudioMessage(
      role: 'user',
      content: message,
    ));

    try {
      final response = await lmStudioService.sendChatCompletion(
        messages: messages,
        temperature: 0.7,
        maxTokens: 1000,
      );

      if (response.choices.isNotEmpty) {
        return response.choices.first.message.content;
      } else {
        throw Exception('No response generated');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<bool> checkConnection() async {
    try {
      return await lmStudioService.checkConnection();
    } catch (e) {
      return false;
    }
  }
}