import 'package:equatable/equatable.dart';
import '../../domain/entities/entities.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<AnimeEntity> topAnime;
  final List<AnimeEntity> airingAnime;
  final List<AnimeEntity> seasonalAnime;
  final Map<String, List<AnimeEntity>> genreAnime;
  final Map<String, bool> genreLoading;
  final Map<String, int> genrePages;

  const HomeLoaded({
    required this.topAnime,
    required this.airingAnime,
    required this.seasonalAnime,
    this.genreAnime = const {},
    this.genreLoading = const {},
    this.genrePages = const {},
  });

  HomeLoaded copyWith({
    List<AnimeEntity>? topAnime,
    List<AnimeEntity>? airingAnime,
    List<AnimeEntity>? seasonalAnime,
    Map<String, List<AnimeEntity>>? genreAnime,
    Map<String, bool>? genreLoading,
    Map<String, int>? genrePages,
  }) {
    return HomeLoaded(
      topAnime: topAnime ?? this.topAnime,
      airingAnime: airingAnime ?? this.airingAnime,
      seasonalAnime: seasonalAnime ?? this.seasonalAnime,
      genreAnime: genreAnime ?? this.genreAnime,
      genreLoading: genreLoading ?? this.genreLoading,
      genrePages: genrePages ?? this.genrePages,
    );
  }

  @override
  List<Object?> get props => [
        topAnime,
        airingAnime,
        seasonalAnime,
        genreAnime,
        genreLoading,
        genrePages,
      ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}

class GenreAnimeLoading extends HomeState {
  final String genre;

  const GenreAnimeLoading({required this.genre});

  @override
  List<Object?> get props => [genre];
}