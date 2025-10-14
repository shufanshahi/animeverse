// lib/features/auth/domain/repositories/auth_repository.dart

import 'package:fpdart/fpdart.dart';

import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<String, UserEntity>> login(String email, String password);
  Future<Either<String, UserEntity>> signup(String email, String password, String displayName);
  Future<Either<String, Unit>> forgotPassword(String email);
  Future<Either<String, Unit>> logout();
  Future<Either<String, UserEntity?>> getCurrentUser();
}