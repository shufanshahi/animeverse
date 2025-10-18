import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/comment_entity.dart';

class CommentInputWidget extends ConsumerStatefulWidget {
  final int animeId;
  final CommentEntity? editingComment;
  final Function(CommentEntity) onSubmit;
  final VoidCallback? onCancel;

  const CommentInputWidget({
    super.key,
    required this.animeId,
    this.editingComment,
    required this.onSubmit,
    this.onCancel,
  });

  @override
  ConsumerState<CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends ConsumerState<CommentInputWidget> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.editingComment != null) {
      _commentController.text = widget.editingComment!.comment;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a comment')),
      );
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to comment')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Fetch user profile to get username
      final supabase = Supabase.instance.client;
      final profileData = await supabase
          .from('profiles')
          .select()
          .eq('email', currentUser.email!)
          .maybeSingle();

      if (profileData == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please create your profile first before commenting'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      final userName = '${profileData['first_name']} ${profileData['last_name']}';

      // Create or update comment entity (without image)
      final comment = CommentEntity(
        id: widget.editingComment?.id ?? '',
        animeId: widget.animeId,
        userId: currentUser.uid,
        userName: userName,
        comment: _commentController.text.trim(),
        imageUrl: null, // No image support
        createdAt: widget.editingComment?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onSubmit(comment);

      // Clear form
      _commentController.clear();
      setState(() {
        _isSubmitting = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit comment: $e')),
        );
      }
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  widget.editingComment != null ? Icons.edit : Icons.add_comment,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.editingComment != null ? 'Edit Comment' : 'Add Comment',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.onCancel != null)
                  TextButton(
                    onPressed: _isSubmitting ? null : widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitComment,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(widget.editingComment != null ? 'Update' : 'Post'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
