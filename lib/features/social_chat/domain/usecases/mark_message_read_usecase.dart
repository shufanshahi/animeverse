import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/social_chat_repository.dart';

class MarkMessageReadUseCase implements UseCase<void, MarkMessageReadParams> {
  final SocialChatRepository repository;

  MarkMessageReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkMessageReadParams params) async {
    return await repository.markMessageAsRead(params.messageId);
  }
}

class MarkMessageReadParams extends Equatable {
  final String messageId;

  const MarkMessageReadParams({required this.messageId});

  @override
  List<Object> get props => [messageId];
}
