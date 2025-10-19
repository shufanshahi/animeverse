import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/social_chat_repository.dart';

class RejectFriendRequestUseCase implements UseCase<void, RejectFriendRequestParams> {
  final SocialChatRepository repository;

  RejectFriendRequestUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RejectFriendRequestParams params) async {
    return await repository.rejectFriendRequest(params.requestId);
  }
}

class RejectFriendRequestParams extends Equatable {
  final String requestId;

  const RejectFriendRequestParams({required this.requestId});

  @override
  List<Object> get props => [requestId];
}
