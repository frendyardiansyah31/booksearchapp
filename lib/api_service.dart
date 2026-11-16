import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/book.dart';

class ApiService {
  static const String baseUrl = 'https://catalogue.uiii.ac.id/';

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

  static Future<List<Book>> fetchBooksByCategory(String category) async {
    final encodedCategory = Uri.encodeComponent(category);
    final uri = Uri.parse(
        'https://catalogue.uiii.ac.id/?p=api/biblio/coll_type/$encodedCategory');
    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception(
          'Failed to load books for $category (status ${resp.statusCode})');
    }

    final List<dynamic> jsonData = json.decode(resp.body);
    return jsonData.map((e) => Book.fromJson(e)).toList();
  }
}
