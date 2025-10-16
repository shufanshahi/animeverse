import 'package:equatable/equatable.dart';

class AnimeWishlist extends Equatable {
  final String id;
  final String userId;
  final int animeId;
  final String title;
  final String? imageUrl;
  final double? score;
  final String? type;
  final int? episodes;
  final DateTime addedAt;

  const AnimeWishlist({
    required this.id,
    required this.userId,
    required this.animeId,
    required this.title,
    this.imageUrl,
    this.score,
    this.type,
    this.episodes,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        animeId,
        title,
        imageUrl,
        score,
        type,
        episodes,
        addedAt,
      ];
}
