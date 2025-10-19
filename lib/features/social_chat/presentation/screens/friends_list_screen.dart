import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/riverpod/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../profile/domain/usecases/get_profile_usecase.dart';
import '../../../profile/domain/usecases/get_profile_by_email_usecase.dart';
import '../../../profile/domain/usecases/create_profile_usecase.dart';
import '../../../profile/domain/usecases/update_profile_usecase.dart';
import '../providers/friends_provider.dart';
import '../widgets/friend_list_item.dart';

// Add providers for profile usecases
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) => sl());
final getProfileByEmailUseCaseProvider = Provider<GetProfileByEmailUseCase>((ref) => sl());
final createProfileUseCaseProvider = Provider<CreateProfileUseCase>((ref) => sl());
final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) => sl());

class FriendsListScreen extends ConsumerStatefulWidget {
  const FriendsListScreen({super.key});

  @override
  ConsumerState<FriendsListScreen> createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends ConsumerState<FriendsListScreen> {
  String? _currentUserProfileId;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    // Defer profile loading to after the widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentUserProfile();
    });
  }

  Future<void> _loadCurrentUserProfile() async {
    final authState = ref.read(authProvider);
    if (authState.user?.email != null) {
      // Load the current user's profile to get their Supabase user_id
      final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
        return ProfileNotifier(
          getProfileUseCase: ref.read(getProfileUseCaseProvider),
          getProfileByEmailUseCase: ref.read(getProfileByEmailUseCaseProvider),
          createProfileUseCase: ref.read(createProfileUseCaseProvider),
          updateProfileUseCase: ref.read(updateProfileUseCaseProvider),
        );
      });
      
      await ref.read(profileProvider.notifier).getProfileByEmail(authState.user!.email);
      final profile = ref.read(profileProvider).profile;
      
      if (profile != null && mounted) {
        setState(() {
          _currentUserProfileId = profile.userId;
          _isLoadingProfile = false;
        });
        
        // Now load friends using the Supabase user_id
        ref.read(friendsProvider.notifier).loadFriends(profile.userId);
      } else {
        if (mounted) {
          setState(() {
            _isLoadingProfile = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final friendsState = ref.watch(friendsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        actions: [
          if (_currentUserProfileId != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(friendsProvider.notifier).refresh(_currentUserProfileId!);
              },
            ),
        ],
      ),
      body: _isLoadingProfile
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading your profile...'),
                ],
              ),
            )
          : _currentUserProfileId == null
              ? const Center(
                  child: Text('Please create a profile first'),
                )
              : friendsState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : friendsState.error != null
                      ? Center(child: Text(friendsState.error!))
                      : friendsState.friends.isEmpty
                          ? const Center(
                              child: Text('No friends yet. Search for users to add!'),
                            )
                          : ListView.builder(
                              itemCount: friendsState.friends.length,
                              itemBuilder: (context, index) {
                                final friend = friendsState.friends[index];
                                return FriendListItem(
                                  friend: friend,
                                  currentUserId: _currentUserProfileId!,
                                );
                              },
                            ),
    );
  }
}
