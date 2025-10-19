import '../../domain/entities/friendship_entity.dart';

class FriendshipModel extends FriendshipEntity {
  const FriendshipModel({
    required super.id,
    required super.userId1,
    required super.userId2,
    required super.createdAt,
  });

  factory FriendshipModel.fromJson(Map<String, dynamic> json) {
    return FriendshipModel(
      id: json['id'] ?? '',
      userId1: json['user_id_1'] ?? '',
      userId2: json['user_id_2'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id_1': userId1,
      'user_id_2': userId2,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
