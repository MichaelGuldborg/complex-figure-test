


import 'package:flutter/material.dart';
import 'package:rainbow_color/rainbow_color.dart';

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
