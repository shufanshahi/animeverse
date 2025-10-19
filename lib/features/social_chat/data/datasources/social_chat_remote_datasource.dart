import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_search_model.dart';
import '../models/friend_request_model.dart';
import '../models/chat_message_model.dart';

abstract class SocialChatRemoteDataSource {
  Future<List<UserSearchModel>> searchUsers(String query);
  Future<UserSearchModel> getUserById(String userId);
  Future<FriendRequestModel> sendFriendRequest({
    required String senderId,
    required String senderEmail,
    required String receiverId,
    required String receiverEmail,
  });
  Future<List<FriendRequestModel>> getPendingFriendRequests(String userId);
  Future<FriendRequestModel> acceptFriendRequest(String requestId);
  Future<void> rejectFriendRequest(String requestId);
  Future<List<UserSearchModel>> getFriends(String userId);
  Future<bool> areFriends(String userId1, String userId2);
  Future<List<ChatMessageModel>> getMessages({
    required String userId1,
    required String userId2,
  });
  Future<ChatMessageModel> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  });
  Future<void> markMessageAsRead(String messageId);
  Future<int> getUnreadMessageCount(String userId, String friendId);
}

class SocialChatRemoteDataSourceImpl implements SocialChatRemoteDataSource {
  final SupabaseClient supabaseClient;

  SocialChatRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<UserSearchModel>> searchUsers(String query) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select()
          .or('first_name.ilike.%$query%,last_name.ilike.%$query%')
          .order('first_name');

      return (response as List)
          .map((json) => UserSearchModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }

  @override
  Future<UserSearchModel> getUserById(String userId) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select()
          .eq('user_id', userId)
          .single();

      return UserSearchModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<FriendRequestModel> sendFriendRequest({
    required String senderId,
    required String senderEmail,
    required String receiverId,
    required String receiverEmail,
  }) async {
    try {
      print('🔍 DEBUG: Sending friend request...');
      print('   Sender ID: $senderId');
      print('   Sender Email: $senderEmail');
      print('   Receiver ID: $receiverId');
      print('   Receiver Email: $receiverEmail');
      
      // Check if request already exists
      print('   Checking for existing request...');
      final existing = await supabaseClient
          .from('friend_requests')
          .select()
          .eq('sender_id', senderId)
          .eq('receiver_id', receiverId)
          .maybeSingle();

      if (existing != null) {
        print('❌ Friend request already exists: $existing');
        throw Exception('Friend request already sent');
      }

      print('✅ No existing request found, inserting new one...');
      
      final dataToInsert = {
        'sender_id': senderId,
        'sender_email': senderEmail,
        'receiver_id': receiverId,
        'receiver_email': receiverEmail,
        'status': 'pending',
      };
      print('   Data to insert: $dataToInsert');
      
      final response = await supabaseClient
          .from('friend_requests')
          .insert(dataToInsert)
          .select()
          .single();

      print('✅ Friend request sent successfully!');
      print('   Response: $response');
      
      return FriendRequestModel.fromJson(response);
    } catch (e, stackTrace) {
      print('❌ ERROR sending friend request: $e');
      print('   Error type: ${e.runtimeType}');
      print('   Stack trace: $stackTrace');
      throw Exception('Failed to send friend request: $e');
    }
  }

  @override
  Future<List<FriendRequestModel>> getPendingFriendRequests(String userId) async {
    try {
      print('🔍 DEBUG: Getting pending friend requests...');
      print('   User ID: $userId');
      
      final response = await supabaseClient
          .from('friend_requests')
          .select()
          .eq('receiver_id', userId)
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      print('✅ Got ${(response as List).length} pending requests');
      print('   Response: $response');

      return (response as List)
          .map((json) => FriendRequestModel.fromJson(json))
          .toList();
    } catch (e, stackTrace) {
      print('❌ ERROR getting pending requests: $e');
      print('   Error type: ${e.runtimeType}');
      print('   Stack trace: $stackTrace');
      throw Exception('Failed to get pending requests: $e');
    }
  }

  @override
  Future<FriendRequestModel> acceptFriendRequest(String requestId) async {
    try {
      // Update the request status
      final requestResponse = await supabaseClient
          .from('friend_requests')
          .update({'status': 'accepted', 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', requestId)
          .select()
          .single();

      final request = FriendRequestModel.fromJson(requestResponse);

      // Create friendship entries (bidirectional)
      await supabaseClient.from('friendships').insert({
        'user_id_1': request.senderId,
        'user_id_2': request.receiverId,
      });

      await supabaseClient.from('friendships').insert({
        'user_id_1': request.receiverId,
        'user_id_2': request.senderId,
      });

      return request;
    } catch (e) {
      throw Exception('Failed to accept friend request: $e');
    }
  }

  @override
  Future<void> rejectFriendRequest(String requestId) async {
    try {
      await supabaseClient
          .from('friend_requests')
          .update({'status': 'rejected', 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', requestId);
    } catch (e) {
      throw Exception('Failed to reject friend request: $e');
    }
  }

  @override
  Future<List<UserSearchModel>> getFriends(String userId) async {
    try {
      // Get all friend IDs
      final friendships = await supabaseClient
          .from('friendships')
          .select('user_id_2')
          .eq('user_id_1', userId);

      if (friendships.isEmpty) {
        return [];
      }

      final friendIds = (friendships as List)
          .map((f) => f['user_id_2'] as String)
          .toList();

      // Get friend profiles
      final profiles = await supabaseClient
          .from('profiles')
          .select()
          .inFilter('user_id', friendIds)
          .order('first_name');

      return (profiles as List)
          .map((json) => UserSearchModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get friends: $e');
    }
  }

  @override
  Future<bool> areFriends(String userId1, String userId2) async {
    try {
      final response = await supabaseClient
          .from('friendships')
          .select()
          .eq('user_id_1', userId1)
          .eq('user_id_2', userId2)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ChatMessageModel>> getMessages({
    required String userId1,
    required String userId2,
  }) async {
    try {
      final response = await supabaseClient
          .from('chat_messages')
          .select()
          .or('and(sender_id.eq.$userId1,receiver_id.eq.$userId2),and(sender_id.eq.$userId2,receiver_id.eq.$userId1)')
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => ChatMessageModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  @override
  Future<ChatMessageModel> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      final response = await supabaseClient
          .from('chat_messages')
          .insert({
            'sender_id': senderId,
            'receiver_id': receiverId,
            'message': message,
            'is_read': false,
          })
          .select()
          .single();

      return ChatMessageModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<void> markMessageAsRead(String messageId) async {
    try {
      await supabaseClient
          .from('chat_messages')
          .update({'is_read': true})
          .eq('id', messageId);
    } catch (e) {
      throw Exception('Failed to mark message as read: $e');
    }
  }

  @override
  Future<int> getUnreadMessageCount(String userId, String friendId) async {
    try {
      // Simply count the matching records
      final response = await supabaseClient
          .from('chat_messages')
          .select()
          .eq('sender_id', friendId)
          .eq('receiver_id', userId)
          .eq('is_read', false);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }
}
