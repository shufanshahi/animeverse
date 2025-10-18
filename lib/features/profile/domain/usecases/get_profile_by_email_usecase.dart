import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileByEmailUseCase implements UseCase<ProfileEntity, GetProfileByEmailParams> {
  final ProfileRepository repository;

  GetProfileByEmailUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(GetProfileByEmailParams params) async {
    return await repository.getProfileByEmail(params.email);
  }
}

class GetProfileByEmailParams {
  final String email;

  GetProfileByEmailParams({required this.email});
}