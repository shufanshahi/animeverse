part of 'anime_detail_bloc.dart';

abstract class AnimeDetailEvent extends Equatable {
  const AnimeDetailEvent();

  @override
  List<Object> get props => [];
}

class GetAnimeDetailEvent extends AnimeDetailEvent {
  final int animeId;

  const GetAnimeDetailEvent(this.animeId);

  @override
  List<Object> get props => [animeId];
}