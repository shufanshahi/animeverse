import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_search_entity.dart';
import '../providers/friend_request_provider.dart';
import '../providers/social_chat_providers.dart';
import '../../domain/usecases/are_friends_usecase.dart';

class UserSearchItem extends ConsumerStatefulWidget {
  final UserSearchEntity user;
  final String currentUserId;
  final String currentUserEmail;

  const UserSearchItem({
    super.key,
    required this.user,
    required this.currentUserId,
    required this.currentUserEmail,
  });

  @override
  ConsumerState<UserSearchItem> createState() => _UserSearchItemState();
}

class _UserSearchItemState extends ConsumerState<UserSearchItem> {
  bool _isCheckingFriendship = true;
  bool _areFriends = false;

  @override
  void initState() {
    super.initState();
    _checkFriendship();
  }

  Future<void> _checkFriendship() async {
    final result = await ref.read(areFriendsUseCaseProvider).call(
          AreFriendsParams(
            userId1: widget.currentUserId,
            userId2: widget.user.userId,
          ),
        );

    result.fold(
      (failure) => setState(() => _isCheckingFriendship = false),
      (areFriends) => setState(() {
        _areFriends = areFriends;
        _isCheckingFriendship = false;
      }),
    );
  }

  void _sendFriendRequest() {
    // Use Supabase profile user_ids instead of Firebase Auth UIDs
    ref.read(friendRequestProvider.notifier).sendFriendRequest(
          senderId: widget.currentUserId,
          senderEmail: widget.currentUserEmail,
          receiverId: widget.user.userId,
          receiverEmail: widget.user.email,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Friend request sent!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            widget.user.firstName.isNotEmpty
                ? widget.user.firstName[0].toUpperCase()
                : '?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          widget.user.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(widget.user.email),
        trailing: _isCheckingFriendship
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : _areFriends
                ? const Chip(
                    label: Text('Friends'),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                  )
                : ElevatedButton.icon(
                    onPressed: _sendFriendRequest,
                    icon: const Icon(Icons.person_add, size: 18),
                    label: const Text('Add Friend'),
                  ),
      ),
    );
  }
}
