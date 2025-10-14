// lib/features/auth/presentation/providers/auth_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../domain/entities/user_entity.dart';
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

// Auth State
class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  AuthNotifier({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.forgotPasswordUseCase,
  }) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await loginUseCase(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> signup(String email, String password, String displayName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await signupUseCase(email, password, displayName);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await forgotPasswordUseCase(email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.read(loginUseCaseProvider);
  final signupUseCase = ref.read(signupUseCaseProvider);
  final forgotPasswordUseCase = ref.read(forgotPasswordUseCaseProvider);

  return AuthNotifier(
    loginUseCase: loginUseCase,
    signupUseCase: signupUseCase,
    forgotPasswordUseCase: forgotPasswordUseCase,
  );
});