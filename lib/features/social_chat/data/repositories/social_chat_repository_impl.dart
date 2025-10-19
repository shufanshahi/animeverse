import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/user_search_entity.dart';
import '../../domain/entities/friend_request_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/social_chat_repository.dart';
import '../datasources/social_chat_remote_datasource.dart';

class SocialChatRepositoryImpl implements SocialChatRepository {
  final SocialChatRemoteDataSource remoteDataSource;

  SocialChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<UserSearchEntity>>> searchUsers(String query) async {
    try {
      final result = await remoteDataSource.searchUsers(query);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserSearchEntity>> getUserById(String userId) async {
    try {
      final result = await remoteDataSource.getUserById(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FriendRequestEntity>> sendFriendRequest({
    required String senderId,
    required String senderEmail,
    required String receiverId,
    required String receiverEmail,
  }) async {
    try {
      final result = await remoteDataSource.sendFriendRequest(
        senderId: senderId,
        senderEmail: senderEmail,
        receiverId: receiverId,
        receiverEmail: receiverEmail,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FriendRequestEntity>>> getPendingFriendRequests(String userId) async {
    try {
      final result = await remoteDataSource.getPendingFriendRequests(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FriendRequestEntity>> acceptFriendRequest(String requestId) async {
    try {
      final result = await remoteDataSource.acceptFriendRequest(requestId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectFriendRequest(String requestId) async {
    try {
      await remoteDataSource.rejectFriendRequest(requestId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserSearchEntity>>> getFriends(String userId) async {
    try {
      final result = await remoteDataSource.getFriends(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> areFriends(String userId1, String userId2) async {
    try {
      final result = await remoteDataSource.areFriends(userId1, userId2);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getMessages({
    required String userId1,
    required String userId2,
  }) async {
    try {
      final result = await remoteDataSource.getMessages(
        userId1: userId1,
        userId2: userId2,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      final result = await remoteDataSource.sendMessage(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markMessageAsRead(String messageId) async {
    try {
      await remoteDataSource.markMessageAsRead(messageId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadMessageCount(String userId, String friendId) async {
    try {
      final result = await remoteDataSource.getUnreadMessageCount(userId, friendId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
