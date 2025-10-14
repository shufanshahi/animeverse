import 'package:equatable/equatable.dart';

class AnimeEntity extends Equatable {
  final int malId;
  final String title;
  final String? titleEnglish;
  final String? titleJapanese;
  final String? synopsis;
  final String? imageUrl;
  final String? trailerUrl;
  final double? score;
  final int? rank;
  final String? status;
  final int? episodes;
  final String? duration;
  final String? rating;
  final List<String> genres;
  final String? type;
  final String? source;
  final String? aired;
  final int? year;
  final String? season;

  const AnimeEntity({
    required this.malId,
    required this.title,
    this.titleEnglish,
    this.titleJapanese,
    this.synopsis,
    this.imageUrl,
    this.trailerUrl,
    this.score,
    this.rank,
    this.status,
    this.episodes,
    this.duration,
    this.rating,
    this.genres = const [],
    this.type,
    this.source,
    this.aired,
    this.year,
    this.season,
  });

  @override
  List<Object?> get props => [
        malId,
        title,
        titleEnglish,
        titleJapanese,
        synopsis,
        imageUrl,
        trailerUrl,
        score,
        rank,
        status,
        episodes,
        duration,
        rating,
        genres,
        type,
        source,
        aired,
        year,
        season,
      ];
}
