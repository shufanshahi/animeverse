import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import '../state/state.dart';
import 'chatbot_providers.dart';

class ChatbotNotifier extends StateNotifier<ChatbotState> {
  final SendMessageUseCase _sendMessageUseCase;
  final CheckConnectionUseCase _checkConnectionUseCase;
  final Uuid _uuid = const Uuid();

  ChatbotNotifier({
    required SendMessageUseCase sendMessageUseCase,
    required CheckConnectionUseCase checkConnectionUseCase,
  })  : _sendMessageUseCase = sendMessageUseCase,
        _checkConnectionUseCase = checkConnectionUseCase,
        super(const ChatbotState()) {
    _initializeConnection();
  }

  Future<void> _initializeConnection() async {
    final result = await _checkConnectionUseCase(const NoParams());
    result.fold(
      (failure) => state = state.copyWith(
        isConnected: false,
        error: 'Failed to connect to LM Studio',
      ),
      (isConnected) => state = state.copyWith(
        isConnected: isConnected,
        error: isConnected ? null : '⚠️ LM Studio server is not running on localhost:1234',
      ),
    );
  }

  void toggleChat() {
    state = state.copyWith(isChatOpen: !state.isChatOpen);
  }

  void closeChat() {
    state = state.copyWith(isChatOpen: false);
  }

  void openChat() {
    state = state.copyWith(isChatOpen: true);
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty || state.isLoading) return;

    // Add user message
    final userMessage = MessageEntity(
      id: _uuid.v4(),
      content: content.trim(),
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    // Add loading message for assistant
    final loadingMessage = MessageEntity(
      id: _uuid.v4(),
      content: '...',
      type: MessageType.assistant,
      timestamp: DateTime.now(),
      isLoading: true,
    );

    state = state.copyWith(
      messages: [...state.messages, loadingMessage],
    );

    // Send message to AI
    final result = await _sendMessageUseCase(
      SendMessageParams(
        message: content.trim(),
        conversationHistory: state.messages
            .where((msg) => !msg.isLoading)
            .toList(),
      ),
    );

    result.fold(
      (failure) {
        // Remove loading message and show error
        final messagesWithoutLoading = state.messages
            .where((msg) => !msg.isLoading)
            .toList();
        
        String errorMessage = 'Failed to get response.';
        if (failure is ServerFailure) {
          if (failure.message.contains('No models loaded')) {
            errorMessage = '🤖 No model loaded in LM Studio. Please load a model first!';
          } else if (failure.message.contains('CORS')) {
            errorMessage = 'CORS error detected. Please run: flutter run -d chrome --web-browser-flag "--disable-web-security"';
          } else if (failure.message.contains('Connection refused') || failure.message.contains('timed out')) {
            errorMessage = 'Cannot connect to LM Studio. Make sure it\'s running on localhost:1234';
          } else if (failure.message.contains('404')) {
            errorMessage = '⚠️ LM Studio server is running but no model is loaded. Please load a model!';
          } else {
            errorMessage = failure.message;
          }
        }
        
        state = state.copyWith(
          messages: messagesWithoutLoading,
          isLoading: false,
          error: errorMessage,
        );
      },
      (response) {
        // Replace loading message with actual response
        final messagesWithoutLoading = state.messages
            .where((msg) => !msg.isLoading)
            .toList();

        final assistantMessage = MessageEntity(
          id: _uuid.v4(),
          content: response,
          type: MessageType.assistant,
          timestamp: DateTime.now(),
        );

        state = state.copyWith(
          messages: [...messagesWithoutLoading, assistantMessage],
          isLoading: false,
          error: null,
        );
      },
    );
  }

  Future<void> checkConnection() async {
    final result = await _checkConnectionUseCase(const NoParams());
    result.fold(
      (failure) => state = state.copyWith(
        isConnected: false,
        error: 'Failed to connect to LM Studio',
      ),
      (isConnected) => state = state.copyWith(
        isConnected: isConnected,
        error: isConnected ? null : '⚠️ LM Studio server is not running on localhost:1234',
      ),
    );
  }

  void clearMessages() {
    state = state.copyWith(messages: []);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Global provider for chatbot state
final chatbotProvider = StateNotifierProvider<ChatbotNotifier, ChatbotState>((ref) {
  return ChatbotNotifier(
    sendMessageUseCase: ref.watch(sendMessageUseCaseProvider),
    checkConnectionUseCase: ref.watch(checkConnectionUseCaseProvider),
  );
});