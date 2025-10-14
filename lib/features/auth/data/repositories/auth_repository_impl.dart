// lib/features/auth/data/repositories/auth_repository_impl.dart

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      return UserEntity(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserEntity> signup(String email, String password, String displayName) async {
    try {
      final user = await remoteDataSource.signup(email, password, displayName);
      return UserEntity(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = remoteDataSource.getCurrentUser();
      if (user == null) return null;
      
      return UserEntity(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName,
      );
    } catch (e) {
      return null;
    }
  }
}