import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/news_response.dart';

class ApiManager {
  static const String _baseUrl = 'newsapi.org';
  static const String _apiKey = 'YOUR_API_KEY_HERE';

  static Future<NewsResponse> searchNews(String query) async {
    final uri = Uri.https(_baseUrl, '/v2/everything', {
      'q': query,
      'apiKey': _apiKey,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return NewsResponse.fromJson(json);
    } else {
      throw Exception('Failed to load news');
    }
  }
}