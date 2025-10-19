import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/social_chat_repository.dart';

class GetMessagesUseCase implements UseCase<List<ChatMessageEntity>, GetMessagesParams> {
  final SocialChatRepository repository;

  GetMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> call(GetMessagesParams params) async {
    return await repository.getMessages(
      userId1: params.userId1,
      userId2: params.userId2,
    );
  }
}

class GetMessagesParams extends Equatable {
  final String userId1;
  final String userId2;

  const GetMessagesParams({
    required this.userId1,
    required this.userId2,
  });

  @override
  List<Object> get props => [userId1, userId2];
}
