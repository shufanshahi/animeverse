import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class ChatbotMessageResponse extends Equatable {
  final String content;
  final List<AnimeSuggestionEntity> animeSuggestions;

  const ChatbotMessageResponse({
    required this.content,
    this.animeSuggestions = const [],
  });

  @override
  List<Object?> get props => [content, animeSuggestions];
}