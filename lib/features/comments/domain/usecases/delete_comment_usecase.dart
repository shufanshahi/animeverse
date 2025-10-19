import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/comment_repository.dart';

class DeleteCommentUseCase implements UseCase<void, DeleteCommentParams> {
  final CommentRepository repository;

  DeleteCommentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteCommentParams params) async {
    return await repository.deleteComment(params.commentId);
  }
}

class DeleteCommentParams extends Equatable {
  final String commentId;

  const DeleteCommentParams({required this.commentId});

  @override
  List<Object> get props => [commentId];
}
