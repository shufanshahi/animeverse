import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

// Features - AnimeDetails
import 'features/animeDetails/data/datasources/anime_detail_remote_data_source.dart';
import 'features/animeDetails/data/repositories/anime_detail_repository_impl.dart';
import 'features/animeDetails/domain/repositories/anime_detail_repository.dart';
import 'features/animeDetails/domain/usecases/get_anime_detail.dart';
// Features - Home
import 'features/home/data/datasources/datasources.dart';
import 'features/home/data/repositories/repositories.dart';
import 'features/home/domain/repositories/repositories.dart';
import 'features/home/domain/usecases/usecases.dart';
// Features - AnimeWishlist
import 'features/anime_wishlist/data/datasources/anime_wishlist_data_source.dart';
import 'features/anime_wishlist/data/repositories/anime_wishlist_repository_impl.dart';
import 'features/anime_wishlist/domain/repositories/anime_wishlist_repository.dart';
import 'features/anime_wishlist/domain/usecases/add_to_wishlist.dart';
import 'features/anime_wishlist/domain/usecases/get_user_wishlist.dart';
import 'features/anime_wishlist/domain/usecases/is_in_wishlist.dart';
import 'features/anime_wishlist/domain/usecases/remove_from_wishlist.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Home
  // Use cases
  sl.registerLazySingleton(() => GetTopAnime(sl()));
  sl.registerLazySingleton(() => GetAnimeByGenre(sl()));
  sl.registerLazySingleton(() => GetSeasonalAnime(sl()));
  sl.registerLazySingleton(() => GetAiringAnime(sl()));

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  //! Features - AnimeDetails
  // Use cases
  sl.registerLazySingleton(() => GetAnimeDetail(sl()));

  // Repository
  sl.registerLazySingleton<AnimeDetailRepository>(
    () => AnimeDetailRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AnimeDetailRemoteDataSource>(
    () => AnimeDetailRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  //! Features - AnimeWishlist
  // Use cases
  sl.registerLazySingleton(() => AddToWishlist(sl()));
  sl.registerLazySingleton(() => RemoveFromWishlist(sl()));
  sl.registerLazySingleton(() => GetUserWishlist(sl()));
  sl.registerLazySingleton(() => IsInWishlist(sl()));

  // Repository
  sl.registerLazySingleton<AnimeWishlistRepository>(
    () => AnimeWishlistRepositoryImpl(
      dataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AnimeWishlistDataSource>(
    () => AnimeWishlistDataSourceImpl(
      supabase: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => Supabase.instance.client);
}
