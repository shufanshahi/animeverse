import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase implements UseCase<ProfileEntity, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(params.profile);
  }
}

class UpdateProfileParams extends Equatable {
  final ProfileEntity profile;

  const UpdateProfileParams({required this.profile});

  @override
  List<Object> get props => [profile];
}