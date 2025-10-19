import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/social_chat_repository.dart';

class GetUnreadCountUseCase implements UseCase<int, GetUnreadCountParams> {
  final SocialChatRepository repository;

  GetUnreadCountUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(GetUnreadCountParams params) async {
    return await repository.getUnreadMessageCount(params.userId, params.friendId);
  }
}

class GetUnreadCountParams extends Equatable {
  final String userId;
  final String friendId;

  const GetUnreadCountParams({
    required this.userId,
    required this.friendId,
  });

  @override
  List<Object> get props => [userId, friendId];
}
