// lib/features/auth/domain/usecases/signup_usecase.dart

import 'package:fpdart/fpdart.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<Either<String, UserEntity>> call({
    required String email,
    required String password,
    required String displayName,
  }) async {
    // Validate input
    if (email.isEmpty || password.isEmpty || displayName.isEmpty) {
      return left('All fields are required');
    }
    
    if (!_isValidEmail(email)) {
      return left('Please enter a valid email address');
    }
    
    if (password.length < 6) {
      return left('Password must be at least 6 characters long');
    }
    
    // Proceed with signup
    return await repository.signup(email, password, displayName);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}