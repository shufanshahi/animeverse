import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

// Service Provider
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

// DataSource Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final firebaseAuthService = ref.read(firebaseAuthServiceProvider);
  return AuthRemoteDataSourceImpl(firebaseAuthService);
});

// Repository Provider
final authRepositoryProvider = Provider((ref) {
  final dataSource = ref.read(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

// UseCase Providers
final loginUseCaseProvider = Provider((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUseCase(repository);
});

final signupUseCaseProvider = Provider((ref) {
  final repository = ref.read(authRepositoryProvider);
  return SignupUseCase(repository);
});

final forgotPasswordUseCaseProvider = Provider((ref) {
  final repository = ref.read(authRepositoryProvider);
  return ForgotPasswordUseCase(repository);
});
