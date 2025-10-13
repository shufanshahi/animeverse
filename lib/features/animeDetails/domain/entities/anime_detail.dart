import 'package:equatable/equatable.dart';

class AnimeDetail extends Equatable {
  final int malId;
  final String url;
  final List<AnimeImage> images;
  final String title;
  final String? titleEnglish;
  final String? titleJapanese;
  final List<String> titleSynonyms;
  final String? type;
  final String? source;
  final int? episodes;
  final String? status;
  final bool airing;
  final AnimeAired? aired;
  final String? duration;
  final String? rating;
  final double? score;
  final int? scoredBy;
  final int? rank;
  final int? popularity;
  final int? members;
  final int? favorites;
  final String? synopsis;
  final String? background;
  final String? season;
  final int? year;
  final AnimeBroadcast? broadcast;
  final List<AnimeGenre> producers;
  final List<AnimeGenre> licensors;
  final List<AnimeGenre> studios;
  final List<AnimeGenre> genres;
  final List<AnimeGenre> explicitGenres;
  final List<AnimeGenre> themes;
  final List<AnimeGenre> demographics;

  const AnimeDetail({
    required this.malId,
    required this.url,
    required this.images,
    required this.title,
    this.titleEnglish,
    this.titleJapanese,
    required this.titleSynonyms,
    this.type,
    this.source,
    this.episodes,
    this.status,
    required this.airing,
    this.aired,
    this.duration,
    this.rating,
    this.score,
    this.scoredBy,
    this.rank,
    this.popularity,
    this.members,
    this.favorites,
    this.synopsis,
    this.background,
    this.season,
    this.year,
    this.broadcast,
    required this.producers,
    required this.licensors,
    required this.studios,
    required this.genres,
    required this.explicitGenres,
    required this.themes,
    required this.demographics,
  });

  @override
  List<Object?> get props => [
        malId,
        url,
        images,
        title,
        titleEnglish,
        titleJapanese,
        titleSynonyms,
        type,
        source,
        episodes,
        status,
        airing,
        aired,
        duration,
        rating,
        score,
        scoredBy,
        rank,
        popularity,
        members,
        favorites,
        synopsis,
        background,
        season,
        year,
        broadcast,
        producers,
        licensors,
        studios,
        genres,
        explicitGenres,
        themes,
        demographics,
      ];
}

class AnimeImage extends Equatable {
  final String type;
  final AnimeImageUrls imageUrls;

  const AnimeImage({
    required this.type,
    required this.imageUrls,
  });

  @override
  List<Object?> get props => [type, imageUrls];
}

class AnimeImageUrls extends Equatable {
  final String? imageUrl;
  final String? smallImageUrl;
  final String? largeImageUrl;

  const AnimeImageUrls({
    this.imageUrl,
    this.smallImageUrl,
    this.largeImageUrl,
  });

  @override
  List<Object?> get props => [imageUrl, smallImageUrl, largeImageUrl];
}

class AnimeAired extends Equatable {
  final DateTime? from;
  final DateTime? to;
  final AnimeProp? prop;
  final String? string;

  const AnimeAired({
    this.from,
    this.to,
    this.prop,
    this.string,
  });

  @override
  List<Object?> get props => [from, to, prop, string];
}

class AnimeProp extends Equatable {
  final AnimeDate? from;
  final AnimeDate? to;

  const AnimeProp({
    this.from,
    this.to,
  });

  @override
  List<Object?> get props => [from, to];
}

class AnimeDate extends Equatable {
  final int? day;
  final int? month;
  final int? year;

  const AnimeDate({
    this.day,
    this.month,
    this.year,
  });

  @override
  List<Object?> get props => [day, month, year];
}

class AnimeBroadcast extends Equatable {
  final String? day;
  final String? time;
  final String? timezone;
  final String? string;

  const AnimeBroadcast({
    this.day,
    this.time,
    this.timezone,
    this.string,
  });

  @override
  List<Object?> get props => [day, time, timezone, string];
}

class AnimeGenre extends Equatable {
  final int malId;
  final String type;
  final String name;
  final String url;

  const AnimeGenre({
    required this.malId,
    required this.type,
    required this.name,
    required this.url,
  });

  @override
  List<Object?> get props => [malId, type, name, url];
}