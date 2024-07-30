import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';

class SwipeCard extends StatelessWidget {
  final color;

  SwipeCard({required this.color});

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
        color: color,
      ),
    );
  }
}
