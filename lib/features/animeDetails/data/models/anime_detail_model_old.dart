// import '../../domain/entities/anime_detail.dart';

// class AnimeDetailModel extends AnimeDetail {
//   const AnimeDetailModel({
//     required super.malId,
//     required super.url,
//     required super.images,
//     required super.title,
//     super.titleEnglish,
//     super.titleJapanese,
//     required super.titleSynonyms,
//     super.type,
//     super.source,
//     super.episodes,
//     super.status,
//     required super.airing,
//     super.aired,
//     super.duration,
//     super.rating,
//     super.score,
//     super.scoredBy,
//     super.rank,
//     super.popularity,
//     super.members,
//     super.favorites,
//     super.synopsis,
//     super.background,
//     super.season,
//     super.year,
//     super.broadcast,
//     required super.producers,
//     required super.licensors,
//     required super.studios,
//     required super.genres,
//     required super.explicitGenres,
//     required super.themes,
//     required super.demographics,
//   });

//   factory AnimeDetailModel.fromJson(Map<String, dynamic> json) {
//     return AnimeDetailModel(
//       malId: json['mal_id'] as int,
//       url: json['url'] as String,
//       images: (json['images'] as Map<String, dynamic>).entries
//           .map((e) => AnimeImageModel.fromJson(e.key, e.value))
//           .toList(),
//       title: json['title'] as String,
//       titleEnglish: json['title_english'] as String?,
//       titleJapanese: json['title_japanese'] as String?,
//       titleSynonyms: List<String>.from(json['title_synonyms'] ?? []),
//       type: json['type'] as String?,
//       source: json['source'] as String?,
//       episodes: json['episodes'] as int?,
//       status: json['status'] as String?,
//       airing: json['airing'] as bool,
//       aired: json['aired'] != null 
//           ? AnimeAiredModel.fromJson(json['aired'])
//           : null,
//       duration: json['duration'] as String?,
//       rating: json['rating'] as String?,
//       score: (json['score'] as num?)?.toDouble(),
//       scoredBy: json['scored_by'] as int?,
//       rank: json['rank'] as int?,
//       popularity: json['popularity'] as int?,
//       members: json['members'] as int?,
//       favorites: json['favorites'] as int?,
//       synopsis: json['synopsis'] as String?,
//       background: json['background'] as String?,
//       season: json['season'] as String?,
//       year: json['year'] as int?,
//       broadcast: json['broadcast'] != null 
//           ? AnimeBroadcastModel.fromJson(json['broadcast'])
//           : null,
//       producers: _parseGenreList(json['producers']),
//       licensors: _parseGenreList(json['licensors']),
//       studios: _parseGenreList(json['studios']),
//       genres: _parseGenreList(json['genres']),
//       explicitGenres: _parseGenreList(json['explicit_genres']),
//       themes: _parseGenreList(json['themes']),
//       demographics: _parseGenreList(json['demographics']),
//     );
//   }

//   static List<AnimeGenre> _parseGenreList(dynamic json) {
//     if (json == null) return [];
//     return (json as List)
//         .map((item) => AnimeGenreModel.fromJson(item))
//         .toList();
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'mal_id': malId,
//       'url': url,
//       'images': {
//         for (var image in images)
//           (image as AnimeImageModel).type: (image.imageUrls as AnimeImageUrlsModel).toJson(),
//       },
//       'title': title,
//       'title_english': titleEnglish,
//       'title_japanese': titleJapanese,
//       'title_synonyms': titleSynonyms,
//       'type': type,
//       'source': source,
//       'episodes': episodes,
//       'status': status,
//       'airing': airing,
//       'aired': (aired as AnimeAiredModel?)?.toJson(),
//       'duration': duration,
//       'rating': rating,
//       'score': score,
//       'scored_by': scoredBy,
//       'rank': rank,
//       'popularity': popularity,
//       'members': members,
//       'favorites': favorites,
//       'synopsis': synopsis,
//       'background': background,
//       'season': season,
//       'year': year,
//       'broadcast': (broadcast as AnimeBroadcastModel?)?.toJson(),
//       'producers': producers.map((p) => (p as AnimeGenreModel).toJson()).toList(),
//       'licensors': licensors.map((l) => (l as AnimeGenreModel).toJson()).toList(),
//       'studios': studios.map((s) => (s as AnimeGenreModel).toJson()).toList(),
//       'genres': genres.map((g) => (g as AnimeGenreModel).toJson()).toList(),
//       'explicit_genres': explicitGenres.map((e) => (e as AnimeGenreModel).toJson()).toList(),
//       'themes': themes.map((t) => (t as AnimeGenreModel).toJson()).toList(),
//       'demographics': demographics.map((d) => (d as AnimeGenreModel).toJson()).toList(),
//     };
//   }
// }

// class AnimeImageModel extends AnimeImage {
//   const AnimeImageModel({
//     required super.type,
//     required super.imageUrls,
//   });

//   factory AnimeImageModel.fromJson(String type, Map<String, dynamic> json) {
//     return AnimeImageModel(
//       type: type,
//       imageUrls: AnimeImageUrlsModel.fromJson(json),
//     );
//   }
// }

// class AnimeImageUrlsModel extends AnimeImageUrls {
//   const AnimeImageUrlsModel({
//     super.imageUrl,
//     super.smallImageUrl,
//     super.largeImageUrl,
//   });

//   factory AnimeImageUrlsModel.fromJson(Map<String, dynamic> json) {
//     return AnimeImageUrlsModel(
//       imageUrl: json['image_url'] as String?,
//       smallImageUrl: json['small_image_url'] as String?,
//       largeImageUrl: json['large_image_url'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'image_url': imageUrl,
//       'small_image_url': smallImageUrl,
//       'large_image_url': largeImageUrl,
//     };
//   }
// }

// class AnimeAiredModel extends AnimeAired {
//   const AnimeAiredModel({
//     super.from,
//     super.to,
//     super.prop,
//     super.string,
//   });

//   factory AnimeAiredModel.fromJson(Map<String, dynamic> json) {
//     return AnimeAiredModel(
//       from: json['from'] != null ? DateTime.parse(json['from']) : null,
//       to: json['to'] != null ? DateTime.parse(json['to']) : null,
//       prop: json['prop'] != null ? AnimePropModel.fromJson(json['prop']) : null,
//       string: json['string'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'from': from?.toIso8601String(),
//       'to': to?.toIso8601String(),
//       'prop': (prop as AnimePropModel?)?.toJson(),
//       'string': string,
//     };
//   }
// }

// class AnimePropModel extends AnimeProp {
//   const AnimePropModel({
//     super.from,
//     super.to,
//   });

//   factory AnimePropModel.fromJson(Map<String, dynamic> json) {
//     return AnimePropModel(
//       from: json['from'] != null ? AnimeDateModel.fromJson(json['from']) : null,
//       to: json['to'] != null ? AnimeDateModel.fromJson(json['to']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'from': (from as AnimeDateModel?)?.toJson(),
//       'to': (to as AnimeDateModel?)?.toJson(),
//     };
//   }
// }

// class AnimeDateModel extends AnimeDate {
//   const AnimeDateModel({
//     super.day,
//     super.month,
//     super.year,
//   });

//   factory AnimeDateModel.fromJson(Map<String, dynamic> json) {
//     return AnimeDateModel(
//       day: json['day'] as int?,
//       month: json['month'] as int?,
//       year: json['year'] as int?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'day': day,
//       'month': month,
//       'year': year,
//     };
//   }
// }

// class AnimeBroadcastModel extends AnimeBroadcast {
//   const AnimeBroadcastModel({
//     super.day,
//     super.time,
//     super.timezone,
//     super.string,
//   });

//   factory AnimeBroadcastModel.fromJson(Map<String, dynamic> json) {
//     return AnimeBroadcastModel(
//       day: json['day'] as String?,
//       time: json['time'] as String?,
//       timezone: json['timezone'] as String?,
//       string: json['string'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'day': day,
//       'time': time,
//       'timezone': timezone,
//       'string': string,
//     };
//   }
// }

// class AnimeGenreModel extends AnimeGenre {
//   const AnimeGenreModel({
//     required super.malId,
//     required super.type,
//     required super.name,
//     required super.url,
//   });

//   factory AnimeGenreModel.fromJson(Map<String, dynamic> json) {
//     return AnimeGenreModel(
//       malId: json['mal_id'] as int,
//       type: json['type'] as String,
//       name: json['name'] as String,
//       url: json['url'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'mal_id': malId,
//       'type': type,
//       'name': name,
//       'url': url,
//     };
//   }
// }