import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_search_entity.dart';
import '../repositories/social_chat_repository.dart';

class GetFriendsUseCase implements UseCase<List<UserSearchEntity>, GetFriendsParams> {
  final SocialChatRepository repository;

  GetFriendsUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserSearchEntity>>> call(GetFriendsParams params) async {
    return await repository.getFriends(params.userId);
  }
}

class GetFriendsParams extends Equatable {
  final String userId;

  const GetFriendsParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
