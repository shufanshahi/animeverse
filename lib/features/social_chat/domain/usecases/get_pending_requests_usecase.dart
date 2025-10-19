import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/friend_request_entity.dart';
import '../repositories/social_chat_repository.dart';

class GetPendingRequestsUseCase implements UseCase<List<FriendRequestEntity>, GetPendingRequestsParams> {
  final SocialChatRepository repository;

  GetPendingRequestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<FriendRequestEntity>>> call(GetPendingRequestsParams params) async {
    return await repository.getPendingFriendRequests(params.userId);
  }
}

class GetPendingRequestsParams extends Equatable {
  final String userId;

  const GetPendingRequestsParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
