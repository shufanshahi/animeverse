import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/animeDetails/presentation/screens/anime_detail_screen.dart';
import '../../features/auth/presentation/riverpod/auth_provider.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      try {
        final authState = ref.read(authProvider);
        final isLoggedIn = authState.user != null;
        final currentPath = state.matchedLocation;
        
        // Allow access to auth-related pages when not logged in
        if (!isLoggedIn) {
          if (currentPath == '/login' || 
              currentPath == '/signup' || 
              currentPath == '/forgot-password') {
            return null;
          }
          return '/login';
        }

        // Redirect to home if logged in and trying to access auth pages
        if (isLoggedIn && (currentPath == '/login' || 
                          currentPath == '/signup' || 
                          currentPath == '/forgot-password')) {
          return '/';
        }

        return null;
      } catch (e) {
        // If there's an error reading auth state, default to login
        print('Router redirect error: $e');
        return '/login';
      }
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/anime/:id',
        name: 'animeDetail',
        builder: (context, state) {
          final idParam = state.pathParameters['id'];
          if (idParam == null) {
            // Redirect to home if no ID provided
            return const HomeScreen();
          }
          
          final animeId = int.tryParse(idParam);
          if (animeId == null) {
            // Redirect to home if ID is not a valid integer
            return const HomeScreen();
          }
          
          return AnimeDetailScreen(animeId: animeId);
        },
      ),
    ],
  );
});
