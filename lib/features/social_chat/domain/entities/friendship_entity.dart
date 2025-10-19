import 'package:equatable/equatable.dart';

class FriendshipEntity extends Equatable {
  final String id;
  final String userId1;
  final String userId2;
  final DateTime createdAt;

  const FriendshipEntity({
    required this.id,
    required this.userId1,
    required this.userId2,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId1, userId2, createdAt];
}
