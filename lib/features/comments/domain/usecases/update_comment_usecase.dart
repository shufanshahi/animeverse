import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class UpdateCommentUseCase implements UseCase<CommentEntity, UpdateCommentParams> {
  final CommentRepository repository;

  UpdateCommentUseCase(this.repository);

  @override
  Future<Either<Failure, CommentEntity>> call(UpdateCommentParams params) async {
    return await repository.updateComment(params.comment);
  }
}

class UpdateCommentParams extends Equatable {
  final CommentEntity comment;

  const UpdateCommentParams({required this.comment});

  @override
  List<Object> get props => [comment];
}
