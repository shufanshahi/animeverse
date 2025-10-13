import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/anime_detail.dart';
import '../../domain/usecases/get_anime_detail.dart';

part 'anime_detail_event.dart';
part 'anime_detail_state.dart';

class AnimeDetailBloc extends Bloc<AnimeDetailEvent, AnimeDetailState> {
  final GetAnimeDetail getAnimeDetail;

  AnimeDetailBloc({
    required this.getAnimeDetail,
  }) : super(AnimeDetailInitial()) {
    on<GetAnimeDetailEvent>(_onGetAnimeDetail);
  }

  Future<void> _onGetAnimeDetail(
    GetAnimeDetailEvent event,
    Emitter<AnimeDetailState> emit,
  ) async {
    emit(AnimeDetailLoading());

    final result = await getAnimeDetail(
      GetAnimeDetailParams(animeId: event.animeId),
    );

    result.fold(
      (failure) => emit(AnimeDetailError(failure.toString())),
      (animeDetail) => emit(AnimeDetailLoaded(animeDetail)),
    );
  }
}