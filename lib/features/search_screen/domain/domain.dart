export 'datasources/datasources.dart';
export 'repositories/repositories.dart';
export 'usecases/usecases.dart';
export 'domain.dart';

class Anime {
  final int malId;
  final String title;
  final String imageUrl;
  final double score;
  final String synopsis;

  Anime({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.score,
    required this.synopsis,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: json['mal_id'],
      title: json['title'] ?? '',
      imageUrl: json['images']?['jpg']?['image_url'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      synopsis: json['synopsis'] ?? '',
    );
  }
}
