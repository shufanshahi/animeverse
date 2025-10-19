import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/social_chat_repository.dart';

class SendMessageUseCase implements UseCase<ChatMessageEntity, SendMessageParams> {
  final SocialChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, ChatMessageEntity>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      senderId: params.senderId,
      receiverId: params.receiverId,
      message: params.message,
    );
  }
}

class SendMessageParams extends Equatable {
  final String senderId;
  final String receiverId;
  final String message;

  const SendMessageParams({
    required this.senderId,
    required this.receiverId,
    required this.message,
  });

  @override
  List<Object> get props => [senderId, receiverId, message];
}
