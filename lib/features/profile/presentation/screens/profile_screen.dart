import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/profile_entity.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_form.dart';
import '../widgets/profile_display.dart';
import '../widgets/profile_avatar_generator.dart';
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
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.profile),
          actions: [
            IconButton(
              icon: Icon(Icons.bug_report),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupabaseTestScreen()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            // Show avatar while loading
            ProfileAvatarGenerator.generateConsistentAvatar(
              email: FirebaseAuth.instance.currentUser?.email ?? '',
              size: 80,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(AppLocalizations.of(context)!.loadingProfile),
          ],
        ),
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

    return ProfileDisplay(profile: state.profile!);
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