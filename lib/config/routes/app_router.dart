import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/animeDetails/presentation/screens/anime_detail_screen.dart';
import '../../features/anime_wishlist/presentation/screens/anime_wishlist_screen.dart';
import '../../features/auth/presentation/riverpod/auth_provider.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/main_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/search_screen/presentation/screens/screens.dart';
import '../../features/social_chat/presentation/screens/user_search_screen.dart';
import '../../features/social_chat/presentation/screens/friend_requests_screen.dart';
import '../../features/social_chat/presentation/screens/friends_list_screen.dart';
import '../../features/shop/presentation/screens/cart_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

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
  static const profile = 'profile';
  static const searchUsers = 'searchUsers';
  static const friendRequests = 'friendRequests';
  static const friends = 'friends';
  static const chat = 'chat';
  static const cart = 'cart';
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
        builder: (context, state) => const SplashScreen(),
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
        path: '/main',
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
      GoRoute(
        path: '/profile',
        name: AppRouteName.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/search-users',
        name: AppRouteName.searchUsers,
        builder: (context, state) => const UserSearchScreen(),
      ),
      GoRoute(
        path: '/friend-requests',
        name: AppRouteName.friendRequests,
        builder: (context, state) => const FriendRequestsScreen(),
      ),
      GoRoute(
        path: '/friends',
        name: AppRouteName.friends,
        builder: (context, state) => const FriendsListScreen(),
      ),
      GoRoute(
        path: '/cart',
        name: AppRouteName.cart,
        builder: (context, state) => const CartScreen(),
      ),
    ],
    redirect: (context, state) {
      final atSplash = state.matchedLocation == '/';
      final atAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/forgot-password';

      // Always allow splash screen
      if (atSplash) {
        return null;
      }

      // Redirect logic after splash
      if (!isLoggedIn) {
        return atAuth ? null : '/login';
      }
      if (atAuth) {
        return '/main';
      }
      return null;
    },
  );
});
