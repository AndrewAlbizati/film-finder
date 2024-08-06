import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';

class SwipeCard extends StatelessWidget {
  final String text;
  final Color color;

  SwipeCard({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Swipable(
      onSwipeRight: (finalPosition) {
        print("Swipe right");
      },
      onSwipeLeft: (finalPosition) {
        print("Swipe left");
      },
      child: Container(
        height: 500,
        width: 500,
        color: color,
        child: Text(text),
      ),
    );
  }
}
