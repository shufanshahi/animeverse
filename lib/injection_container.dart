import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// Features
import 'features/animeDetails/data/datasources/anime_detail_remote_data_source.dart';
import 'features/animeDetails/data/repositories/anime_detail_repository_impl.dart';
import 'features/animeDetails/domain/repositories/anime_detail_repository.dart';
import 'features/animeDetails/domain/usecases/get_anime_detail.dart';
import 'features/animeDetails/presentation/bloc/anime_detail_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - AnimeDetails
  // Bloc
  sl.registerFactory(
    () => AnimeDetailBloc(
      getAnimeDetail: sl(),
    ),
  );

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

  //! Core
  sl.registerLazySingleton(() => http.Client());
}
