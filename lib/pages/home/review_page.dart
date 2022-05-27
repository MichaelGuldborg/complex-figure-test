import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reyo/components/primary_button.dart';
import 'package:reyo/functions/capitalize.dart';
import 'package:reyo/functions/closestPath.dart';
import 'package:reyo/models/complex_figure_test.dart';
import 'package:reyo/pages/home/path_painter.dart';
import 'package:reyo/providers/complex_figure_test_provider.dart';

enum ScoreType {
  ERROR,
  INCOMPLETE,
  MISPLACED,
  DISTORTED,
  CORRECT,
}

final scoreTypeMap = {
  ScoreType.ERROR: 0,
  ScoreType.INCOMPLETE: 1,
  ScoreType.MISPLACED: 1,
  ScoreType.DISTORTED: 1,
  ScoreType.CORRECT: 2,
};

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int score = 0;
  int currentIndex = 0;
  List<int> selected = [];

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)?.settings.arguments;
    final value = argument as ComplexFigureTest;
    final provider = ComplexFigureTestProvider.of(context);
    final scale = 0.5;
    final paths = value.toPaths(scale: scale);
    final size = Size(
      value.width.toDouble() * scale,
      value.height.toDouble() * scale,
    );
    void _done() {
      provider.update(value.id, {
        'accuracy': score,
      });
      Navigator.pop(context);
    }

    void _previous() {
      setState(() {
        selected.clear();
        currentIndex = max(0, currentIndex - 1);
      });
    }

    void _next(ScoreType type) {
      if (selected.isNotEmpty) {
        score += scoreTypeMap[type] ?? 0;
      }
      setState(() {
        selected.clear();
        currentIndex = min(paths.length - 1, currentIndex + 1);
      });
      if (currentIndex == paths.length - 1) {
        _done();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(capitalize(value.type?.replaceAll('-', ' '))),
        // title: Text(value.id),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 24),
            child: PrimaryButton.green(
              text: 'Done',
              onPressed: _done,
            ),
          )
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  CustomPaint(
                    size: size,
                    painter: PathPainter(
                      paths: paths,
                      selected: [currentIndex],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${currentIndex + 1}/${paths.length}',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(height: double.maxFinite, width: 2, color: Colors.black),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  GestureDetector(
                    onTapUp: (e) {
                      final index = closestPath(paths, e.localPosition);
                      setState(() {
                        if (selected.contains(index)) {
                          selected.remove(index);
                        } else {
                          selected.add(index);
                        }
                      });
                    },
                    child: CustomPaint(
                      size: size,
                      painter: PathPainter(
                        paths: paths,
                        selected: selected,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PrimaryButton.red(
                        text: '2 or more',
                        onPressed: () => _next(ScoreType.ERROR),
                      ),
                      PrimaryButton.grey(
                        text: 'Incomplete',
                        onPressed: () => _next(ScoreType.INCOMPLETE),
                      ),
                      PrimaryButton.grey(
                        text: 'Misplaced',
                        onPressed: () => _next(ScoreType.MISPLACED),
                      ),
                      PrimaryButton.grey(
                        text: 'Distorted',
                        onPressed: () => _next(ScoreType.DISTORTED),
                      ),
                      PrimaryButton.green(
                        text: 'Correct',
                        onPressed: () => _next(ScoreType.CORRECT),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
