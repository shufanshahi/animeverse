import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class JikanApiService {
  static const String baseUrl = 'https://api.jikan.moe/v4';
  final http.Client httpClient;
  
  // Rate limiting - Jikan allows 1 request per second, 60 per minute
  static DateTime? _lastRequestTime;
  static const Duration _minRequestInterval = Duration(seconds: 2); // Be conservative
  
  // Simple in-memory cache
  static final Map<String, List<AnimeSuggestionModel>> _searchCache = {};
  static final Map<String, List<AnimeSuggestionModel>> _topAnimeCache = {};
  static const Duration _cacheExpiry = Duration(minutes: 30);
  static final Map<String, DateTime> _cacheTimestamps = {};
  
  JikanApiService({http.Client? httpClient}) 
      : httpClient = httpClient ?? http.Client();

  /// Ensure we don't exceed rate limits
  Future<void> _respectRateLimit() async {
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest < _minRequestInterval) {
        final waitTime = _minRequestInterval - timeSinceLastRequest;
        print('Rate limiting: waiting ${waitTime.inMilliseconds}ms');
        await Future.delayed(waitTime);
      }
    }
    _lastRequestTime = DateTime.now();
  }

  /// Check if cache entry is still valid
  bool _isCacheValid(String key) {
    final timestamp = _cacheTimestamps[key];
    if (timestamp == null) return false;
    return DateTime.now().difference(timestamp) < _cacheExpiry;
  }

  /// Get from cache if available and valid
  List<AnimeSuggestionModel>? _getFromCache(String key, Map<String, List<AnimeSuggestionModel>> cache) {
    if (_isCacheValid(key) && cache.containsKey(key)) {
      print('Cache hit for: $key');
      return cache[key];
    }
    return null;
  }

  /// Store in cache
  void _storeInCache(String key, List<AnimeSuggestionModel> data, Map<String, List<AnimeSuggestionModel>> cache) {
    cache[key] = data;
    _cacheTimestamps[key] = DateTime.now();
    print('Cached result for: $key');
  }

  /// Search for anime by query
  Future<List<AnimeSuggestionModel>> searchAnime({
    required String query,
    int limit = 10,
  }) async {
    try {
      final cacheKey = '${query.trim().toLowerCase()}_$limit';
      
      // Check cache first
      final cachedResult = _getFromCache(cacheKey, _searchCache);
      if (cachedResult != null) {
        return cachedResult;
      }
      
      // Respect rate limits
      await _respectRateLimit();
      
      final encodedQuery = Uri.encodeComponent(query.trim());
      final response = await httpClient.get(
        Uri.parse('$baseUrl/anime?q=$encodedQuery&limit=$limit&order_by=score&sort=desc'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      print('Jikan API Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final searchResponse = JikanSearchResponse.fromJson(jsonResponse);
        
        // Cache the result
        _storeInCache(cacheKey, searchResponse.data, _searchCache);
        
        return searchResponse.data;
      } else if (response.statusCode == 429) {
        print('Jikan API Rate Limited: ${response.body}');
        // Wait longer for rate limit and return empty list instead of throwing
        await Future.delayed(const Duration(seconds: 5));
        return [];
      } else {
        print('Jikan API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to search anime: ${response.statusCode}');
      }
    } catch (e) {
      print('Jikan API Service Error: $e');
      throw Exception('Failed to search anime: $e');
    }
  }

  /// Get top anime by genre or general
  Future<List<AnimeSuggestionModel>> getTopAnime({
    String? genre,
    int limit = 10,
  }) async {
    try {
      final cacheKey = 'top_${genre ?? 'all'}_$limit';
      
      // Check cache first
      final cachedResult = _getFromCache(cacheKey, _topAnimeCache);
      if (cachedResult != null) {
        return cachedResult;
      }
      
      // Respect rate limits
      await _respectRateLimit();
      
      String url = '$baseUrl/top/anime?limit=$limit';
      if (genre != null) {
        // You can extend this to map genre names to Jikan genre IDs
        url += '&filter=bypopularity';
      }

      final response = await httpClient.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      print('Jikan API Top Anime Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final searchResponse = JikanSearchResponse.fromJson(jsonResponse);
        
        // Cache the result
        _storeInCache(cacheKey, searchResponse.data, _topAnimeCache);
        
        return searchResponse.data;
      } else if (response.statusCode == 429) {
        print('Jikan API Rate Limited: ${response.body}');
        await Future.delayed(const Duration(seconds: 5));
        return [];
      } else {
        print('Jikan API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get top anime: ${response.statusCode}');
      }
    } catch (e) {
      print('Jikan API Service Error: $e');
      throw Exception('Failed to get top anime: $e');
    }
  }

  /// Get anime recommendations based on a specific anime ID
  Future<List<AnimeSuggestionModel>> getRecommendations({
    required int animeId,
    int limit = 5,
  }) async {
    try {
      // Respect rate limits
      await _respectRateLimit();
      
      final response = await httpClient.get(
        Uri.parse('$baseUrl/anime/$animeId/recommendations'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      print('Jikan API Recommendations Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final dataList = jsonResponse['data'] as List<dynamic>? ?? [];
        final recommendations = dataList
            .take(limit)
            .where((item) => item['entry'] != null)
            .map((item) => AnimeSuggestionModel.fromJson(item['entry'] as Map<String, dynamic>))
            .toList();
        return recommendations;
      } else if (response.statusCode == 429) {
        print('Jikan API Rate Limited: ${response.body}');
        await Future.delayed(const Duration(seconds: 5));
        return [];
      } else {
        print('Jikan API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get recommendations: ${response.statusCode}');
      }
    } catch (e) {
      print('Jikan API Service Error: $e');
      throw Exception('Failed to get recommendations: $e');
    }
  }

  void dispose() {
    httpClient.close();
  }
}