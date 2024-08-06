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

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    List<int> movieIds = await Movie.getMovieIds();

    movieIds = movieIds.sublist(0, 10);
    List<Movie> movies = await Movie.getBatchMovies(movieIds);

    movies.forEach((element) {
      _addMovie(element.title);
    });
  }

  void _addMovie(String title) {
    setState(() {
      _stackItems.insert(
          0, SwipeCard(text: title, color: colors[_colorIndex++]));
    });
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
          ],
        ),
      ),
    );
  }
}
