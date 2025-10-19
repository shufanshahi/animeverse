import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/usecases/get_comments_usecase.dart';
import '../../domain/usecases/create_comment_usecase.dart';
import '../../domain/usecases/update_comment_usecase.dart';
import '../../domain/usecases/delete_comment_usecase.dart';

class CommentState {
  final List<CommentEntity> comments;
  final bool isLoading;
  final String? error;

  const CommentState({
    this.comments = const [],
    this.isLoading = false,
    this.error,
  });

  CommentState copyWith({
    List<CommentEntity>? comments,
    bool? isLoading,
    String? error,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CommentNotifier extends StateNotifier<CommentState> {
  final GetCommentsUseCase getCommentsUseCase;
  final CreateCommentUseCase createCommentUseCase;
  final UpdateCommentUseCase updateCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;

  CommentNotifier({
    required this.getCommentsUseCase,
    required this.createCommentUseCase,
    required this.updateCommentUseCase,
    required this.deleteCommentUseCase,
  }) : super(const CommentState());

  Future<void> getComments(int animeId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await getCommentsUseCase(GetCommentsParams(animeId: animeId));

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: 'Failed to load comments',
      ),
      (comments) => state = state.copyWith(
        isLoading: false,
        comments: comments,
        error: null,
      ),
    );
  }

  Future<bool> createComment(CommentEntity comment) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await createCommentUseCase(CreateCommentParams(comment: comment));

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to create comment',
        );
        return false;
      },
      (createdComment) {
        final updatedComments = [createdComment, ...state.comments];
        state = state.copyWith(
          isLoading: false,
          comments: updatedComments,
          error: null,
        );
        return true;
      },
    );
  }

  Future<bool> updateComment(CommentEntity comment) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await updateCommentUseCase(UpdateCommentParams(comment: comment));

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to update comment',
        );
        return false;
      },
      (updatedComment) {
        final updatedComments = state.comments
            .map((c) => c.id == updatedComment.id ? updatedComment : c)
            .toList();
        state = state.copyWith(
          isLoading: false,
          comments: updatedComments,
          error: null,
        );
        return true;
      },
    );
  }

  Future<bool> deleteComment(String commentId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await deleteCommentUseCase(DeleteCommentParams(commentId: commentId));

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to delete comment',
        );
        return false;
      },
      (_) {
        final updatedComments = state.comments.where((c) => c.id != commentId).toList();
        state = state.copyWith(
          isLoading: false,
          comments: updatedComments,
          error: null,
        );
        return true;
      },
    );
  }
}
