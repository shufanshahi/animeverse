import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/friend_request_entity.dart';
import '../../domain/usecases/send_friend_request_usecase.dart';
import '../../domain/usecases/get_pending_requests_usecase.dart';
import '../../domain/usecases/accept_friend_request_usecase.dart';
import '../../domain/usecases/reject_friend_request_usecase.dart';
import 'social_chat_providers.dart';

class FriendRequestState {
  final List<FriendRequestEntity> pendingRequests;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const FriendRequestState({
    this.pendingRequests = const [],
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  FriendRequestState copyWith({
    List<FriendRequestEntity>? pendingRequests,
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return FriendRequestState(
      pendingRequests: pendingRequests ?? this.pendingRequests,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

class FriendRequestNotifier extends StateNotifier<FriendRequestState> {
  final SendFriendRequestUseCase _sendFriendRequestUseCase;
  final GetPendingRequestsUseCase _getPendingRequestsUseCase;
  final AcceptFriendRequestUseCase _acceptFriendRequestUseCase;
  final RejectFriendRequestUseCase _rejectFriendRequestUseCase;

  FriendRequestNotifier(
    this._sendFriendRequestUseCase,
    this._getPendingRequestsUseCase,
    this._acceptFriendRequestUseCase,
    this._rejectFriendRequestUseCase,
  ) : super(const FriendRequestState());

  Future<void> sendFriendRequest({
    required String senderId,
    required String senderEmail,
    required String receiverId,
    required String receiverEmail,
  }) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    final result = await _sendFriendRequestUseCase(
      SendFriendRequestParams(
        senderId: senderId,
        senderEmail: senderEmail,
        receiverId: receiverId,
        receiverEmail: receiverEmail,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: 'Failed to send friend request',
      ),
      (request) => state = state.copyWith(
        isLoading: false,
        successMessage: 'Friend request sent successfully',
      ),
    );
  }

  Future<void> loadPendingRequests(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getPendingRequestsUseCase(
      GetPendingRequestsParams(userId: userId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: 'Failed to load friend requests',
      ),
      (requests) => state = state.copyWith(
        isLoading: false,
        pendingRequests: requests,
      ),
    );
  }

  Future<void> acceptFriendRequest(String requestId, String userId) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    final result = await _acceptFriendRequestUseCase(
      AcceptFriendRequestParams(requestId: requestId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: 'Failed to accept friend request',
      ),
      (request) async {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Friend request accepted',
        );
        // Reload pending requests
        await loadPendingRequests(userId);
      },
    );
  }

  Future<void> rejectFriendRequest(String requestId, String userId) async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);

    final result = await _rejectFriendRequestUseCase(
      RejectFriendRequestParams(requestId: requestId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: 'Failed to reject friend request',
      ),
      (_) async {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Friend request rejected',
        );
        // Reload pending requests
        await loadPendingRequests(userId);
      },
    );
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

final friendRequestProvider = StateNotifierProvider<FriendRequestNotifier, FriendRequestState>((ref) {
  return FriendRequestNotifier(
    ref.read(sendFriendRequestUseCaseProvider),
    ref.read(getPendingRequestsUseCaseProvider),
    ref.read(acceptFriendRequestUseCaseProvider),
    ref.read(rejectFriendRequestUseCaseProvider),
  );
});
