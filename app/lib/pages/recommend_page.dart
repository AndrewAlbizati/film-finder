import 'package:app/service/account.dart';
import 'package:app/service/movie.dart';
import 'package:flutter/material.dart';

class RecommendPage extends StatefulWidget {
  final Account account;
  final List<Movie> recommendedMovies;

  const RecommendPage({
    Key? key,
    required this.account,
    required this.recommendedMovies,
  }) : super(key: key);

  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Movies'),
      ),
      body: ListView.builder(
        itemCount: widget.recommendedMovies.length,
        itemBuilder: (context, index) {
          final movie = widget.recommendedMovies[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            padding: EdgeInsets.all(16.0),
            height: 350.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200.0,
                  height: 300.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(movie.poster),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Expanded(
                        child: Text(
                          movie.overview,
                          style: TextStyle(fontSize: 16.0),
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showMovieDescription(BuildContext context, Movie movie) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(movie.title),
          content: Text(movie.overview),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
