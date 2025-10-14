// lib/features/auth/domain/usecases/signup_usecase.dart

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<UserEntity> call(String email, String password, String displayName) async {
    if (email.isEmpty || password.isEmpty || displayName.isEmpty) {
      throw Exception('All fields are required');
    }
    
    if (!_isValidEmail(email)) {
      throw Exception('Please enter a valid email address');
    }
    
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters long');
    }
    
    return await repository.signup(email, password, displayName);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}