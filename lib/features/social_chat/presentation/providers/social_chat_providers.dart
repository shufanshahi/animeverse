import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/social_chat_remote_datasource.dart';
import '../../data/repositories/social_chat_repository_impl.dart';
import '../../domain/repositories/social_chat_repository.dart';
import '../../domain/usecases/search_users_usecase.dart';
import '../../domain/usecases/send_friend_request_usecase.dart';
import '../../domain/usecases/get_pending_requests_usecase.dart';
import '../../domain/usecases/accept_friend_request_usecase.dart';
import '../../domain/usecases/reject_friend_request_usecase.dart';
import '../../domain/usecases/get_friends_usecase.dart';
import '../../domain/usecases/are_friends_usecase.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/mark_message_read_usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';

// Data Source Provider
final socialChatRemoteDataSourceProvider = Provider<SocialChatRemoteDataSource>((ref) {
  return SocialChatRemoteDataSourceImpl(
    supabaseClient: Supabase.instance.client,
  );
});

// Repository Provider
final socialChatRepositoryProvider = Provider<SocialChatRepository>((ref) {
  return SocialChatRepositoryImpl(
    remoteDataSource: ref.read(socialChatRemoteDataSourceProvider),
  );
});

// Use Case Providers
final searchUsersUseCaseProvider = Provider<SearchUsersUseCase>((ref) {
  return SearchUsersUseCase(ref.read(socialChatRepositoryProvider));
});

final sendFriendRequestUseCaseProvider = Provider<SendFriendRequestUseCase>((ref) {
  return SendFriendRequestUseCase(ref.read(socialChatRepositoryProvider));
});

final getPendingRequestsUseCaseProvider = Provider<GetPendingRequestsUseCase>((ref) {
  return GetPendingRequestsUseCase(ref.read(socialChatRepositoryProvider));
});

final acceptFriendRequestUseCaseProvider = Provider<AcceptFriendRequestUseCase>((ref) {
  return AcceptFriendRequestUseCase(ref.read(socialChatRepositoryProvider));
});

final rejectFriendRequestUseCaseProvider = Provider<RejectFriendRequestUseCase>((ref) {
  return RejectFriendRequestUseCase(ref.read(socialChatRepositoryProvider));
});

final getFriendsUseCaseProvider = Provider<GetFriendsUseCase>((ref) {
  return GetFriendsUseCase(ref.read(socialChatRepositoryProvider));
});

final areFriendsUseCaseProvider = Provider<AreFriendsUseCase>((ref) {
  return AreFriendsUseCase(ref.read(socialChatRepositoryProvider));
});

final getMessagesUseCaseProvider = Provider<GetMessagesUseCase>((ref) {
  return GetMessagesUseCase(ref.read(socialChatRepositoryProvider));
});

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  return SendMessageUseCase(ref.read(socialChatRepositoryProvider));
});

final markMessageReadUseCaseProvider = Provider<MarkMessageReadUseCase>((ref) {
  return MarkMessageReadUseCase(ref.read(socialChatRepositoryProvider));
});

final getUnreadCountUseCaseProvider = Provider<GetUnreadCountUseCase>((ref) {
  return GetUnreadCountUseCase(ref.read(socialChatRepositoryProvider));
});
