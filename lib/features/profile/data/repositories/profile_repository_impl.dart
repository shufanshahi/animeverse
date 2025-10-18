import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource_impl.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSourceImpl remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String userId) async {
    try {
      final profile = await remoteDataSource.getProfile(userId);
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> getProfileByEmail(String email) async {
    try {
      final profile = await remoteDataSource.getProfileByEmail(email);
      return Right(profile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> createProfile(ProfileEntity profile) async {
    try {
      final createdProfile = await remoteDataSource.createProfile(profile);
      return Right(createdProfile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile) async {
    try {
      final updatedProfile = await remoteDataSource.updateProfile(profile);
      return Right(updatedProfile);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile(String userId) async {
    try {
      await remoteDataSource.deleteProfile(userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}