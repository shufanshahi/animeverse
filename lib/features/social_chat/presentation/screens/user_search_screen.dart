import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/riverpod/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../profile/domain/usecases/get_profile_usecase.dart';
import '../../../profile/domain/usecases/get_profile_by_email_usecase.dart';
import '../../../profile/domain/usecases/create_profile_usecase.dart';
import '../../../profile/domain/usecases/update_profile_usecase.dart';
import '../providers/user_search_provider.dart';
import '../widgets/user_search_item.dart';

// Add providers for profile usecases
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) => sl());
final getProfileByEmailUseCaseProvider = Provider<GetProfileByEmailUseCase>((ref) => sl());
final createProfileUseCaseProvider = Provider<CreateProfileUseCase>((ref) => sl());
final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) => sl());

class UserSearchScreen extends ConsumerStatefulWidget {
  const UserSearchScreen({super.key});

  @override
  ConsumerState<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends ConsumerState<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _currentUserProfileId;

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
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(userSearchProvider);
    final authState = ref.watch(authProvider);
    final currentUserEmail = authState.user?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(userSearchProvider.notifier).clearSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                ref.read(userSearchProvider.notifier).searchUsers(value);
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: _currentUserProfileId == null
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
                : searchState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : searchState.error != null
                        ? Center(child: Text(searchState.error!))
                        : searchState.users.isEmpty
                            ? const Center(
                                child: Text('Search for users to add as friends'),
                              )
                            : ListView.builder(
                                itemCount: searchState.users.length,
                                itemBuilder: (context, index) {
                                  final user = searchState.users[index];
                                  // Filter out current user by email
                                  if (user.email == currentUserEmail) {
                                    return const SizedBox.shrink();
                                  }
                                  return UserSearchItem(
                                    user: user,
                                    currentUserId: _currentUserProfileId!,
                                    currentUserEmail: currentUserEmail,
                                  );
                                },
                              ),
          ),
        ],
      ),
    );
  }
}
