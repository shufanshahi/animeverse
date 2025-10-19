import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/social_chat_repository.dart';

class AreFriendsUseCase implements UseCase<bool, AreFriendsParams> {
  final SocialChatRepository repository;

  AreFriendsUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(AreFriendsParams params) async {
    return await repository.areFriends(params.userId1, params.userId2);
  }
}

class AreFriendsParams extends Equatable {
  final String userId1;
  final String userId2;

  const AreFriendsParams({
    required this.userId1,
    required this.userId2,
  });

  @override
  List<Object> get props => [userId1, userId2];
}
