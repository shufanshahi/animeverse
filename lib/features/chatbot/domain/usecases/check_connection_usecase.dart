import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/repositories.dart';

class CheckConnectionUseCase implements UseCase<bool, NoParams> {
  final ChatbotRepository repository;

  CheckConnectionUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.checkConnection();
  }
}