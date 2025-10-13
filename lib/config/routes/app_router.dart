import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screens/home_screen.dart';
import '../../features/animeDetails/presentation/bloc/anime_detail_bloc.dart';
import '../../features/animeDetails/presentation/screens/anime_detail_screen.dart';
import '../../injection_container.dart' as di;

class AppRouter {
  static const String home = '/';
  static const String animeDetail = '/anime/:id';

  static final GoRouter _router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: animeDetail,
        name: 'animeDetail',
        builder: (context, state) {
          final animeId = int.parse(state.pathParameters['id']!);
          return BlocProvider(
            create: (context) => di.sl<AnimeDetailBloc>()
              ..add(GetAnimeDetailEvent(animeId)),
            child: AnimeDetailScreen(animeId: animeId),
          );
        },
      ),
    ],
  );

  static GoRouter get router => _router;
}
