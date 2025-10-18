import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/datasources/profile_remote_datasource.dart';
import '../../domain/entities/profile_entity.dart';
import '../models/profile_model.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabaseClient;

  ProfileRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<ProfileEntity> getProfile(String userId) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select()
          .eq('user_id', userId)
          .single();

      return ProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  @override
  Future<ProfileEntity> createProfile(ProfileEntity profile) async {
    try {
      final profileModel = ProfileModel.fromEntity(profile);
      final profileData = profileModel.toJson();
      
      // Remove null values and add timestamps
      profileData.removeWhere((key, value) => value == null);
      profileData['created_at'] = DateTime.now().toIso8601String();
      profileData['updated_at'] = DateTime.now().toIso8601String();

      final response = await supabaseClient
          .from('profiles')
          .insert(profileData)
          .select()
          .single();

      return ProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  @override
  Future<ProfileEntity> updateProfile(ProfileEntity profile) async {
    try {
      final profileModel = ProfileModel.fromEntity(profile);
      final profileData = profileModel.toJson();
      
      // Remove null values and update timestamp
      profileData.removeWhere((key, value) => value == null);
      profileData['updated_at'] = DateTime.now().toIso8601String();
      profileData.remove('created_at'); // Don't update created_at

      final response = await supabaseClient
          .from('profiles')
          .update(profileData)
          .eq('user_id', profile.userId)
          .select()
          .single();

      return ProfileModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> deleteProfile(String userId) async {
    try {
      await supabaseClient
          .from('profiles')
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  /// Get profile by email address
  @override
  Future<ProfileEntity> getProfileByEmail(String email) async {
    try {
      print('🔍 Starting profile fetch for email: $email');
      
      // First, let's test if we can connect to Supabase at all
      try {
        print('🧪 Testing Supabase connection...');
        await supabaseClient
            .from('profiles')
            .select('count')
            .count(CountOption.exact);
        print('✅ Supabase connection successful. Table exists.');
      } catch (testError) {
        print('❌ Supabase connection test failed: $testError');
        throw Exception('Cannot connect to Supabase: $testError');
      }

      print('🔍 Fetching profile for email: $email');
      
      // Try the actual query
      final response = await supabaseClient
          .from('profiles')
          .select()
          .eq('email', email)
          .maybeSingle();

      print('📦 Supabase response: $response');

      if (response == null) {
        print('🚫 No profile found for email: $email');
        throw Exception('No profile found for email: $email');
      }

      final profile = ProfileModel.fromJson(response);
      print('✅ Profile fetched successfully: ${profile.email}');
      return profile;
    } catch (e) {
      print('❌ Error fetching profile by email: $e');
      print('📊 Error type: ${e.runtimeType}');
      rethrow; // Rethrow to preserve original error
    }
  }
}