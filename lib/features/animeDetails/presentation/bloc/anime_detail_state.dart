part of 'anime_detail_bloc.dart';

abstract class AnimeDetailState extends Equatable {
  const AnimeDetailState();

  @override
  List<Object> get props => [];
}

class AnimeDetailInitial extends AnimeDetailState {}

class AnimeDetailLoading extends AnimeDetailState {}

class AnimeDetailLoaded extends AnimeDetailState {
  final AnimeDetail animeDetail;

  const AnimeDetailLoaded(this.animeDetail);

  @override
  List<Object> get props => [animeDetail];
}

class AnimeDetailError extends AnimeDetailState {
  final String message;

  const AnimeDetailError(this.message);

  @override
  List<Object> get props => [message];
}