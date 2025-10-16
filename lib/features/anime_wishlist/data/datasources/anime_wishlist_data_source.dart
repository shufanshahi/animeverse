import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../models/anime_wishlist_model.dart';

abstract class AnimeWishlistDataSource {
  Future<void> addToWishlist(AnimeWishlistModel anime);
  Future<void> removeFromWishlist(String userEmail, int animeId);
  Future<List<AnimeWishlistModel>> getUserWishlist(String userEmail);
  Future<bool> isInWishlist(String userEmail, int animeId);
  Stream<List<AnimeWishlistModel>> watchUserWishlist(String userEmail);
}

class AnimeWishlistDataSourceImpl implements AnimeWishlistDataSource {
  final SupabaseClient supabase;
  static const String tableName = 'wishlists';

  AnimeWishlistDataSourceImpl({required this.supabase});

  @override
  Future<void> addToWishlist(AnimeWishlistModel anime) async {
    try {
      await supabase.from(tableName).upsert(
        anime.toJson(),
        onConflict: 'user_email,anime_id',
      );
    } catch (e) {
      throw ServerException(message: 'Failed to add anime to wishlist: $e');
    }
  }

  @override
  Future<void> removeFromWishlist(String userEmail, int animeId) async {
    try {
      await supabase
          .from(tableName)
          .delete()
          .eq('user_email', userEmail)
          .eq('anime_id', animeId);
    } catch (e) {
      throw ServerException(message: 'Failed to remove anime from wishlist: $e');
    }
  }

  @override
  Future<List<AnimeWishlistModel>> getUserWishlist(String userEmail) async {
    try {
      final response = await supabase
          .from(tableName)
          .select()
          .eq('user_email', userEmail)
          .order('added_at', ascending: false);

      final List<dynamic> data = response as List<dynamic>;
      return data
          .map((item) => AnimeWishlistModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to fetch wishlist: $e');
    }
  }

  @override
  Future<bool> isInWishlist(String userEmail, int animeId) async {
    try {
      final response = await supabase
          .from(tableName)
          .select('id')
          .eq('user_email', userEmail)
          .eq('anime_id', animeId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw ServerException(message: 'Failed to check wishlist status: $e');
    }
  }

  @override
  Stream<List<AnimeWishlistModel>> watchUserWishlist(String userEmail) {
    try {
      return supabase
          .from(tableName)
          .stream(primaryKey: ['id'])
          .eq('user_email', userEmail)
          .order('added_at', ascending: false)
          .map((data) => data
              .map((item) => AnimeWishlistModel.fromJson(item))
              .toList());
    } catch (e) {
      throw ServerException(message: 'Failed to watch wishlist: $e');
    }
  }
}
