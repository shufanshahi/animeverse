import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_search_entity.dart';
import '../../domain/usecases/search_users_usecase.dart';
import 'social_chat_providers.dart';

class UserSearchState {
  final List<UserSearchEntity> users;
  final bool isLoading;
  final String? error;

  const UserSearchState({
    this.users = const [],
    this.isLoading = false,
    this.error,
  });

  UserSearchState copyWith({
    List<UserSearchEntity>? users,
    bool? isLoading,
    String? error,
  }) {
    return UserSearchState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class UserSearchNotifier extends StateNotifier<UserSearchState> {
  final SearchUsersUseCase _searchUsersUseCase;

  UserSearchNotifier(this._searchUsersUseCase) : super(const UserSearchState());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      state = const UserSearchState();
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    final result = await _searchUsersUseCase(SearchUsersParams(query: query));

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.toString(),
      ),
      (users) => state = state.copyWith(
        isLoading: false,
        users: users,
      ),
    );
  }

  void clearSearch() {
    state = const UserSearchState();
  }
}

final userSearchProvider = StateNotifierProvider<UserSearchNotifier, UserSearchState>((ref) {
  return UserSearchNotifier(ref.read(searchUsersUseCaseProvider));
});
