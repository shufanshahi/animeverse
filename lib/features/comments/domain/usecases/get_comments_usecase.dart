import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/comment_entity.dart';
import '../repositories/comment_repository.dart';

class GetCommentsUseCase implements UseCase<List<CommentEntity>, GetCommentsParams> {
  final CommentRepository repository;

  GetCommentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<CommentEntity>>> call(GetCommentsParams params) async {
    return await repository.getCommentsByAnimeId(params.animeId);
  }
}

class GetCommentsParams extends Equatable {
  final int animeId;

  const GetCommentsParams({required this.animeId});

  @override
  List<Object> get props => [animeId];
}
