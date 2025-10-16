import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/anime_wishlist.dart';
import '../../domain/repositories/anime_wishlist_repository.dart';
import '../datasources/anime_wishlist_data_source.dart';
import '../models/anime_wishlist_model.dart';

class AnimeWishlistRepositoryImpl implements AnimeWishlistRepository {
  final AnimeWishlistDataSource dataSource;

  AnimeWishlistRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, void>> addToWishlist(AnimeWishlist anime) async {
    try {
      final model = AnimeWishlistModel.fromEntity(anime);
      await dataSource.addToWishlist(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(String userEmail, int animeId) async {
    try {
      await dataSource.removeFromWishlist(userEmail, animeId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AnimeWishlist>>> getUserWishlist(String userEmail) async {
    try {
      final wishlist = await dataSource.getUserWishlist(userEmail);
      return Right(wishlist);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isInWishlist(String userEmail, int animeId) async {
    try {
      final result = await dataSource.isInWishlist(userEmail, animeId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Stream<List<AnimeWishlist>> watchUserWishlist(String userEmail) {
    return dataSource.watchUserWishlist(userEmail);
  }
}
