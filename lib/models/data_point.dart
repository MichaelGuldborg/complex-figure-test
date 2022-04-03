import 'package:reyo/models/mouse_event.dart';

class DataPoint {
  final int width;
  final int height;
  final List<MouseEvent> events;
  final int strokes;
  final DateTime? start;
  final DateTime? end;

  DataPoint({
    this.width = 0,
    this.height = 0,
    this.events = const [],
    this.strokes = 0,
    this.start,
    this.end,
  });
}
