import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class CreateCommentUseCase implements UseCase<CommentEntity, CreateCommentParams> {
  final CommentRepository repository;

  CreateCommentUseCase(this.repository);

  @override
  Future<Either<Failure, CommentEntity>> call(CreateCommentParams params) async {
    return await repository.createComment(params.comment);
  }
}

class CreateCommentParams extends Equatable {
  final CommentEntity comment;

  const CreateCommentParams({required this.comment});

  @override
  List<Object> get props => [comment];
}
