// lib/features/auth/domain/repositories/auth_repository.dart

import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> signup(String email, String password, String displayName);
  Future<void> forgotPassword(String email);
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}