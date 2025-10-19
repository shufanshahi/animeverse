import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/riverpod/auth_provider.dart';
import '../../domain/entities/profile_entity.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_avatar_generator.dart';
import '../widgets/profile_display.dart';
import '../widgets/profile_form.dart';
import 'supabase_test_screen.dart';
import '../../../../injection_container.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final StateNotifierProvider<ProfileNotifier, ProfileState> profileProvider;

  @override
  void initState() {
    super.initState();
    profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
      return ProfileNotifier(
        getProfileUseCase: sl(),
        getProfileByEmailUseCase: sl(),
        createProfileUseCase: sl(),
        updateProfileUseCase: sl(),
      );
    });

    // Load profile when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = FirebaseAuth.instance.currentUser;
      print('🔥 Firebase user: ${currentUser?.email ?? "No user"}');
      
      if (currentUser != null && currentUser.email != null) {
        print('📧 Fetching profile for email: ${currentUser.email}');
        // Use email to fetch profile from Supabase
        ref.read(profileProvider.notifier).getProfileByEmail(currentUser.email!);
      } else {
        print('👤 No authenticated user, showing empty form');
      }
      // If no user is signed in, the state will remain with profile = null
      // and _buildCreateProfileForm will show empty input fields
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final profileNotifier = ref.read(profileProvider.notifier);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              context.pushReplacementNamed(AppRouteName.login);
            },
            tooltip: 'Logout',
          ),
          // Debug button for testing Supabase
          // IconButton(
          //   icon: const Icon(Icons.bug_report),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const SupabaseTestScreen(),
          //       ),
          //     );
          //   },
          //   tooltip: 'Test Supabase Connection',
          // ),
          if (profileState.profile != null && !profileState.isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => profileNotifier.toggleEditing(),
            ),
          // Language Switcher
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => ref.read(localeProvider.notifier).toggleLanguage(),
            tooltip: AppLocalizations.of(context)!.language,
          ),
          // Theme Switcher
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
            tooltip: themeMode == ThemeMode.dark 
                ? AppLocalizations.of(context)!.lightMode
                : AppLocalizations.of(context)!.darkMode,
          ),
        ],
      ),
      body: _buildBody(context, profileState, profileNotifier),
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state, ProfileNotifier notifier) {
    if (state.isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Show avatar while loading
          ProfileAvatarGenerator.generateConsistentAvatar(
            email: FirebaseAuth.instance.currentUser?.email ?? '',
            size: 80,
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(),
          const SizedBox(height: 10),
          Text(AppLocalizations.of(context)!.loadingProfile),
        ],
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              state.error!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null && currentUser.email != null) {
                  notifier.getProfileByEmail(currentUser.email!);
                }
              },
              child: Text(AppLocalizations.of(context)!.retryButton),
            ),
          ],
        ),
      );
    }

    if (state.profile == null) {
      return _buildCreateProfileForm(context, notifier);
    }

    if (state.isEditing) {
      return ProfileForm(
        profile: state.profile!,
        onSave: (profile) => notifier.updateProfile(profile),
        onCancel: () => notifier.cancelEditing(),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ProfileDisplay(profile: state.profile!),
          _buildSocialChatSection(context),
        ],
      ),
    );
  }

  Widget _buildSocialChatSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(height: 32),
          Text(
            'Social & Chat',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSocialChatCard(
            context: context,
            icon: Icons.search,
            title: 'Search Users',
            subtitle: 'Find and add friends',
            onTap: () => context.push('/search-users'),
          ),
          const SizedBox(height: 12),
          _buildSocialChatCard(
            context: context,
            icon: Icons.person_add,
            title: 'Friend Requests',
            subtitle: 'View pending requests',
            onTap: () => context.push('/friend-requests'),
          ),
          const SizedBox(height: 12),
          _buildSocialChatCard(
            context: context,
            icon: Icons.people,
            title: 'Friends',
            subtitle: 'Chat with your friends',
            onTap: () => context.push('/friends'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSocialChatCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildCreateProfileForm(BuildContext context, ProfileNotifier notifier) {
    final currentUser = FirebaseAuth.instance.currentUser;
    
    // Always show the form with empty fields, even if user is not signed in
    return ProfileForm(
      profile: ProfileEntity(
        userId: currentUser?.uid ?? '', // Use Firebase UID
        email: currentUser?.email ?? '',
        firstName: '',
        lastName: '',
        street: '',
        zip: '',
        state: '',
        phone: '',
      ),
      onSave: (profile) => notifier.createProfile(profile),
      onCancel: null,
    );
  }
}