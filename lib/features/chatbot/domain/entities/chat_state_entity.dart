import 'package:equatable/equatable.dart';
import 'message_entity.dart';

class ChatStateEntity extends Equatable {
  final List<MessageEntity> messages;
  final bool isLoading;
  final String? error;
  final bool isConnected;

  const ChatStateEntity({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.isConnected = false,
  });

  ChatStateEntity copyWith({
    List<MessageEntity>? messages,
    bool? isLoading,
    String? error,
    bool? isConnected,
  }) {
    return ChatStateEntity(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, error, isConnected];
}