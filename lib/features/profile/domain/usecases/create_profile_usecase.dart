import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class CreateProfileUseCase implements UseCase<ProfileEntity, CreateProfileParams> {
  final ProfileRepository repository;

  CreateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(CreateProfileParams params) async {
    return await repository.createProfile(params.profile);
  }
}

class CreateProfileParams extends Equatable {
  final ProfileEntity profile;

  const CreateProfileParams({required this.profile});

  @override
  List<Object> get props => [profile];
}