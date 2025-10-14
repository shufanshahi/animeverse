import '../../domain/entities/anime_detail.dart';

class AnimeDetailModel extends AnimeDetail {
  const AnimeDetailModel({
    required super.malId,
    required super.url,
    required super.images,
    super.trailer,
    required super.approved,
    required super.titles,
    required super.title,
    super.titleEnglish,
    super.titleJapanese,
    required super.titleSynonyms,
    super.type,
    super.source,
    super.episodes,
    super.status,
    required super.airing,
    super.aired,
    super.duration,
    super.rating,
    super.score,
    super.scoredBy,
    super.rank,
    super.popularity,
    super.members,
    super.favorites,
    super.synopsis,
    super.background,
    super.season,
    super.year,
    super.broadcast,
    required super.producers,
    required super.licensors,
    required super.studios,
    required super.genres,
    required super.explicitGenres,
    required super.themes,
    required super.demographics,
    required super.relations,
    super.theme,
    required super.external,
    required super.streaming,
  });

  factory AnimeDetailModel.fromJson(Map<String, dynamic> json) {
    return AnimeDetailModel(
      malId: json['mal_id'] as int,
      url: json['url'] as String,
      images: _parseImages(json['images']),
      trailer: json['trailer'] != null 
          ? AnimeTrailerModel.fromJson(json['trailer'])
          : null,
      approved: json['approved'] as bool? ?? false,
      titles: _parseTitles(json['titles']),
      title: json['title'] as String,
      titleEnglish: json['title_english'] as String?,
      titleJapanese: json['title_japanese'] as String?,
      titleSynonyms: List<String>.from(json['title_synonyms'] ?? []),
      type: json['type'] as String?,
      source: json['source'] as String?,
      episodes: json['episodes'] as int?,
      status: json['status'] as String?,
      airing: json['airing'] as bool,
      aired: json['aired'] != null 
          ? AnimeAiredModel.fromJson(json['aired'])
          : null,
      duration: json['duration'] as String?,
      rating: json['rating'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      scoredBy: json['scored_by'] as int?,
      rank: json['rank'] as int?,
      popularity: json['popularity'] as int?,
      members: json['members'] as int?,
      favorites: json['favorites'] as int?,
      synopsis: json['synopsis'] as String?,
      background: json['background'] as String?,
      season: json['season'] as String?,
      year: json['year'] as int?,
      broadcast: json['broadcast'] != null 
          ? AnimeBroadcastModel.fromJson(json['broadcast'])
          : null,
      producers: _parseGenreList(json['producers']),
      licensors: _parseGenreList(json['licensors']),
      studios: _parseGenreList(json['studios']),
      genres: _parseGenreList(json['genres']),
      explicitGenres: _parseGenreList(json['explicit_genres']),
      themes: _parseGenreList(json['themes']),
      demographics: _parseGenreList(json['demographics']),
      relations: _parseRelations(json['relations']),
      theme: json['theme'] != null 
          ? AnimeThemeModel.fromJson(json['theme'])
          : null,
      external: _parseExternal(json['external']),
      streaming: _parseStreaming(json['streaming']),
    );
  }

  static Map<String, AnimeImageUrls> _parseImages(dynamic json) {
    if (json == null) return {};
    final Map<String, dynamic> imagesMap = json;
    final Map<String, AnimeImageUrls> result = {};
    
    imagesMap.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        result[key] = AnimeImageUrlsModel.fromJson(value);
      }
    });
    
    return result;
  }

  static List<AnimeTitle> _parseTitles(dynamic json) {
    if (json == null) return [];
    return (json as List)
        .map((item) => AnimeTitleModel.fromJson(item))
        .toList();
  }

  static List<AnimeGenre> _parseGenreList(dynamic json) {
    if (json == null) return [];
    return (json as List)
        .map((item) => AnimeGenreModel.fromJson(item))
        .toList();
  }

  static List<AnimeRelation> _parseRelations(dynamic json) {
    if (json == null) return [];
    return (json as List)
        .map((item) => AnimeRelationModel.fromJson(item))
        .toList();
  }

  static List<AnimeExternal> _parseExternal(dynamic json) {
    if (json == null) return [];
    return (json as List)
        .map((item) => AnimeExternalModel.fromJson(item))
        .toList();
  }

  static List<AnimeStreaming> _parseStreaming(dynamic json) {
    if (json == null) return [];
    return (json as List)
        .map((item) => AnimeStreamingModel.fromJson(item))
        .toList();
  }
}

class AnimeImageUrlsModel extends AnimeImageUrls {
  const AnimeImageUrlsModel({
    super.imageUrl,
    super.smallImageUrl,
    super.largeImageUrl,
  });

  factory AnimeImageUrlsModel.fromJson(Map<String, dynamic> json) {
    return AnimeImageUrlsModel(
      imageUrl: json['image_url'] as String?,
      smallImageUrl: json['small_image_url'] as String?,
      largeImageUrl: json['large_image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': imageUrl,
      'small_image_url': smallImageUrl,
      'large_image_url': largeImageUrl,
    };
  }
}

class AnimeTrailerModel extends AnimeTrailer {
  const AnimeTrailerModel({
    super.youtubeId,
    super.url,
    super.embedUrl,
    super.images,
  });

  factory AnimeTrailerModel.fromJson(Map<String, dynamic> json) {
    return AnimeTrailerModel(
      youtubeId: json['youtube_id'] as String?,
      url: json['url'] as String?,
      embedUrl: json['embed_url'] as String?,
      images: json['images'] != null 
          ? AnimeTrailerImagesModel.fromJson(json['images'])
          : null,
    );
  }
}

class AnimeTrailerImagesModel extends AnimeTrailerImages {
  const AnimeTrailerImagesModel({
    super.imageUrl,
    super.smallImageUrl,
    super.mediumImageUrl,
    super.largeImageUrl,
    super.maximumImageUrl,
  });

  factory AnimeTrailerImagesModel.fromJson(Map<String, dynamic> json) {
    return AnimeTrailerImagesModel(
      imageUrl: json['image_url'] as String?,
      smallImageUrl: json['small_image_url'] as String?,
      mediumImageUrl: json['medium_image_url'] as String?,
      largeImageUrl: json['large_image_url'] as String?,
      maximumImageUrl: json['maximum_image_url'] as String?,
    );
  }
}

class AnimeTitleModel extends AnimeTitle {
  const AnimeTitleModel({
    required super.type,
    required super.title,
  });

  factory AnimeTitleModel.fromJson(Map<String, dynamic> json) {
    return AnimeTitleModel(
      type: json['type'] as String,
      title: json['title'] as String,
    );
  }
}

class AnimeAiredModel extends AnimeAired {
  const AnimeAiredModel({
    super.from,
    super.to,
    super.prop,
    super.string,
  });

  factory AnimeAiredModel.fromJson(Map<String, dynamic> json) {
    return AnimeAiredModel(
      from: json['from'] != null ? DateTime.parse(json['from']) : null,
      to: json['to'] != null ? DateTime.parse(json['to']) : null,
      prop: json['prop'] != null ? AnimePropModel.fromJson(json['prop']) : null,
      string: json['string'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from?.toIso8601String(),
      'to': to?.toIso8601String(),
      'prop': (prop as AnimePropModel?)?.toJson(),
      'string': string,
    };
  }
}

class AnimePropModel extends AnimeProp {
  const AnimePropModel({
    super.from,
    super.to,
  });

  factory AnimePropModel.fromJson(Map<String, dynamic> json) {
    return AnimePropModel(
      from: json['from'] != null ? AnimeDateModel.fromJson(json['from']) : null,
      to: json['to'] != null ? AnimeDateModel.fromJson(json['to']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': (from as AnimeDateModel?)?.toJson(),
      'to': (to as AnimeDateModel?)?.toJson(),
    };
  }
}

class AnimeDateModel extends AnimeDate {
  const AnimeDateModel({
    super.day,
    super.month,
    super.year,
  });

  factory AnimeDateModel.fromJson(Map<String, dynamic> json) {
    return AnimeDateModel(
      day: json['day'] as int?,
      month: json['month'] as int?,
      year: json['year'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'month': month,
      'year': year,
    };
  }
}

class AnimeBroadcastModel extends AnimeBroadcast {
  const AnimeBroadcastModel({
    super.day,
    super.time,
    super.timezone,
    super.string,
  });

  factory AnimeBroadcastModel.fromJson(Map<String, dynamic> json) {
    return AnimeBroadcastModel(
      day: json['day'] as String?,
      time: json['time'] as String?,
      timezone: json['timezone'] as String?,
      string: json['string'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'time': time,
      'timezone': timezone,
      'string': string,
    };
  }
}

class AnimeGenreModel extends AnimeGenre {
  const AnimeGenreModel({
    required super.malId,
    required super.type,
    required super.name,
    required super.url,
  });

  factory AnimeGenreModel.fromJson(Map<String, dynamic> json) {
    return AnimeGenreModel(
      malId: json['mal_id'] as int,
      type: json['type'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mal_id': malId,
      'type': type,
      'name': name,
      'url': url,
    };
  }
}

class AnimeRelationModel extends AnimeRelation {
  const AnimeRelationModel({
    required super.relation,
    required super.entry,
  });

  factory AnimeRelationModel.fromJson(Map<String, dynamic> json) {
    return AnimeRelationModel(
      relation: json['relation'] as String,
      entry: (json['entry'] as List)
          .map((item) => AnimeRelationEntryModel.fromJson(item))
          .toList(),
    );
  }
}

class AnimeRelationEntryModel extends AnimeRelationEntry {
  const AnimeRelationEntryModel({
    required super.malId,
    required super.type,
    required super.name,
    required super.url,
  });

  factory AnimeRelationEntryModel.fromJson(Map<String, dynamic> json) {
    return AnimeRelationEntryModel(
      malId: json['mal_id'] as int,
      type: json['type'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}

class AnimeThemeModel extends AnimeTheme {
  const AnimeThemeModel({
    required super.openings,
    required super.endings,
  });

  factory AnimeThemeModel.fromJson(Map<String, dynamic> json) {
    return AnimeThemeModel(
      openings: List<String>.from(json['openings'] ?? []),
      endings: List<String>.from(json['endings'] ?? []),
    );
  }
}

class AnimeExternalModel extends AnimeExternal {
  const AnimeExternalModel({
    required super.name,
    required super.url,
  });

  factory AnimeExternalModel.fromJson(Map<String, dynamic> json) {
    return AnimeExternalModel(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}

class AnimeStreamingModel extends AnimeStreaming {
  const AnimeStreamingModel({
    required super.name,
    required super.url,
  });

  factory AnimeStreamingModel.fromJson(Map<String, dynamic> json) {
    return AnimeStreamingModel(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }
}