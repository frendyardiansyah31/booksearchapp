import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/book.dart';

class ApiService {
  static const String baseUrl = 'https://catalog.uiii.ac.id/';

  Future<List<Book>> searchBooks(String keywords) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'p': 'api/biblio/search',
      'keywords': keywords,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      if (jsonBody.containsKey('data')) {
        List<dynamic> data = jsonBody['data'];
        return data.map((item) => Book.fromJson(item)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load books');
    }
  }
}
