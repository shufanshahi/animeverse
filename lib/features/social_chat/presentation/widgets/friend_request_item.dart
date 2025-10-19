import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/friend_request_entity.dart';
import '../providers/friend_request_provider.dart';
import '../providers/social_chat_providers.dart';
import '../../domain/usecases/search_users_usecase.dart';

class FriendRequestItem extends ConsumerStatefulWidget {
  final FriendRequestEntity request;
  final String currentUserId;

  const FriendRequestItem({
    super.key,
    required this.request,
    required this.currentUserId,
  });

  @override
  ConsumerState<FriendRequestItem> createState() => _FriendRequestItemState();
}

class _FriendRequestItemState extends ConsumerState<FriendRequestItem> {
  String _senderName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSenderInfo();
  }

  Future<void> _loadSenderInfo() async {
    final searchUseCase = ref.read(searchUsersUseCaseProvider);
    
    // Search by sender's email to get their full name
    final result = await searchUseCase(
      SearchUsersParams(query: widget.request.senderEmail.split('@')[0]),
    );

    result.fold(
      (failure) => setState(() {
        _senderName = widget.request.senderEmail;
        _isLoading = false;
      }),
      (users) {
        final sender = users.firstWhere(
          (u) => u.userId == widget.request.senderId,
          orElse: () => users.first,
        );
        setState(() {
          _senderName = sender.fullName;
          _isLoading = false;
        });
      },
    );
  }

  void _acceptRequest() {
    ref.read(friendRequestProvider.notifier).acceptFriendRequest(
          widget.request.id,
          widget.currentUserId,
        );
  }

  void _rejectRequest() {
    ref.read(friendRequestProvider.notifier).rejectFriendRequest(
          widget.request.id,
          widget.currentUserId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          _isLoading ? 'Loading...' : _senderName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(widget.request.senderEmail),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: _acceptRequest,
              icon: const Icon(Icons.check_circle, color: Colors.green),
              tooltip: 'Accept',
            ),
            IconButton(
              onPressed: _rejectRequest,
              icon: const Icon(Icons.cancel, color: Colors.red),
              tooltip: 'Reject',
            ),
          ],
        ),
      ),
    );
  }
}
