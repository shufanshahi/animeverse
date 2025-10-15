import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../state/auth_state.dart';
import 'providers.dart';

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
        super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _loginUseCase(email: email, password: password);
    result.fold(
      (error) => state = state.copyWith(
        isLoading: false,
        error: error,
      ),
      (user) => state = state.copyWith(
        isLoading: false,
        user: user,
      ),
    );
  }

  Future<void> signup(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _signupUseCase(displayName: "SignUp",email: email, password: password);
    result.fold(
      (error) => state = state.copyWith(
        isLoading: false,
        error: error,
      ),
      (user) => state = state.copyWith(
        isLoading: false,
        user: user,
      ),
    );
  }

  Future<void> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _forgotPasswordUseCase(email: email);
    result.fold(
      (error) => state = state.copyWith(
        isLoading: false,
        error: error,
      ),
      (_) => state = state.copyWith(
        isLoading: false,
      ),
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.read(loginUseCaseProvider),
    signupUseCase: ref.read(signupUseCaseProvider),
    forgotPasswordUseCase: ref.read(forgotPasswordUseCaseProvider),
  );
});
