import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rainbow_color/rainbow_color.dart';
import 'package:reyo/components/primary_button.dart';
import 'package:reyo/models/complex_figure_test.dart';
import 'package:reyo/models/mouse_event.dart';
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
    final paths = toPaths(value, scale: scale);
    final size = Size(
      value.width.toDouble() * scale,
      value.height.toDouble() * scale,
    );

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
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(value.type ?? 'Score complex figure test'),
        // title: Text(value.id),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 24),
            child: PrimaryButton.green(
              text: 'Done',
              onPressed: () {
                provider.update(value.id, {
                  'accuracy': score,
                });
                Navigator.pop(context);
              },
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
                      '$currentIndex/${paths.length - 1}',
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
                      final index = getClosestPath(paths, e.localPosition);
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

class PathPainter extends CustomPainter {
  static Paint get backgroundPaint {
    final paint = Paint();
    paint.blendMode = BlendMode.dstOver;
    paint.color = Colors.white;
    return paint;
  }

  final List<Path> paths;
  final List<Color> colors;
  final List<int> selected;
  final bool selectMode;

  PathPainter({
    required this.paths,
    this.colors = const [],
    this.selected = const [],
    this.selectMode = true,
  }) : super();

  Paint getPaint(int index) {
    final paint = Paint();
    paint.blendMode = BlendMode.srcOver;
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4.0;

    // if valid selected index fade other lines
    if (selectMode) {
      final isActive = selected.contains(index);
      paint.color = isActive ? Colors.black : Colors.black26;
      return paint;
    }

    // if no colors just return black paint
    if (colors.isEmpty) {
      return paint;
    }

    // select relative percent color in rainbow
    final percent = index / paths.length;
    final tween = RainbowColorTween(colors);
    paint.color = tween.transform(percent);
    return paint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());

    for (var i = 0; i < paths.length; i++) {
      final path = paths[i];
      final paint = getPaint(i);
      canvas.drawPath(path, paint);
    }

    final background = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    canvas.drawRect(background, backgroundPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) {
    return true;
  }
}

int getClosestPath(List<Path> paths, Offset offset) {
  int index = 0;
  double minDist = double.maxFinite;
  for (int i = 0; i < paths.length; i++) {
    final path = paths[i];
    final dist = getDistanceToPath(path, offset);
    if (dist < minDist) {
      index = i;
      minDist = dist;
    }
  }
  return index;
}

double getDistanceToPath(Path path, Offset offset) {
  PathMetrics pathMetrics = path.computeMetrics();
  double minDistance = double.maxFinite;
  for (var element in pathMetrics) {
    for (var i = 0; i < element.length; i++) {
      final tangent = element.getTangentForOffset(i.toDouble());
      final position = tangent?.position;
      if (position == null) continue;
      final distance = getDistance(position, offset);
      if (distance < minDistance) {
        minDistance = distance;
      }
    }
  }
  return minDistance;
}

double getDistance(Offset a, Offset b) {
  double dx = a.dx - b.dx;
  double dy = a.dy - b.dy;
  double distance = sqrt(dx * dx + dy * dy);
  return distance.abs();
}

List<Path> toPaths(
  ComplexFigureTest value, {
  double time = double.maxFinite,
  double scale = 1,
}) {
  final startMillis = value.start.microsecondsSinceEpoch;
  final initial = <Path>[];
  return value.events.fold(initial, (List<Path> result, e) {
    final _millis = e.timestamp.microsecondsSinceEpoch - startMillis;
    // if (_millis > time) return result;

    if (e.type == MouseEventType.PAN_START) {
      final path = Path();
      final dx = e.position.dx * scale;
      final dy = e.position.dy * scale;
      path.moveTo(dx, dy);
      result.add(path);
    } else if (e.type == MouseEventType.PAN_UPDATE) {
      final dx = e.position.dx * scale;
      final dy = e.position.dy * scale;
      result.last.lineTo(dx, dy);
    } else if (e.type == MouseEventType.PAN_END) {
      // nothing
    } else if (e.type == MouseEventType.TAP) {
      // nothing
    } else if (e.type == MouseEventType.UNDO) {
      result.removeLast();
    }
    return result;
  });
}
