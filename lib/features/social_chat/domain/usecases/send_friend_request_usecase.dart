import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/friend_request_entity.dart';
import '../repositories/social_chat_repository.dart';

class SendFriendRequestUseCase implements UseCase<FriendRequestEntity, SendFriendRequestParams> {
  final SocialChatRepository repository;

  SendFriendRequestUseCase(this.repository);

  @override
  Future<Either<Failure, FriendRequestEntity>> call(SendFriendRequestParams params) async {
    return await repository.sendFriendRequest(
      senderId: params.senderId,
      senderEmail: params.senderEmail,
      receiverId: params.receiverId,
      receiverEmail: params.receiverEmail,
    );
  }
}

class SendFriendRequestParams extends Equatable {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String receiverEmail;

  const SendFriendRequestParams({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.receiverEmail,
  });

  @override
  List<Object> get props => [senderId, senderEmail, receiverId, receiverEmail];
}
