import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/comment_entity.dart';

abstract class CommentRepository {
  Future<Either<Failure, List<CommentEntity>>> getCommentsByAnimeId(int animeId);
  Future<Either<Failure, CommentEntity>> createComment(CommentEntity comment);
  Future<Either<Failure, CommentEntity>> updateComment(CommentEntity comment);
  Future<Either<Failure, void>> deleteComment(String commentId);
}
