import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:reyo/pages/paint/paint_history.dart';

class PathPainter extends CustomPainter {
  final PaintHistory _path;

  PathPainter(this._path, {Listenable? repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _path.draw(canvas, size);
  }

  @override
  bool shouldRepaint(PathPainter oldDelegate) {
    return true;
  }
}