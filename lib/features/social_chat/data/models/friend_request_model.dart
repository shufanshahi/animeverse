import '../../domain/entities/friend_request_entity.dart';

class FriendRequestModel extends FriendRequestEntity {
  const FriendRequestModel({
    required super.id,
    required super.senderId,
    required super.senderEmail,
    required super.receiverId,
    required super.receiverEmail,
    required super.status,
    required super.createdAt,
    super.updatedAt,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      id: json['id'] ?? '',
      senderId: json['sender_id'] ?? '',
      senderEmail: json['sender_email'] ?? '',
      receiverId: json['receiver_id'] ?? '',
      receiverEmail: json['receiver_email'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_email': senderEmail,
      'receiver_id': receiverId,
      'receiver_email': receiverEmail,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
