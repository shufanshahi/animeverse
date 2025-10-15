import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../state/auth_state.dart';
import 'providers.dart';

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

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
  })  : _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        super(const AuthState()) {
    // Initialize by checking current user
    _initializeAuthState();
  }

  void _initializeAuthState() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.email != null) {
      state = state.copyWith(
        user: UserEntity(
          uid: currentUser.uid,
          email: currentUser.email!,
          displayName: currentUser.displayName,
        ),
      );
    }

    // Listen to auth state changes
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      if (firebaseUser == null || firebaseUser.email == null) {
        state = const AuthState();
      } else {
        state = state.copyWith(
          user: UserEntity(
            uid: firebaseUser.uid,
            email: firebaseUser.email!,
            displayName: firebaseUser.displayName,
          ),
        );
      }
    });
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _loginUseCase(email: email, password: password);
      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error),
        (user) => state = state.copyWith(isLoading: false, user: user),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // The auth state listener will handle updating the state
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _signupUseCase(
        email: email,
        password: password,
        displayName: displayName,
      );
      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error),
        (user) => state = state.copyWith(isLoading: false, user: user),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> forgotPassword({required String email}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _forgotPasswordUseCase(email: email);
      result.fold(
        (error) => state = state.copyWith(isLoading: false, error: error),
        (_) => state = state.copyWith(isLoading: false),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
