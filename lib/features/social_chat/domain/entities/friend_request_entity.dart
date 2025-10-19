import 'package:equatable/equatable.dart';

class FriendRequestEntity extends Equatable {
  final String id;
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String receiverEmail;
  final String status; // pending, accepted, rejected
  final DateTime createdAt;
  final DateTime? updatedAt;

  const FriendRequestEntity({
    required this.id,
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.receiverEmail,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';

  @override
  List<Object?> get props => [
        id,
        senderId,
        senderEmail,
        receiverId,
        receiverEmail,
        status,
        createdAt,
        updatedAt,
      ];
}
