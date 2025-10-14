import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/anime_detail.dart';
import '../repositories/anime_detail_repository.dart';

class GetAnimeDetailParams extends Equatable {
  final int id;

  const GetAnimeDetailParams({required this.id});

  @override
  List<Object> get props => [id];
}

class GetAnimeDetail implements UseCase<AnimeDetail, GetAnimeDetailParams> {
  final AnimeDetailRepository repository;

  GetAnimeDetail(this.repository);

  @override
  Future<Either<Failure, AnimeDetail>> call(GetAnimeDetailParams params) async {
    return await repository.getAnimeDetail(params.id);
  }
}