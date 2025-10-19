import 'package:equatable/equatable.dart';

class UserSearchEntity extends Equatable {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime? createdAt;

  const UserSearchEntity({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [userId, email, firstName, lastName, createdAt];
}
