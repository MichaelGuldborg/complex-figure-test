import 'package:flutter/material.dart' hide Image;

class PaintHistory {
  static get _backgroundPaint {
    final paint = Paint();
    paint.blendMode = BlendMode.dstOver;
    paint.color = Colors.white;
    return paint;
  }

  static get strokePaint {
    final paint = Paint();
    paint.blendMode = BlendMode.srcOver;
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4.0;
    return paint;
  }

  final List<PaintEntry> paths;
  Paint currentPaint = strokePaint;
  bool _inDrag = false;

  PaintHistory({
    paths,
  }) : paths = paths ?? [];

  void undo() {
    if (paths.isEmpty) return;
    if (_inDrag) return;
    paths.removeLast();
  }

  void clear() {
    if (_inDrag) return;
    paths.clear();
  }

  void add(Offset point) {
    // print('add: ${point.dx} ${point.dy}');
    if (_inDrag) return;
    _inDrag = true;
    Path path = Path();
    path.moveTo(point.dx, point.dy);
    paths.add(PaintEntry(path, currentPaint));
  }

  void update(Offset point) {
    // print('update: ${point.dx} ${point.dy}');
    if (!_inDrag) return;
    Path path = paths.last.path;
    path.lineTo(point.dx, point.dy);
  }

  void end() {
    _inDrag = false;
  }

  void draw(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    for (PaintEntry entry in paths) {
      canvas.drawPath(entry.path, entry.paint);
    }
    final background = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    canvas.drawRect(background, _backgroundPaint);
    canvas.restore();
  }
}

class PaintEntry {
  final Path path;
  final Paint paint;

  PaintEntry(this.path, this.paint);
}
