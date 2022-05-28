import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reyo/components/primary_button.dart';
import 'package:reyo/functions/capitalize.dart';
import 'package:reyo/functions/closestPath.dart';
import 'package:reyo/models/complex_figure_test.dart';
import 'package:reyo/pages/home/path_painter.dart';
import 'package:reyo/providers/complex_figure_test_provider.dart';

enum ScoreType {
  Unrecognizable,
  Recognizable,
  Incorrect,
  Correct,
}

final scoreTypeMap = {
  ScoreType.Unrecognizable: 0,
  ScoreType.Recognizable: 0.5,
  ScoreType.Incorrect: 1,
  ScoreType.Correct: 2,
};

final colorTypeMap = {
  ScoreType.Unrecognizable: Colors.grey,
  ScoreType.Recognizable: Colors.red,
  ScoreType.Incorrect: Colors.yellow,
  ScoreType.Correct: Colors.green,
};

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  double accuracy = 0;
  int currentIndex = 0;
  List<int> selected = [];
  Map<int, Color> colorMap = {};

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)?.settings.arguments;
    final value = argument as ComplexFigureTest;
    final provider = ComplexFigureTestProvider.of(context);
    final scale = 0.5;
    final paths = value.toPaths(scale: scale);
    final targetPaths = cftPaths(
      offset:
          value.orientation == 'portrait' ? Offset(20, 80) : Offset(120, 80),
    );
    final size = Size(
      value.width.toDouble() * scale,
      value.height.toDouble() * scale,
    );

    void _done() {
      provider.update(value.id, {
        'accuracy': accuracy,
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
      if (currentIndex == paths.length - 1) {
        _done();
      }
      setState(() {
        selected.forEach((i) {
          colorMap[i] = colorTypeMap[type] ?? Colors.black;
        });
        final value = scoreTypeMap[type] ?? 0;
        accuracy += value * selected.length;
        selected.clear();
        currentIndex = min(paths.length - 1, currentIndex + 1);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Test review'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text(
                      '${capitalize(value.type?.replaceAll('-', ' '))} drawing',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Target complex figure',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '1. Click on the lines corresponding to the highlighted stroke on the left',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        '2. Click on the button that best describes the selected lines',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTapUp: (e) {
                      final index = closestPath(targetPaths, e.localPosition);
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
                        paths: targetPaths,
                        selected: selected,
                        colorMap: colorMap,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 24, bottom: 16),
                        child: IconButton(
                          onPressed: () {
                            final style =
                                TextStyle(fontSize: 18, color: Colors.black);
                            final styleBold = TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold);
                            showDialog(
                              context: context,
                              builder: (context) => SimpleDialog(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Info'),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.close))
                                  ],
                                ),
                                contentPadding: EdgeInsets.all(24),
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Unrecognizable:\n',
                                          style: styleBold,
                                        ),
                                        TextSpan(
                                            text:
                                                'If you can\'t recognize where the stroke fit in the figure.\n'),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Recognizable:\n',
                                          style: styleBold,
                                        ),
                                        TextSpan(
                                            text:
                                                'If you recognize where the stroke fit in the figure, but its misplaced and incomplete or distorted.\n'),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Incorrect:\n',
                                          style: styleBold,
                                        ),
                                        TextSpan(
                                            text:
                                                'If you recognize where the stroke fit in the figure, but its either misplaced, incomplete or distorted.\n'),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: style,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Correct:\n',
                                          style: styleBold,
                                        ),
                                        TextSpan(
                                            text:
                                                'If the stroke correctly fits its place in the figure.\n'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.help_outline,
                            size: 32,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PrimaryButton.grey(
                            text: 'Unrecognizable',
                            onPressed: () => _next(ScoreType.Unrecognizable),
                          ),
                          PrimaryButton.red(
                            text: 'Recognizable',
                            onPressed: () => _next(ScoreType.Recognizable),
                          ),
                          // Distorted/Misplaced/Incomplete
                          PrimaryButton.yellow(
                            text: 'Incorrect',
                            onPressed: () => _next(ScoreType.Incorrect),
                          ),
                          PrimaryButton.green(
                            text: 'Correct',
                            onPressed: () => _next(ScoreType.Correct),
                          ),
                        ],
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

Path line(Offset from, Offset to) {
  return Path()
    ..moveTo(from.dx, from.dy)
    ..lineTo(to.dx, to.dy);
}

List<Path> cftPaths({
  double width = 400,
  double height = 290,
  Offset offset = const Offset(120, 80),
}) {
  final List<Path> paths = [];
  final topLeft = Offset(offset.dx, offset.dy);
  final centerLeft = Offset(topLeft.dx, topLeft.dy + height / 2);
  final bottomLeft = Offset(topLeft.dx, topLeft.dy + height);
  final topRight = Offset(topLeft.dx + width, topLeft.dy);
  final centerRight = Offset(topRight.dx, topRight.dy + height / 2);
  final bottomRight = Offset(topRight.dx, topRight.dy + height);
  final topCenter = Offset(topLeft.dx + width / 2, topLeft.dy);
  final bottomCenter = Offset(bottomLeft.dx + width / 2, bottomLeft.dy);
  final center = Offset(topLeft.dx + width / 2, topLeft.dy + height / 2);

  // box outline
  paths.add(line(topLeft, centerLeft));
  paths.add(line(centerLeft, bottomLeft));
  paths.add(line(bottomLeft, bottomCenter));
  paths.add(line(bottomCenter, bottomRight));
  paths.add(line(bottomRight, centerRight));
  paths.add(line(centerRight, topRight));
  paths.add(line(topLeft, topCenter));
  paths.add(line(topCenter, topRight));

  // box x
  paths.add(line(topLeft, center));
  paths.add(line(center, bottomRight));
  paths.add(line(bottomLeft, center));
  paths.add(line(center, topRight));

  // box +
  paths.add(line(centerLeft, center));
  paths.add(line(center, centerRight));
  paths.add(line(topCenter, center));
  paths.add(line(center, bottomCenter));

  return paths;
}
