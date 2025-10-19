import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_search_entity.dart';
import '../screens/chat_screen.dart';

class FriendListItem extends ConsumerWidget {
  final UserSearchEntity friend;
  final String currentUserId;

  const FriendListItem({
    super.key,
    required this.friend,
    required this.currentUserId,
  });

  void _openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(friend: friend),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            friend.firstName.isNotEmpty
                ? friend.firstName[0].toUpperCase()
                : '?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          friend.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(friend.email),
        trailing: IconButton(
          onPressed: () => _openChat(context),
          icon: Icon(
            Icons.chat_bubble,
            color: Theme.of(context).colorScheme.primary,
          ),
          tooltip: 'Start chat',
        ),
      ),
    );
  }
}
