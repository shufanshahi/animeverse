import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/anime_wishlist_repository.dart';

class IsInWishlistParams extends Equatable {
  final String userEmail;
  final int animeId;

  const IsInWishlistParams({
    required this.userEmail,
    required this.animeId,
  });

  @override
  List<Object> get props => [userEmail, animeId];
}

class IsInWishlist implements UseCase<bool, IsInWishlistParams> {
  final AnimeWishlistRepository repository;

  IsInWishlist(this.repository);

  @override
  Future<Either<Failure, bool>> call(IsInWishlistParams params) async {
    return await repository.isInWishlist(params.userEmail, params.animeId);
  }
}
