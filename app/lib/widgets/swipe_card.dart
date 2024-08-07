import 'package:app/service/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';

class SwipeCard extends StatelessWidget {
  final Movie movie;
  final Color color;
  final Function swipeLeft;
  final Function swipeRight;

  SwipeCard({
    required this.movie,
    required this.color,
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
      child: Container(
        height: 500,
        width: 500,
        color: color,
        child: Text(movie.title),
      ),
    );
  }
}
