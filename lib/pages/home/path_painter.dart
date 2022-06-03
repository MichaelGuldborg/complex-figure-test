import 'package:flutter/material.dart';
import 'package:reyo/models/complex_figure_test.dart';

class StrokePainter extends CustomPainter {
  static Paint get backgroundPaint {
    final paint = Paint();
    paint.blendMode = BlendMode.dstOver;
    paint.color = Colors.white;
    return paint;
  }

  final List<Stroke> strokes;
  final List<int> selected;
  final Map<int, Color> colorMap;
  final bool selectMode;

  StrokePainter({
    required this.strokes,
    this.selected = const [],
    this.selectMode = true,
    this.colorMap = const {},
  }) : super();

  Paint getPaint(Stroke stroke) {
    final paint = Paint();
    paint.blendMode = BlendMode.srcOver;
    paint.color = stroke.color;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4.0;

    // if valid selected index fade other lines
    if (selectMode) {
      final isActive = selected.contains(stroke.index);
      paint.color = isActive ? Colors.black : Colors.black26;
      paint.color = colorMap[stroke.index] ?? paint.color;
    }
    return paint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());

    for (var i = 0; i < strokes.length; i++) {
      final stroke = strokes[i];
      final paint = getPaint(stroke);
      canvas.drawPath(stroke.path, paint);
    }

    final background = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    canvas.drawRect(background, backgroundPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(StrokePainter oldDelegate) {
    return true;
  }
}
