import '../../domain/entities/entities.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.content,
    required super.type,
    required super.timestamp,
    super.isLoading,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      type: json['type'] == 'user' ? MessageType.user : MessageType.assistant,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isLoading: json['isLoading'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type == MessageType.user ? 'user' : 'assistant',
      'timestamp': timestamp.toIso8601String(),
      'isLoading': isLoading,
    };
  }

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      content: entity.content,
      type: entity.type,
      timestamp: entity.timestamp,
      isLoading: entity.isLoading,
    );
  }
}
