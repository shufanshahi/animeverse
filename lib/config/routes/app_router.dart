import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/riverpod/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';

import '../../features/main_screen.dart';
import '../../features/animeDetails/presentation/screens/anime_detail_screen.dart';
import '../../features/search_screen/presentation/screens/screens.dart';
import '../../features/anime_wishlist/presentation/screens/anime_wishlist_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouteName {
  static const splash = 'splash';
  static const login = 'login';
  static const signup = 'signup';
  static const forgotPassword = 'forgotPassword';
  static const home = 'home';
  static const animeDetail = 'animeDetail';
  static const search = 'search';
  static const wishlist = 'wishlist';
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  final isLoggedIn = auth.user != null;

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRouteName.splash,
        builder: (context, state) => const _SplashGate(),
      ),
      GoRoute(
        path: '/login',
        name: AppRouteName.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: AppRouteName.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: AppRouteName.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        name: AppRouteName.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/anime/:id',
        name: AppRouteName.animeDetail,
        builder: (context, state) {
          final idStr = state.pathParameters['id'] ?? '0';
          final id = int.tryParse(idStr) ?? 0;
          return AnimeDetailScreen(animeId: id);
        },
      ),
      GoRoute(
        path: '/search',
        name: AppRouteName.search,
        builder: (context, state) {
          final q = state.uri.queryParameters['q'];
          return SearchScreen(initialQuery: q);
        },
      ),
      GoRoute(
        path: '/wishlist',
        name: AppRouteName.wishlist,
        builder: (context, state) => const AnimeWishlistScreen(),
      ),
    ],
    redirect: (context, state) {
      final atAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/forgot-password';

      if (!isLoggedIn) {
        return atAuth ? null : '/login';
      }
      if (atAuth || state.matchedLocation == '/') {
        return '/home';
      }
      return null;
    },
  );
});

class _SplashGate extends ConsumerWidget {
  const _SplashGate({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
