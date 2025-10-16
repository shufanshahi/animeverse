import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class SendMessageUseCase implements UseCase<String, SendMessageParams> {
  final ChatbotRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      message: params.message,
      conversationHistory: params.conversationHistory,
    );
  }
}

class SendMessageParams {
  final String message;
  final List<MessageEntity> conversationHistory;

  SendMessageParams({
    required this.message,
    required this.conversationHistory,
  });
}