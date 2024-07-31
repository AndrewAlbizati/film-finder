import 'package:app/service/account.dart';
import 'package:app/widgets/swipe_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Account account;
  const HomePage({Key? key, required this.account}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                children: [
                  SwipeCard(color: Colors.deepPurple),
                  SwipeCard(color: Colors.red),
                  SwipeCard(color: Colors.green),
                  SwipeCard(color: Colors.black),
                  SwipeCard(color: Colors.blue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
