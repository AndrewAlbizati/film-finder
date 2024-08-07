import 'package:app/service/account.dart';
import 'package:app/service/movie.dart';
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

  int _colorIndex = 0;
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.deepOrange,
    Colors.yellow,
    Colors.teal,
    Colors.purpleAccent,
    Colors.purple,
    Colors.redAccent,
    Colors.pinkAccent
  ];

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
    List<Movie> movies = await Movie.getBatchMovies(movieIds);

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
          color: colors[_colorIndex++ % 10],
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.account.username),
            Container(
              height: 300,
              width: 200,
              child: Stack(
                children: _stackItems,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Like")),
                SizedBox(width: 20),
                ElevatedButton(onPressed: () {}, child: Text("Dislike"))
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                List<int> likedMovieIds = [];
                List<int> dislikedMovieIds = [];
                if (_likedMovies.length < 15) {
                  print('need more movies');
                } else {
                  _likedMovies.forEach((element) {
                    likedMovieIds.add(element.id);
                  });
                }

                _dislikedMovies.forEach((element) {
                  dislikedMovieIds.add(element.id);
                });

                Map<String, List<int>> map = {
                  "liked": likedMovieIds,
                  "disliked": dislikedMovieIds
                };
                print(map);
              },
              child: Text('Recommend'),
            )
          ],
        ),
      ),
    );
  }
}
