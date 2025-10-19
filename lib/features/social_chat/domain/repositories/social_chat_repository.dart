import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_search_entity.dart';
import '../entities/friend_request_entity.dart';
import '../entities/chat_message_entity.dart';

abstract class SocialChatRepository {
  // User Search
  Future<Either<Failure, List<UserSearchEntity>>> searchUsers(String query);
  Future<Either<Failure, UserSearchEntity>> getUserById(String userId);
  
  // Friend Requests
  Future<Either<Failure, FriendRequestEntity>> sendFriendRequest({
    required String senderId,
    required String senderEmail,
    required String receiverId,
    required String receiverEmail,
  });
  Future<Either<Failure, List<FriendRequestEntity>>> getPendingFriendRequests(String userId);
  Future<Either<Failure, FriendRequestEntity>> acceptFriendRequest(String requestId);
  Future<Either<Failure, void>> rejectFriendRequest(String requestId);
  
  // Friendships
  Future<Either<Failure, List<UserSearchEntity>>> getFriends(String userId);
  Future<Either<Failure, bool>> areFriends(String userId1, String userId2);
  
  // Chat Messages
  Future<Either<Failure, List<ChatMessageEntity>>> getMessages({
    required String userId1,
    required String userId2,
  });
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  });
  Future<Either<Failure, void>> markMessageAsRead(String messageId);
  Future<Either<Failure, int>> getUnreadMessageCount(String userId, String friendId);
}
