import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/domain.dart';

class JikanSearchDatasource implements SearchDatasource {
  static const baseUrl = 'https://api.jikan.moe/v4/anime';

  @override
  Future<List<Anime>> searchAnime(String query) async {
    final url = Uri.parse('$baseUrl?q=$query&limit=20');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List data = json['data'];
      return data.map((e) => Anime.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load anime');
    }
  }
}