import 'package:equatable/equatable.dart';

class AnimeSuggestionEntity extends Equatable {
  final int id;
  final String title;
  final String imageUrl;
  final double? score;
  final String? synopsis;
  final String? status;
  final int? year;

  const AnimeSuggestionEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.score,
    this.synopsis,
    this.status,
    this.year,
  });

  @override
  List<Object?> get props => [id, title, imageUrl, score, synopsis, status, year];
}

enum SuggestionType {
  search,
  top,
  recommendations,
}