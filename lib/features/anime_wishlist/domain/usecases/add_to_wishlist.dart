import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/anime_wishlist.dart';
import '../repositories/anime_wishlist_repository.dart';

class AddToWishlistParams extends Equatable {
  final AnimeWishlist anime;

  const AddToWishlistParams({required this.anime});

  @override
  List<Object> get props => [anime];
}

class AddToWishlist implements UseCase<void, AddToWishlistParams> {
  final AnimeWishlistRepository repository;

  AddToWishlist(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToWishlistParams params) async {
    return await repository.addToWishlist(params.anime);
  }
}
