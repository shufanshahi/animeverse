import '../../domain/entities/entities.dart';

class AnimeModel extends AnimeEntity {
  const AnimeModel({
    required super.malId,
    required super.title,
    super.titleEnglish,
    super.titleJapanese,
    super.synopsis,
    super.imageUrl,
    super.trailerUrl,
    super.score,
    super.rank,
    super.status,
    super.episodes,
    super.duration,
    super.rating,
    super.genres = const [],
    super.type,
    super.source,
    super.aired,
    super.year,
    super.season,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      malId: json['mal_id'] ?? 0,
      title: json['title'] ?? '',
      titleEnglish: json['title_english'],
      titleJapanese: json['title_japanese'],
      synopsis: json['synopsis'],
      imageUrl: json['images']?['jpg']?['large_image_url'] ?? 
                json['images']?['jpg']?['image_url'],
      trailerUrl: json['trailer']?['youtube_id'] != null 
          ? 'https://www.youtube.com/watch?v=${json['trailer']['youtube_id']}'
          : null,
      score: json['score']?.toDouble(),
      rank: json['rank'],
      status: json['status'],
      episodes: json['episodes'],
      duration: json['duration'],
      rating: json['rating'],
      genres: json['genres'] != null 
          ? List<String>.from(json['genres'].map((genre) => genre['name']))
          : [],
      type: json['type'],
      source: json['source'],
      aired: json['aired']?['string'],
      year: json['year'],
      season: json['season'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mal_id': malId,
      'title': title,
      'title_english': titleEnglish,
      'title_japanese': titleJapanese,
      'synopsis': synopsis,
      'images': {
        'jpg': {
          'large_image_url': imageUrl,
          'image_url': imageUrl,
        }
      },
      'trailer': trailerUrl != null 
          ? {'youtube_id': trailerUrl?.split('v=')[1]}
          : null,
      'score': score,
      'rank': rank,
      'status': status,
      'episodes': episodes,
      'duration': duration,
      'rating': rating,
      'genres': genres.map((genre) => {'name': genre}).toList(),
      'type': type,
      'source': source,
      'aired': {'string': aired},
      'year': year,
      'season': season,
    };
  }
}