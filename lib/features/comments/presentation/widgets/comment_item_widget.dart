import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../domain/entities/comment_entity.dart';
import '../../../profile/presentation/widgets/profile_avatar_generator.dart';

class CommentItemWidget extends StatelessWidget {
  final CommentEntity comment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CommentItemWidget({
    super.key,
    required this.comment,
    required this.onEdit,
    required this.onDelete,
  });

  bool _isCurrentUserComment() {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null && currentUser.uid == comment.userId;
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = _isCurrentUserComment();
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, Username, and Actions
            Row(
              children: [
                // Avatar
                ProfileAvatarGenerator.generateConsistentAvatar(
                  email: comment.userId,
                  size: 40,
                ),
                const SizedBox(width: 12),
                
                // Username and timestamp
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.userName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        timeago.format(comment.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons (only for comment owner)
                if (isCurrentUser) ...[
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onEdit,
                    tooltip: 'Edit comment',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.red[400],
                    ),
                    onPressed: () => _showDeleteConfirmation(context),
                    tooltip: 'Delete comment',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 12),

            // Comment text
            Text(
              comment.comment,
              style: theme.textTheme.bodyMedium,
            ),

            // "Edited" indicator
            if (comment.createdAt != comment.updatedAt) ...[
              const SizedBox(height: 8),
              Text(
                'Edited ${timeago.format(comment.updatedAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Comment'),
          content: const Text(
            'Are you sure you want to delete this comment? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
