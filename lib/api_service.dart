import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_model.dart';

class ApiService {
  static const String baseUrl = 'https://6733ff42a042ab85d11898e6.mockapi.io/news/v1/news';

  Future<List<News>> getNews() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => News.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<void> createNews(News news) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(news.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create news');
    }
  }

  Future<void> updateNews(News news) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${news.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(news.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update news');
    }
  }

  Future<void> deleteNews(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete news');
    }
  }
}
