import 'package:equatable/equatable.dart';
import '../../domain/entities/entities.dart';

class ChatbotState extends Equatable {
  final List<MessageEntity> messages;
  final bool isLoading;
  final bool isConnected;
  final String? error;
  final bool isChatOpen;

  const ChatbotState({
    this.messages = const [],
    this.isLoading = false,
    this.isConnected = false,
    this.error,
    this.isChatOpen = false,
  });

  ChatbotState copyWith({
    List<MessageEntity>? messages,
    bool? isLoading,
    bool? isConnected,
    String? error,
    bool? isChatOpen,
    bool clearError = false,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      error: clearError ? null : (error ?? this.error),
      isChatOpen: isChatOpen ?? this.isChatOpen,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, isConnected, error, isChatOpen];
}
