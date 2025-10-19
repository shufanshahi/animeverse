import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'social_chat_providers.dart';

class ChatState {
  final List<ChatMessageEntity> messages;
  final bool isLoading;
  final bool isSending;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessageEntity>? messages,
    bool? isLoading,
    bool? isSending,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  ChatNotifier(
    this._getMessagesUseCase,
    this._sendMessageUseCase,
  ) : super(const ChatState());

  Future<void> loadMessages({
    required String userId1,
    required String userId2,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getMessagesUseCase(
      GetMessagesParams(userId1: userId1, userId2: userId2),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: 'Failed to load messages',
      ),
      (messages) => state = state.copyWith(
        isLoading: false,
        messages: messages,
      ),
    );
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    if (message.trim().isEmpty) return;

    state = state.copyWith(isSending: true, error: null);

    final result = await _sendMessageUseCase(
      SendMessageParams(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isSending: false,
        error: 'Failed to send message',
      ),
      (newMessage) {
        final updatedMessages = [...state.messages, newMessage];
        state = state.copyWith(
          isSending: false,
          messages: updatedMessages,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final chatProvider = StateNotifierProvider.family<ChatNotifier, ChatState, String>(
  (ref, friendId) {
    return ChatNotifier(
      ref.read(getMessagesUseCaseProvider),
      ref.read(sendMessageUseCaseProvider),
    );
  },
);
