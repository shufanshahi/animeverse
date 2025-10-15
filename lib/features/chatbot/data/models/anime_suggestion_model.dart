import 'package:equatable/equatable.dart';

class AnimeSuggestionModel extends Equatable {
  final int id;
  final String title;
  final String imageUrl;
  final double? score;
  final String? synopsis;
  final String? status;
  final int? year;

  const AnimeSuggestionModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.score,
    this.synopsis,
    this.status,
    this.year,
  });

  factory AnimeSuggestionModel.fromJson(Map<String, dynamic> json) {
    return AnimeSuggestionModel(
      id: json['mal_id'] as int,
      title: json['title'] as String? ?? json['title_english'] as String? ?? 'Unknown Title',
      imageUrl: (json['images']?['jpg']?['image_url'] as String?) ?? '',
      score: (json['score'] as num?)?.toDouble(),
      synopsis: json['synopsis'] as String?,
      status: json['status'] as String?,
      year: json['year'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mal_id': id,
      'title': title,
      'images': {
        'jpg': {
          'image_url': imageUrl,
        },
      },
      'score': score,
      'synopsis': synopsis,
      'status': status,
      'year': year,
    };
  }

  @override
  List<Object?> get props => [id, title, imageUrl, score, synopsis, status, year];
}

class JikanSearchResponse extends Equatable {
  final List<AnimeSuggestionModel> data;

  const JikanSearchResponse({required this.data});

  factory JikanSearchResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return JikanSearchResponse(
      data: dataList
          .map((item) => AnimeSuggestionModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [data];
}