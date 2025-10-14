import 'package:fpdart/fpdart.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<String, UserEntity>> call({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return Left('Email and password cannot be empty');
      }
    
      if (!_isValidEmail(email)) {
        return Left('Please enter a valid email address');
      }
    
      return await repository.login(email, password);
    } catch (e) {
      return Left(e.toString());
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}