import 'package:app/service/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';

class SwipeCard extends StatelessWidget {
  final Movie movie;
  final Function swipeLeft;
  final Function swipeRight;

  SwipeCard({
    required this.movie,
    required this.swipeLeft,
    required this.swipeRight,
  });

  @override
  Widget build(BuildContext context) {
    return Swipable(
      onSwipeRight: (finalPosition) {
        print("Swipe right");
        swipeRight(movie);
      },
      onSwipeLeft: (finalPosition) {
        print("Swipe left");
        swipeLeft(movie);
      },
      child: Image.network(movie.poster),
    );
  }
}
