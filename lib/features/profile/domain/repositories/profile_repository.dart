import 'package:dartz/dartz.dart';
import '../../domain/entities/profile_entity.dart';
import '../../../../core/error/failure.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile(String userId);
  Future<Either<Failure, ProfileEntity>> getProfileByEmail(String email);
  Future<Either<Failure, ProfileEntity>> createProfile(ProfileEntity profile);
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, void>> deleteProfile(String userId);
}