// lib/features/auth/data/datasources/auth_remote_datasource.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(String email, String password);
  Future<User> signup(String email, String password, String displayName);
  Future<void> forgotPassword(String email);
  Future<void> logout();
  User? getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuthService firebaseAuthService;

  AuthRemoteDataSourceImpl(this.firebaseAuthService);

  @override
  Future<User> login(String email, String password) async {
    return await firebaseAuthService.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<User> signup(String email, String password, String displayName) async {
    return await firebaseAuthService.createUserWithEmailAndPassword(
      email,
      password,
      displayName,
    );
  }

  @override
  Future<void> forgotPassword(String email) async {
    await firebaseAuthService.sendPasswordResetEmail(email);
  }

  @override
  Future<void> logout() async {
    await firebaseAuthService.signOut();
  }

  @override
  User? getCurrentUser() {
    return firebaseAuthService.getCurrentUser();
  }
}