import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/riverpod/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/friend_request_provider.dart';
import '../widgets/friend_request_item.dart';
import '../../../../injection_container.dart';
import '../../../profile/domain/usecases/get_profile_usecase.dart';
import '../../../profile/domain/usecases/get_profile_by_email_usecase.dart';
import '../../../profile/domain/usecases/create_profile_usecase.dart';
import '../../../profile/domain/usecases/update_profile_usecase.dart';

// Add providers for profile usecases
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) => sl());
final getProfileByEmailUseCaseProvider = Provider<GetProfileByEmailUseCase>((ref) => sl());
final createProfileUseCaseProvider = Provider<CreateProfileUseCase>((ref) => sl());
final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) => sl());

class FriendRequestsScreen extends ConsumerStatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  ConsumerState<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends ConsumerState<FriendRequestsScreen> {
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
        
        // Now load pending requests using the Supabase user_id
        ref.read(friendRequestProvider.notifier).loadPendingRequests(profile.userId);
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
    final requestState = ref.watch(friendRequestProvider);

    // Show success or error messages
    ref.listen<FriendRequestState>(friendRequestProvider, (previous, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!)),
        );
        ref.read(friendRequestProvider.notifier).clearMessages();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(friendRequestProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
        actions: [
          if (_currentUserProfileId != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.read(friendRequestProvider.notifier).loadPendingRequests(_currentUserProfileId!);
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
              : requestState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : requestState.pendingRequests.isEmpty
                      ? const Center(
                          child: Text('No pending friend requests'),
                        )
                      : ListView.builder(
                          itemCount: requestState.pendingRequests.length,
                          itemBuilder: (context, index) {
                            final request = requestState.pendingRequests[index];
                            return FriendRequestItem(
                              request: request,
                              currentUserId: _currentUserProfileId!,
                            );
                          },
                        ),
    );
  }
}
