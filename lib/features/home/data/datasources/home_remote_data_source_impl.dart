import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/models.dart';
import 'home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://api.jikan.moe/v4';

  // Genre name to ID mapping based on Jikan API
  static const Map<String, int> genreMap = {
    'Action': 1,
    'Adventure': 2,
    'Comedy': 4,
    'Drama': 8,
    'Fantasy': 10,
    'Romance': 22,
    'Sci-Fi': 24,
    'Thriller': 41,
    'Horror': 14,
    'Mystery': 7,
    'Slice of Life': 36,
    'Sports': 30,
    'Supernatural': 37,
    'Military': 38,
    'School': 23,
  };

  HomeRemoteDataSourceImpl({required this.client});

  @override
  Future<List<AnimeModel>> getTopAnime({int page = 1}) async {
    final response = await client.get(
      Uri.parse('$baseUrl/top/anime?page=$page'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> animeList = jsonData['data'];
      return animeList.map((anime) => AnimeModel.fromJson(anime)).toList();
    } else {
      throw ServerException(message: 'Failed to fetch top anime');
    }
  }

  @override
  Future<List<AnimeModel>> getAnimeByGenre({
    required String genre,
    int page = 1,
  }) async {
    // Get genre ID from the genre name
    final genreId = genreMap[genre];
    
    if (genreId == null) {
      throw ServerException(message: 'Invalid genre: $genre');
    }

    final response = await client.get(
      Uri.parse('$baseUrl/anime?genres=$genreId&page=$page&order_by=popularity&sort=asc'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> animeList = jsonData['data'];
      return animeList.map((anime) => AnimeModel.fromJson(anime)).toList();
    } else {
      throw ServerException(message: 'Failed to fetch anime by genre');
    }
  }

  @override
  Future<List<AnimeModel>> getSeasonalAnime({
    required String year,
    required String season,
    int page = 1,
  }) async {
    final response = await client.get(
      Uri.parse('$baseUrl/seasons/$year/$season?page=$page'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> animeList = jsonData['data'];
      return animeList.map((anime) => AnimeModel.fromJson(anime)).toList();
    } else {
      throw ServerException(message: 'Failed to fetch seasonal anime');
    }
  }

  @override
  Future<List<AnimeModel>> searchAnime({
    required String query,
    int page = 1,
  }) async {
    final response = await client.get(
      Uri.parse('$baseUrl/anime?q=${Uri.encodeComponent(query)}&page=$page'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> animeList = jsonData['data'];
      return animeList.map((anime) => AnimeModel.fromJson(anime)).toList();
    } else {
      throw ServerException(message: 'Failed to search anime');
    }
  }

  @override
  Future<List<AnimeModel>> getAiringAnime({int page = 1}) async {
    final response = await client.get(
      Uri.parse('$baseUrl/anime?status=airing&page=$page'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> animeList = jsonData['data'];
      return animeList.map((anime) => AnimeModel.fromJson(anime)).toList();
    } else {
      throw ServerException(message: 'Failed to fetch airing anime');
    }
  }
}