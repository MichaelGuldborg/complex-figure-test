import 'package:flutter/material.dart';
import 'package:rainbow_color/rainbow_color.dart';
import 'package:reyo/models/data_point.dart';
import 'package:reyo/models/mouse_event.dart';
import 'package:reyo/providers/config_provider.dart';

class DataPointView extends StatelessWidget {
  const DataPointView({
    Key? key,
    required this.data,
    this.stroke = -1,
    this.colors = const [],
    this.colorMode = ColorMode.NONE,
  }) : super(key: key);

  final DataPoint data;
  final int stroke;
  final List<Color> colors;
  final ColorMode colorMode;

  Paint getPaint(int stroke) {
    final paint = Paint();
    paint.blendMode = BlendMode.srcOver;
    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4.0;
    if (colorMode == ColorMode.NONE) return paint;
    if (colors.isEmpty) return paint;

    final percent = stroke / data.strokes;
    if (colorMode == ColorMode.SPLIT) {
      final colorIndex = (percent * colors.length).floor();
      paint.color = colors[colorIndex % colors.length];
    }

    if (colorMode == ColorMode.GRADIENT) {
      final tween = RainbowColorTween(colors);
      paint.color = tween.transform(percent);
    }

    return paint;
  }

  List<PathPaintEntry> get pathEntries {
    final entries =
        data.events.fold(<PathPaintEntry>[], (List<PathPaintEntry> result, e) {
      if (e.type == MouseEventType.PAN_START) {
        final paint = getPaint(result.length);
        final path = Path();
        path.moveTo(e.position.dx, e.position.dy);
        result.add(PathPaintEntry(path, paint));
      } else if (e.type == MouseEventType.PAN_UPDATE) {
        result.last.path.lineTo(e.position.dx, e.position.dy);
      } else if (e.type == MouseEventType.PAN_END) {
        // nothing
      } else if (e.type == MouseEventType.TAP) {
        // nothing
      }
      return result;
    });

    if (stroke >= 0 && stroke < entries.length) {
      return entries.sublist(0, stroke);
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: data.width.toDouble(),
      height: data.height.toDouble(),
      child: ClipRect(
        child: CustomPaint(
          painter: PathPainter(pathEntries),
        ),
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

  final List<PathPaintEntry> entries;

  PathPainter(this.entries) : super();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());

    for (PathPaintEntry entry in entries) {
      canvas.drawPath(entry.path, entry.paint);
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

class PathPaintEntry {
  final Path path;
  final Paint paint;

  PathPaintEntry(this.path, this.paint);
}

class LinePaintEntry {
  final Offset line;
  final Paint paint;

  LinePaintEntry(this.line, this.paint);
}
