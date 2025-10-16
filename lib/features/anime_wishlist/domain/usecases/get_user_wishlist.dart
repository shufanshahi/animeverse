import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/anime_wishlist.dart';
import '../repositories/anime_wishlist_repository.dart';

class GetUserWishlistParams extends Equatable {
  final String userEmail;

  const GetUserWishlistParams({required this.userEmail});

  @override
  List<Object> get props => [userEmail];
}

class GetUserWishlist implements UseCase<List<AnimeWishlist>, GetUserWishlistParams> {
  final AnimeWishlistRepository repository;

  GetUserWishlist(this.repository);

  @override
  Future<Either<Failure, List<AnimeWishlist>>> call(GetUserWishlistParams params) async {
    return await repository.getUserWishlist(params.userEmail);
  }
}
