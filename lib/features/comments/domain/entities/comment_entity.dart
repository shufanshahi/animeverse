import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final String id;
  final int animeId;
  final String userId;
  final String userName;
  final String comment;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CommentEntity({
    required this.id,
    required this.animeId,
    required this.userId,
    required this.userName,
    required this.comment,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  CommentEntity copyWith({
    String? id,
    int? animeId,
    String? userId,
    String? userName,
    String? comment,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommentEntity(
      id: id ?? this.id,
      animeId: animeId ?? this.animeId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      comment: comment ?? this.comment,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        animeId,
        userId,
        userName,
        comment,
        imageUrl,
        createdAt,
        updatedAt,
      ];
}
