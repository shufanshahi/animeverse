import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/anime_wishlist.dart';

abstract class AnimeWishlistRepository {
  Future<Either<Failure, void>> addToWishlist(AnimeWishlist anime);
  Future<Either<Failure, void>> removeFromWishlist(String userEmail, int animeId);
  Future<Either<Failure, List<AnimeWishlist>>> getUserWishlist(String userEmail);
  Future<Either<Failure, bool>> isInWishlist(String userEmail, int animeId);
  Stream<List<AnimeWishlist>> watchUserWishlist(String userEmail);
}
