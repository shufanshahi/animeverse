import 'package:equatable/equatable.dart';
import 'anime_suggestion_entity.dart';

enum MessageType { user, assistant }

class ClickableAnimeReference {
  final String title;
  final int animeId;
  final int startIndex;
  final int endIndex;

  const ClickableAnimeReference({
    required this.title,
    required this.animeId,
    required this.startIndex,
    required this.endIndex,
  });
}

class MessageEntity extends Equatable {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isLoading;
  final List<AnimeSuggestionEntity>? animeSuggestions;
  final List<ClickableAnimeReference>? clickableAnimeReferences;

  const MessageEntity({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isLoading = false,
    this.animeSuggestions,
    this.clickableAnimeReferences,
  });

  MessageEntity copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    bool? isLoading,
    List<AnimeSuggestionEntity>? animeSuggestions,
    List<ClickableAnimeReference>? clickableAnimeReferences,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
      animeSuggestions: animeSuggestions ?? this.animeSuggestions,
      clickableAnimeReferences: clickableAnimeReferences ?? this.clickableAnimeReferences,
    );
  }

  @override
  List<Object?> get props => [id, content, type, timestamp, isLoading, animeSuggestions, clickableAnimeReferences];
}
