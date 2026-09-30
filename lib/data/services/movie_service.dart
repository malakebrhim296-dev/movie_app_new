import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../models/movie_model.dart';

class MovieService {
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<MovieModel>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular'),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['token']}',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List movies = data['results'] ?? [];

      return movies
          .map((movie) => MovieModel.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/search/movie?query=${Uri.encodeComponent(query)}',
      ),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['token']}',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List movies = data['results'] ?? [];

      return movies
          .map((movie) => MovieModel.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
}