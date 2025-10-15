// lib/features/auth/domain/entities/user_entity.dart

class UserEntity {
  final String uid;
  final String email;
  final String? displayName;

  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
  });
}