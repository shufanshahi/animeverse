import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../models/anime_detail_model.dart';

abstract class AnimeDetailRemoteDataSource {
  Future<AnimeDetailModel> getAnimeDetail(int animeId);
}

class AnimeDetailRemoteDataSourceImpl implements AnimeDetailRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://api.jikan.moe/v4';

  AnimeDetailRemoteDataSourceImpl({required this.client});

  @override
  Future<AnimeDetailModel> getAnimeDetail(int animeId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/anime/$animeId/full'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return AnimeDetailModel.fromJson(jsonResponse['data']);
    } else {
      throw ServerException(
        message: 'Failed to load anime details: ${response.statusCode}',
      );
    }
  }
}