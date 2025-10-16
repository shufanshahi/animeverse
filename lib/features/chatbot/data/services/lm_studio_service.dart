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

      print('Sending request to LM Studio...');
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
        const Duration(minutes: 3), // 3 minutes timeout for AI responses
        onTimeout: () {
          print('Request timed out after 3 minutes');
          throw Exception('Request timed out after 3 minutes. This can happen with complex queries or slow models. Try a shorter message or check if your model is responsive.');
        },
      );

      print('LM Studio Response Status: ${response.statusCode}');
      print('LM Studio Response Body (first 200 chars): ${response.body.length > 200 ? response.body.substring(0, 200) + '...' : response.body}');

      if (response.statusCode == 200) {
        try {
          final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
          final result = LMStudioResponseModel.fromJson(jsonResponse);
          print('Successfully parsed LM Studio response');
          return result;
        } catch (parseError) {
          print('Failed to parse LM Studio response: $parseError');
          throw Exception('Failed to parse response from LM Studio: $parseError');
        }
      } else if (response.statusCode == 0) {
        throw Exception('Cannot connect to LM Studio. CORS issue detected. Please run Flutter with --web-browser-flag "--disable-web-security" or use desktop app.');
      } else {
        throw Exception('LM Studio error (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('LM Studio Service Error: $e');
      if (e.toString().contains('XMLHttpRequest')) {
        throw Exception('CORS error: Run Flutter with --web-browser-flag "--disable-web-security" or use desktop app.');
      } else if (e.toString().contains('timed out') || e.toString().contains('TimeoutException')) {
        throw Exception('Request timed out. The AI model might be taking longer than expected. Please try again with a shorter message.');
      } else if (e.toString().contains('Connection refused') || e.toString().contains('SocketException')) {
        throw Exception('Cannot connect to LM Studio. Make sure it\'s running on localhost:1234');
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