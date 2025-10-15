import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/entities.dart';

abstract class ChatbotRepository {
  Future<Either<Failure, String>> sendMessage({
    required String message,
    required List<MessageEntity> conversationHistory,
  });
  
  Future<Either<Failure, bool>> checkConnection();
}
