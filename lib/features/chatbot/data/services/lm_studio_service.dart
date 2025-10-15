import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class LMStudioService {
  static const String baseUrl = 'http://localhost:1234/v1';
  final http.Client httpClient;

  LMStudioService({http.Client? httpClient}) 
      : httpClient = httpClient ?? http.Client();

  Future<LMStudioResponseModel> sendChatCompletion({
    required List<LMStudioMessage> messages,
    String model = 'local-model',
    double temperature = 0.7,
    int maxTokens = 1000,
  }) async {
    try {
      final request = LMStudioRequestModel(
        model: model,
        messages: messages,
        temperature: temperature,
        maxTokens: maxTokens,
      );

      final response = await httpClient.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        },
        body: jsonEncode(request.toJson()),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timed out. Make sure LM Studio server is running and responsive.');
        },
      );

      print('LM Studio Response Status: ${response.statusCode}');
      print('LM Studio Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return LMStudioResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 0) {
        throw Exception('Cannot connect to LM Studio. CORS issue detected. Please run Flutter with --web-browser-flag "--disable-web-security" or use desktop app.');
      } else {
        throw Exception('LM Studio error (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('LM Studio Service Error: $e');
      if (e.toString().contains('XMLHttpRequest')) {
        throw Exception('CORS error: Run Flutter with --web-browser-flag "--disable-web-security" or use desktop app.');
      }
      rethrow;
    }
  }

  Future<bool> checkConnection() async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/models'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        },
      ).timeout(const Duration(seconds: 10));

      print('Connection check status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Connection check failed: $e');
      return false;
    }
  }

  void dispose() {
    httpClient.close();
  }
}