import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/movie_model.dart';

class MovieListService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addMovie(
      MovieModel movie,
      String listName,
      ) async {
    final user = auth.currentUser;

    if (user == null) return;

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection(listName)
        .doc(movie.id.toString())
        .set({
      'id': movie.id,
      'title': movie.title,
      'overview': movie.overview,
      'posterPath': movie.posterPath,
      'rating': movie.rating,
      'releaseDate': movie.releaseDate,
    });
  }

  Future<void> removeMovie(
      MovieModel movie,
      String listName,
      ) async {
    final user = auth.currentUser;

    if (user == null) return;

    await firestore
        .collection('users')
        .doc(user.uid)
        .collection(listName)
        .doc(movie.id.toString())
        .delete();
  }

  Future<bool> isMovieInList(
      MovieModel movie,
      String listName,
      ) async {
    final user = auth.currentUser;

    if (user == null) return false;

    final doc = await firestore
        .collection('users')
        .doc(user.uid)
        .collection(listName)
        .doc(movie.id.toString())
        .get();

    return doc.exists;
  }

  Stream<List<MovieModel>> getMovies(
      String listName,
      ) {
    final user = auth.currentUser;

    if (user == null) {
      return Stream.value([]);
    }

    return firestore
        .collection('users')
        .doc(user.uid)
        .collection(listName)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return MovieModel(
          id: data['id'] ?? 0,
          title: data['title'] ?? '',
          overview: data['overview'] ?? '',
          posterPath: data['posterPath'] ?? '',
          rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
          releaseDate: data['releaseDate'] ?? '',
        );
      }).toList();
    });
  }
}