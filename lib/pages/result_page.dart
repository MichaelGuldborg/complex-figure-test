

import 'package:flutter/material.dart';
import 'package:reyo/models/gesture.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gestures = ModalRoute.of(context)!.settings.arguments as List<Gesture>;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: gestures.map((e) {
          return Text(
            e.toString(),
            style: TextStyle(
              // fontFamily: 'RobotoMono',
              // fontWeight: FontWeight.w300,
              // fontSize: 16,
              // letterSpacing: 1.0,
              // wordSpacing: 1.0,
            ),
          );
        }).toList(),
      ),
    );
  }
}
