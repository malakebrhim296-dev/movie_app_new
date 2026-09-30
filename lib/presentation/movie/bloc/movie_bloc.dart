import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/movie_service.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieService movieService;

  MovieBloc(this.movieService) : super(MovieState()) {
    on<GetPopularMoviesEvent>((event, emit) async {
      try {
        final movies = await movieService.getPopularMovies();

        emit(
          MovieState(
            movies: movies,
          ),
        );
      } catch (e) {
        print(e);
      }
    });
  }
}