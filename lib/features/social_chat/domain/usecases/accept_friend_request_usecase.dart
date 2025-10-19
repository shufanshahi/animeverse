import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/friend_request_entity.dart';
import '../repositories/social_chat_repository.dart';

class AcceptFriendRequestUseCase implements UseCase<FriendRequestEntity, AcceptFriendRequestParams> {
  final SocialChatRepository repository;

  AcceptFriendRequestUseCase(this.repository);

  @override
  Future<Either<Failure, FriendRequestEntity>> call(AcceptFriendRequestParams params) async {
    return await repository.acceptFriendRequest(params.requestId);
  }
}

class AcceptFriendRequestParams extends Equatable {
  final String requestId;

  const AcceptFriendRequestParams({required this.requestId});

  @override
  List<Object> get props => [requestId];
}
