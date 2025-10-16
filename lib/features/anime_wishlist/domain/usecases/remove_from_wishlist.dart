import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/anime_wishlist_repository.dart';

class RemoveFromWishlistParams extends Equatable {
  final String userEmail;
  final int animeId;

  const RemoveFromWishlistParams({
    required this.userEmail,
    required this.animeId,
  });

  @override
  List<Object> get props => [userEmail, animeId];
}

class RemoveFromWishlist implements UseCase<void, RemoveFromWishlistParams> {
  final AnimeWishlistRepository repository;

  RemoveFromWishlist(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFromWishlistParams params) async {
    return await repository.removeFromWishlist(params.userEmail, params.animeId);
  }
}
