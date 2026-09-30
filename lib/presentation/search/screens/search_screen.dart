import 'package:flutter/material.dart';
import '../../../data/services/movie_service.dart';
import '../../../models/movie_model.dart';
import '../../movie/screens/movie_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  List<MovieModel> movies = [];
  bool isLoading = false;
  bool hasSearched = false;
  bool hasError = false;

  Future<void> searchMovies() async {
    final query = searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        movies = [];
        hasSearched = false;
        hasError = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      hasSearched = true;
      hasError = false;
      movies = [];
    });

    try {
      final result = await MovieService().searchMovies(query);

      if (!mounted) return;

      setState(() {
        movies = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xff0F0F0F),
        elevation: 0,
        title: const Text(
          'Search Movies',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              style: const TextStyle(
                color: Colors.white,
              ),
              onSubmitted: (_) {
                searchMovies();
              },
              decoration: InputDecoration(
                hintText: 'Search for a movie...',
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white54,
                ),
                suffixIcon: IconButton(
                  onPressed: searchMovies,
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Color(0xffA9162B),
                  ),
                ),
                filled: true,
                fillColor: const Color(0xff1A1A1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xffA9162B),
                ),
              )
                  : hasError
                  ? const Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.white54,
                      size: 55,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Something went wrong.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Please check your internet connection and try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
                  : hasSearched && movies.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.movie_outlined,
                      color: Colors.white54,
                      size: 55,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'No movies found',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Try searching for another movie.',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
                  : !hasSearched
                  ? const Center(
                child: Text(
                  'Search for your favorite movies',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 16,
                  ),
                ),
              )
                  : GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.62,
                ),
                itemCount: movies.length,
                itemBuilder:
                    (context, index) {
                  final movie = movies[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailsScreen(
                                movie: movie,
                              ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(
                        14,
                      ),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                        fit: BoxFit.cover,
                        errorBuilder:
                            (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return Container(
                            color: const Color(
                              0xff1A1A1A,
                            ),
                            child: const Icon(
                              Icons.movie,
                              color:
                              Colors.white54,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}