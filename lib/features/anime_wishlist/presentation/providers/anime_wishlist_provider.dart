import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/presentation/riverpod/auth_provider.dart';
import '../../domain/entities/anime_wishlist.dart';
import '../../domain/usecases/add_to_wishlist.dart';
import '../../domain/usecases/get_user_wishlist.dart';
import '../../domain/usecases/is_in_wishlist.dart';
import '../../domain/usecases/remove_from_wishlist.dart';

// Use case providers
final addToWishlistProvider = Provider<AddToWishlist>((ref) {
  return GetIt.instance<AddToWishlist>();
});

final removeFromWishlistProvider = Provider<RemoveFromWishlist>((ref) {
  return GetIt.instance<RemoveFromWishlist>();
});

final getUserWishlistProvider = Provider<GetUserWishlist>((ref) {
  return GetIt.instance<GetUserWishlist>();
});

final isInWishlistProvider = Provider<IsInWishlist>((ref) {
  return GetIt.instance<IsInWishlist>();
});

// Wishlist state
class WishlistState {
  final List<AnimeWishlist> wishlist;
  final bool isLoading;
  final String? error;
  final Map<int, bool> wishlistStatus; // animeId -> isInWishlist
  final bool isInitialized;

  const WishlistState({
    this.wishlist = const [],
    this.isLoading = false,
    this.error,
    this.wishlistStatus = const {},
    this.isInitialized = false,
  });

  WishlistState copyWith({
    List<AnimeWishlist>? wishlist,
    bool? isLoading,
    String? error,
    Map<int, bool>? wishlistStatus,
    bool? isInitialized,
  }) {
    return WishlistState(
      wishlist: wishlist ?? this.wishlist,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      wishlistStatus: wishlistStatus ?? this.wishlistStatus,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

// Wishlist notifier
class WishlistNotifier extends StateNotifier<WishlistState> {
  final AddToWishlist _addToWishlist;
  final RemoveFromWishlist _removeFromWishlist;
  final GetUserWishlist _getUserWishlist;
  final IsInWishlist _isInWishlist;
  final String? userEmail;

  WishlistNotifier({
    required AddToWishlist addToWishlist,
    required RemoveFromWishlist removeFromWishlist,
    required GetUserWishlist getUserWishlist,
    required IsInWishlist isInWishlist,
    this.userEmail,
  })  : _addToWishlist = addToWishlist,
        _removeFromWishlist = removeFromWishlist,
        _getUserWishlist = getUserWishlist,
        _isInWishlist = isInWishlist,
        super(const WishlistState()) {
    // Auto-load wishlist when notifier is created with a valid userEmail
    if (userEmail != null && userEmail!.isNotEmpty) {
      _initializeWishlist();
    }
  }

  Future<void> _initializeWishlist() async {
    // Add a small delay to ensure Supabase is ready
    await Future.delayed(const Duration(milliseconds: 100));
    await loadWishlist();
  }

  Future<void> loadWishlist() async {
    if (userEmail == null || userEmail!.isEmpty) {
      print('No user email found for wishlist');
      state = state.copyWith(
        isInitialized: true,
        isLoading: false,
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      print('Loading wishlist for user: $userEmail');
      final result = await _getUserWishlist(GetUserWishlistParams(userEmail: userEmail!));

      result.fold(
        (failure) {
          print('Error loading wishlist: ${_mapFailureToMessage(failure)}');
          state = state.copyWith(
            isLoading: false,
            isInitialized: true,
            error: _mapFailureToMessage(failure),
          );
        },
        (wishlist) {
          print('Loaded ${wishlist.length} items from wishlist for user: $userEmail');
          final statusMap = <int, bool>{};
          for (var item in wishlist) {
            statusMap[item.animeId] = true;
          }
          state = state.copyWith(
            wishlist: wishlist,
            isLoading: false,
            isInitialized: true,
            wishlistStatus: statusMap,
          );
        },
      );
    } catch (e) {
      print('Exception loading wishlist: $e');
      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        error: e.toString(),
      );
    }
  }

  Future<bool> toggleWishlist(AnimeWishlist anime) async {
    if (userEmail == null || userEmail!.isEmpty) {
      print('No user email found');
      return false;
    }

    final isCurrentlyInWishlist = state.wishlistStatus[anime.animeId] ?? false;

    if (isCurrentlyInWishlist) {
      // Remove from wishlist
      print('Removing anime ${anime.animeId} from wishlist');
      final result = await _removeFromWishlist(
        RemoveFromWishlistParams(userEmail: userEmail!, animeId: anime.animeId),
      );

      return result.fold(
        (failure) {
          print('Error removing from wishlist: ${_mapFailureToMessage(failure)}');
          state = state.copyWith(error: _mapFailureToMessage(failure));
          return false;
        },
        (_) {
          print('Successfully removed anime ${anime.animeId} from wishlist');
          final updatedStatus = Map<int, bool>.from(state.wishlistStatus);
          updatedStatus[anime.animeId] = false;
          final updatedWishlist = state.wishlist
              .where((item) => item.animeId != anime.animeId)
              .toList();
          state = state.copyWith(
            wishlist: updatedWishlist,
            wishlistStatus: updatedStatus,
          );
          return true;
        },
      );
    } else {
      // Add to wishlist
      print('Adding anime ${anime.animeId} to wishlist');
      final result = await _addToWishlist(AddToWishlistParams(anime: anime));

      return result.fold(
        (failure) {
          print('Error adding to wishlist: ${_mapFailureToMessage(failure)}');
          state = state.copyWith(error: _mapFailureToMessage(failure));
          return false;
        },
        (_) {
          print('Successfully added anime ${anime.animeId} to wishlist');
          final updatedStatus = Map<int, bool>.from(state.wishlistStatus);
          updatedStatus[anime.animeId] = true;
          final updatedWishlist = [...state.wishlist, anime];
          state = state.copyWith(
            wishlist: updatedWishlist,
            wishlistStatus: updatedStatus,
          );
          return true;
        },
      );
    }
  }

  Future<void> checkWishlistStatus(int animeId) async {
    if (userEmail == null || userEmail!.isEmpty) return;

    final result = await _isInWishlist(
      IsInWishlistParams(userEmail: userEmail!, animeId: animeId),
    );

    result.fold(
      (failure) {
        print('Error checking wishlist status: ${_mapFailureToMessage(failure)}');
      },
      (isInWishlist) {
        final updatedStatus = Map<int, bool>.from(state.wishlistStatus);
        updatedStatus[animeId] = isInWishlist;
        state = state.copyWith(wishlistStatus: updatedStatus);
      },
    );
  }

  bool isInWishlist(int animeId) {
    return state.wishlistStatus[animeId] ?? false;
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return (failure as ServerFailure).message;
      case NetworkFailure _:
        return 'Network Error';
      case CacheFailure _:
        return 'Cache Error';
      default:
        return 'Unexpected Error: ${failure.toString()}';
    }
  }
}

// Global provider
final wishlistProvider = StateNotifierProvider<WishlistNotifier, WishlistState>((ref) {
  final auth = ref.watch(authProvider);
  final userEmail = auth.user?.email;

  print('Creating wishlist provider with email: $userEmail');

  return WishlistNotifier(
    addToWishlist: ref.watch(addToWishlistProvider),
    removeFromWishlist: ref.watch(removeFromWishlistProvider),
    getUserWishlist: ref.watch(getUserWishlistProvider),
    isInWishlist: ref.watch(isInWishlistProvider),
    userEmail: userEmail,
  );
});
