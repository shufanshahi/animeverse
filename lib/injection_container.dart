import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

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
// Features - Chatbot
import 'features/chatbot/data/datasources/datasources.dart';
import 'features/chatbot/data/repositories/repositories.dart';
import 'features/chatbot/data/services/services.dart';
import 'features/chatbot/domain/repositories/repositories.dart' as chatbot_repo;
import 'features/chatbot/domain/usecases/usecases.dart';

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

  //! Features - Chatbot
  // Use cases
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => CheckConnectionUseCase(sl()));
  sl.registerLazySingleton(() => SearchAnimeUseCase(sl()));
  sl.registerLazySingleton(() => GetTopAnimeUseCase(sl()));
  sl.registerLazySingleton(() => GetRecommendationsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<chatbot_repo.ChatbotRepository>(
    () => ChatbotRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ChatbotRemoteDataSourceImpl>(
    () => ChatbotRemoteDataSourceImpl(
      lmStudioService: sl(),
      jikanApiService: sl(),
    ),
  );

  // Services
  sl.registerLazySingleton(() => LMStudioService());
  sl.registerLazySingleton(() => JikanApiService());

  //! Core
  sl.registerLazySingleton(() => http.Client());
}
