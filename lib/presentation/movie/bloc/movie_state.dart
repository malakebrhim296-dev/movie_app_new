import '../../../models/movie_model.dart';

class MovieState {
  final List<MovieModel> movies;

  MovieState({
    this.movies = const [],
  });
}