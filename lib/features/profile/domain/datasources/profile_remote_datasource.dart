import '../entities/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity> getProfile(String userId);
  Future<ProfileEntity> getProfileByEmail(String email);
  Future<ProfileEntity> createProfile(ProfileEntity profile);
  Future<ProfileEntity> updateProfile(ProfileEntity profile);
  Future<void> deleteProfile(String userId);
}