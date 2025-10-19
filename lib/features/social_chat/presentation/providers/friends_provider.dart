import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_search_entity.dart';
import '../../domain/usecases/get_friends_usecase.dart';
import 'social_chat_providers.dart';

class FriendsState {
  final List<UserSearchEntity> friends;
  final bool isLoading;
  final String? error;

  const FriendsState({
    this.friends = const [],
    this.isLoading = false,
    this.error,
  });

  FriendsState copyWith({
    List<UserSearchEntity>? friends,
    bool? isLoading,
    String? error,
  }) {
    return FriendsState(
      friends: friends ?? this.friends,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FriendsNotifier extends StateNotifier<FriendsState> {
  final GetFriendsUseCase _getFriendsUseCase;

  FriendsNotifier(this._getFriendsUseCase) : super(const FriendsState());

  Future<void> loadFriends(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getFriendsUseCase(GetFriendsParams(userId: userId));

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: 'Failed to load friends',
      ),
      (friends) => state = state.copyWith(
        isLoading: false,
        friends: friends,
      ),
    );
  }

  void refresh(String userId) {
    loadFriends(userId);
  }
}

final friendsProvider = StateNotifierProvider<FriendsNotifier, FriendsState>((ref) {
  return FriendsNotifier(ref.read(getFriendsUseCaseProvider));
});
