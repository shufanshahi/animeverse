// lib/features/auth/domain/usecases/forgot_password_usecase.dart

import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> call(String email) async {
    if (email.isEmpty) {
      throw Exception('Email cannot be empty');
    }
    
    if (!_isValidEmail(email)) {
      throw Exception('Please enter a valid email address');
    }
    
    return await repository.forgotPassword(email);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}