import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeEvent {
  const LoadHomeData();
}

class LoadAnimeByGenre extends HomeEvent {
  final String genre;
  final int page;

  const LoadAnimeByGenre({
    required this.genre,
    this.page = 1,
  });

  @override
  List<Object?> get props => [genre, page];
}

class LoadMoreAnimeByGenre extends HomeEvent {
  final String genre;
  final int page;

  const LoadMoreAnimeByGenre({
    required this.genre,
    required this.page,
  });

  @override
  List<Object?> get props => [genre, page];
}

class RefreshHomeData extends HomeEvent {
  const RefreshHomeData();
}