import 'package:flutter/material.dart';

import '../../../data/services/movie_list_service.dart';
import '../../../models/movie_model.dart';

class MovieDetailsScreen extends StatefulWidget {
  final MovieModel movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final MovieListService movieListService = MovieListService();

  Map<String, bool> listStates = {
    'favorites': false,
    'watched': false,
    'watching': false,
    'wantToWatch': false,
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadListStates();
  }

  Future<void> loadListStates() async {
    final favorites = await movieListService.isMovieInList(
      widget.movie,
      'favorites',
    );

    final watched = await movieListService.isMovieInList(
      widget.movie,
      'watched',
    );

    final watching = await movieListService.isMovieInList(
      widget.movie,
      'watching',
    );

    final wantToWatch = await movieListService.isMovieInList(
      widget.movie,
      'wantToWatch',
    );

    if (!mounted) return;

    setState(() {
      listStates = {
        'favorites': favorites,
        'watched': watched,
        'watching': watching,
        'wantToWatch': wantToWatch,
      };

      isLoading = false;
    });
  }

  Future<void> toggleList(
      String listName,
      String addMessage,
      String removeMessage,
      ) async {
    final isAdded = listStates[listName] ?? false;

    try {
      if (isAdded) {
        await movieListService.removeMovie(
          widget.movie,
          listName,
        );
      } else {
        await movieListService.addMovie(
          widget.movie,
          listName,
        );
      }

      if (!mounted) return;

      setState(() {
        listStates[listName] = !isAdded;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAdded ? removeMessage : addMessage,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F0F0F),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 430,
            pinned: true,
            backgroundColor: const Color(0xff0F0F0F),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://image.tmdb.org/t/p/w780${widget.movie.posterPath}',
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xff1A1A1A),
                        child: const Icon(
                          Icons.movie,
                          color: Colors.white54,
                          size: 60,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color(0xff0F0F0F),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.movie.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white60,
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.movie.releaseDate.isEmpty
                            ? 'Unknown'
                            : widget.movie.releaseDate,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Add to your list',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffA9162B),
                      ),
                    )
                  else ...[
                    Row(
                      children: [
                        Expanded(
                          child: listButton(
                            Icons.favorite_border,
                            Icons.favorite,
                            'Favorites',
                            'favorites',
                            'Added to Favorites',
                            'Removed from Favorites',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: listButton(
                            Icons.check_circle_outline,
                            Icons.check_circle,
                            'Watched',
                            'watched',
                            'Added to Watched',
                            'Removed from Watched',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: listButton(
                            Icons.play_circle_outline,
                            Icons.play_circle,
                            'Watching',
                            'watching',
                            'Added to Watching',
                            'Removed from Watching',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: listButton(
                            Icons.bookmark_border,
                            Icons.bookmark,
                            'Want to Watch',
                            'wantToWatch',
                            'Added to Want to Watch',
                            'Removed from Want to Watch',
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 28),

                  const Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    widget.movie.overview.isEmpty
                        ? 'No overview available.'
                        : widget.movie.overview,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listButton(
      IconData emptyIcon,
      IconData filledIcon,
      String title,
      String listName,
      String addMessage,
      String removeMessage,
      ) {
    final isAdded = listStates[listName] ?? false;

    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          toggleList(
            listName,
            addMessage,
            removeMessage,
          );
        },
        icon: Icon(
          isAdded ? filledIcon : emptyIcon,
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isAdded
              ? const Color(0xff7D1020)
              : const Color(0xffA9162B),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}