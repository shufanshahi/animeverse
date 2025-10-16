import '../../domain/entities/anime_wishlist.dart';

class AnimeWishlistModel extends AnimeWishlist {
  const AnimeWishlistModel({
    required super.id,
    required super.userId,
    required super.animeId,
    required super.title,
    super.imageUrl,
    super.score,
    super.type,
    super.episodes,
    required super.addedAt,
  });

  factory AnimeWishlistModel.fromJson(Map<String, dynamic> json) {
    return AnimeWishlistModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_email'] as String, // Changed from user_id to user_email
      animeId: json['anime_id'] as int,
      title: json['title'] as String,
      imageUrl: json['image_url'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      type: json['type'] as String?,
      episodes: json['episodes'] as int?,
      addedAt: DateTime.parse(json['added_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_email': userId, // Changed from user_id to user_email
      'anime_id': animeId,
      'title': title,
      'image_url': imageUrl,
      'score': score,
      'type': type,
      'episodes': episodes,
      'added_at': addedAt.toIso8601String(),
    };
  }

  factory AnimeWishlistModel.fromEntity(AnimeWishlist entity) {
    return AnimeWishlistModel(
      id: entity.id,
      userId: entity.userId,
      animeId: entity.animeId,
      title: entity.title,
      imageUrl: entity.imageUrl,
      score: entity.score,
      type: entity.type,
      episodes: entity.episodes,
      addedAt: entity.addedAt,
    );
  }
}
