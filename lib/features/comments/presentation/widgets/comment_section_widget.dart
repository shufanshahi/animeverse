import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/comment_entity.dart';
import '../providers/comment_provider.dart';
import 'comment_input_widget.dart';
import 'comment_list_widget.dart';
import '../../../../injection_container.dart';

class CommentSectionWidget extends ConsumerStatefulWidget {
  final int animeId;

  const CommentSectionWidget({
    super.key,
    required this.animeId,
  });

  @override
  ConsumerState<CommentSectionWidget> createState() => _CommentSectionWidgetState();
}

class _CommentSectionWidgetState extends ConsumerState<CommentSectionWidget> {
  late final StateNotifierProvider<CommentNotifier, CommentState> commentProvider;
  CommentEntity? _editingComment;

  @override
  void initState() {
    super.initState();
    commentProvider = StateNotifierProvider<CommentNotifier, CommentState>((ref) {
      return CommentNotifier(
        getCommentsUseCase: sl(),
        createCommentUseCase: sl(),
        updateCommentUseCase: sl(),
        deleteCommentUseCase: sl(),
      );
    });

    // Load comments when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(commentProvider.notifier).getComments(widget.animeId);
    });
  }

  Future<void> _handleSubmitComment(CommentEntity comment) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to comment')),
      );
      return;
    }

    bool success;
    if (_editingComment != null) {
      // Update existing comment
      success = await ref.read(commentProvider.notifier).updateComment(comment);
      if (success) {
        setState(() {
          _editingComment = null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Comment updated successfully')),
          );
        }
      }
    } else {
      // Create new comment
      success = await ref.read(commentProvider.notifier).createComment(comment);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment posted successfully')),
        );
      }
    }

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(commentProvider).error ?? 'Failed to post comment',
          ),
        ),
      );
    }
  }

  void _handleEditComment(CommentEntity comment) {
    setState(() {
      _editingComment = comment;
    });
    // Scroll to top to show input widget
    Future.delayed(const Duration(milliseconds: 100), () {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _handleDeleteComment(String commentId) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ref.read(commentProvider.notifier).deleteComment(commentId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Comment deleted successfully' : 'Failed to delete comment',
            ),
          ),
        );
      }
    }
  }

  void _handleCancelEdit() {
    setState(() {
      _editingComment = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(
                Icons.comment,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Comments',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${commentState.comments.length}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const Spacer(),
              if (commentState.isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        CommentInputWidget(
          animeId: widget.animeId,
          editingComment: _editingComment,
          onSubmit: _handleSubmitComment,
          onCancel: _editingComment != null ? _handleCancelEdit : null,
        ),
        if (commentState.error != null && commentState.comments.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    commentState.error!,
                    style: TextStyle(color: Colors.red[700]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(commentProvider.notifier).getComments(widget.animeId);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          )
        else
          CommentListWidget(
            comments: commentState.comments,
            onEdit: _handleEditComment,
            onDelete: _handleDeleteComment,
          ),
      ],
    );
  }
}
