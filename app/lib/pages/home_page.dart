import 'package:app/pages/recommend_page.dart';
import 'package:app/service/account.dart';
import 'package:app/service/movie.dart';
import 'package:app/widgets/error_popup.dart';
import 'package:app/widgets/swipe_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Account account;
  const HomePage({Key? key, required this.account}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int movieBufferSize = 50;
  final int minimumRefreshCount = 10;

  int _movieIndexStart = 0;

  List<Widget> _stackItems = [];

  List<Movie> _likedMovies = [];
  List<Movie> _dislikedMovies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    List<int> movieIds = await Movie.getMovieIds();

    int startIndex = _movieIndexStart;
    _movieIndexStart += movieBufferSize;
    int endIndex = _movieIndexStart;

    movieIds = movieIds.sublist(startIndex, endIndex);
    List<Movie> movies =
        await Movie.getBatchMovies(movieIds, widget.account.token);

    movies.forEach((element) {
      _addMovie(element);
    });
  }

  void _addMovie(Movie movie) {
    setState(() {
      _stackItems.insert(
        0,
        SwipeCard(
          movie: movie,
          swipeLeft: _dislikeMovie,
          swipeRight: _likeMovie,
        ),
      );
    });
  }

  void _addMoreMovies() {
    setState(() {
      _stackItems.removeLast();

      if (_stackItems.length < minimumRefreshCount) {
        _loadMovies();
      }
    });
  }

  void _likeMovie(Movie movie) {
    _likedMovies.add(movie);
    _addMoreMovies();
  }

  void _dislikeMovie(Movie movie) {
    _dislikedMovies.add(movie);
    _addMoreMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FilmFinder')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: 600,
              width: 400,
              child: Stack(
                children: _stackItems,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                List<int> likedMovieIds = [];
                List<int> dislikedMovieIds = [];

                if (_likedMovies.length >= 15) {
                  _likedMovies.forEach((element) {
                    likedMovieIds.add(element.id);
                  });

                  _dislikedMovies.forEach((element) {
                    dislikedMovieIds.add(element.id);
                  });

                  Map<String, List<int>> map = {
                    "liked": likedMovieIds,
                    "disliked": dislikedMovieIds
                  };

                  List<Movie> movies =
                      await Movie.batchRecommend(map, widget.account.token);
                  movies = movies.sublist(0, 20);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecommendPage(
                        account: widget.account,
                        recommendedMovies: movies,
                      ),
                    ),
                  );
                } else {
                  showError(context, 'Like more movies',
                      'Please like at least ${15 - _likedMovies.length} more movies before asking for recommendations.');
                }
              },
              child: Text('Recommend'),
            )
          ],
        ),
      ),
    );
  }
}
