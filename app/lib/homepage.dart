import 'package:app/util/swipe_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 300,
          width: 200,
          child: Stack(
            children: [
              // tinder card stack
              SwipeCard(color: Colors.deepPurple),
              SwipeCard(color: Colors.red),
              SwipeCard(color: Colors.green),
              SwipeCard(color: Colors.black),
              SwipeCard(color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
