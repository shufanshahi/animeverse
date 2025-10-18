import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_profile_by_email_usecase.dart';
import '../../domain/usecases/create_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

class ProfileState {
  final ProfileEntity? profile;
  final bool isLoading;
  final String? error;
  final bool isEditing;

  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
    this.isEditing = false,
  });

  ProfileState copyWith({
    ProfileEntity? profile,
    bool? isLoading,
    String? error,
    bool? isEditing,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isEditing: isEditing ?? this.isEditing,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final GetProfileByEmailUseCase getProfileByEmailUseCase;
  final CreateProfileUseCase createProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileNotifier({
    required this.getProfileUseCase,
    required this.getProfileByEmailUseCase,
    required this.createProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(const ProfileState());

  Future<void> getProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getProfileUseCase(GetProfileParams(userId: userId));

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: 'Failed to load profile',
      ),
      (profile) => state = state.copyWith(
        isLoading: false,
        profile: profile,
        error: null,
      ),
    );
  }

  Future<void> getProfileByEmail(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getProfileByEmailUseCase(GetProfileByEmailParams(email: email));

    result.fold(
      (failure) {
        // If profile not found, don't set error - just leave profile as null
        // so user can create a new profile
        print('🔍 Profile not found for $email, user can create new profile');
        state = state.copyWith(
          isLoading: false,
          profile: null,
          error: null, // Don't show error for missing profile
        );
      },
      (profile) => state = state.copyWith(
        isLoading: false,
        profile: profile,
        error: null,
      ),
    );
  }

  Future<void> createProfile(ProfileEntity profile) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await createProfileUseCase(CreateProfileParams(profile: profile));

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: 'Failed to create profile',
      ),
      (createdProfile) => state = state.copyWith(
        isLoading: false,
        profile: createdProfile,
        error: null,
      ),
    );
  }

  Future<void> updateProfile(ProfileEntity profile) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await updateProfileUseCase(UpdateProfileParams(profile: profile));

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: 'Failed to update profile',
      ),
      (updatedProfile) => state = state.copyWith(
        isLoading: false,
        profile: updatedProfile,
        error: null,
        isEditing: false,
      ),
    );
  }

  void toggleEditing() {
    state = state.copyWith(isEditing: !state.isEditing);
  }

  void cancelEditing() {
    state = state.copyWith(isEditing: false);
  }
}