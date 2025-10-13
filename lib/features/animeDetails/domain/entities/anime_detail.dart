import 'package:equatable/equatable.dart';

class AnimeDetail extends Equatable {
  final int malId;
  final String url;
  final Map<String, AnimeImageUrls> images;
  final AnimeTrailer? trailer;
  final bool approved;
  final List<AnimeTitle> titles;
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
  final List<AnimeRelation> relations;
  final AnimeTheme? theme;
  final List<AnimeExternal> external;
  final List<AnimeStreaming> streaming;

  const AnimeDetail({
    required this.malId,
    required this.url,
    required this.images,
    this.trailer,
    required this.approved,
    required this.titles,
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
    required this.relations,
    this.theme,
    required this.external,
    required this.streaming,
  });

  @override
  List<Object?> get props => [
        malId,
        url,
        images,
        trailer,
        approved,
        titles,
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
        relations,
        theme,
        external,
        streaming,
      ];
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

class AnimeTrailer extends Equatable {
  final String? youtubeId;
  final String? url;
  final String? embedUrl;
  final AnimeTrailerImages? images;

  const AnimeTrailer({
    this.youtubeId,
    this.url,
    this.embedUrl,
    this.images,
  });

  @override
  List<Object?> get props => [youtubeId, url, embedUrl, images];
}

class AnimeTrailerImages extends Equatable {
  final String? imageUrl;
  final String? smallImageUrl;
  final String? mediumImageUrl;
  final String? largeImageUrl;
  final String? maximumImageUrl;

  const AnimeTrailerImages({
    this.imageUrl,
    this.smallImageUrl,
    this.mediumImageUrl,
    this.largeImageUrl,
    this.maximumImageUrl,
  });

  @override
  List<Object?> get props => [imageUrl, smallImageUrl, mediumImageUrl, largeImageUrl, maximumImageUrl];
}

class AnimeTitle extends Equatable {
  final String type;
  final String title;

  const AnimeTitle({
    required this.type,
    required this.title,
  });

  @override
  List<Object?> get props => [type, title];
}

class AnimeRelation extends Equatable {
  final String relation;
  final List<AnimeRelationEntry> entry;

  const AnimeRelation({
    required this.relation,
    required this.entry,
  });

  @override
  List<Object?> get props => [relation, entry];
}

class AnimeRelationEntry extends Equatable {
  final int malId;
  final String type;
  final String name;
  final String url;

  const AnimeRelationEntry({
    required this.malId,
    required this.type,
    required this.name,
    required this.url,
  });

  @override
  List<Object?> get props => [malId, type, name, url];
}

class AnimeTheme extends Equatable {
  final List<String> openings;
  final List<String> endings;

  const AnimeTheme({
    required this.openings,
    required this.endings,
  });

  @override
  List<Object?> get props => [openings, endings];
}

class AnimeExternal extends Equatable {
  final String name;
  final String url;

  const AnimeExternal({
    required this.name,
    required this.url,
  });

  @override
  List<Object?> get props => [name, url];
}

class AnimeStreaming extends Equatable {
  final String name;
  final String url;

  const AnimeStreaming({
    required this.name,
    required this.url,
  });

  @override
  List<Object?> get props => [name, url];
}