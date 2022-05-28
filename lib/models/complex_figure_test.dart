import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reyo/models/identifyable.dart';
import 'package:reyo/models/mouse_event.dart';
import 'package:reyo/models/serializeList.dart';

class Stroke {
  dynamic from;
  dynamic to;
  dynamic start;
  dynamic end;
}

class ComplexFigureTest extends Identifiable {
  @override
  final String id;
  String? type; // copy, immediate-recall, delayed-recall
  final String? orientation;
  final int width;
  final int height;
  final DateTime start;
  final DateTime end;
  final String? image;
  final Picture? imageFile;

  final List<MouseEvent> events;
  final List<dynamic> stokes;

  get bool => accuracy != null && strategy != null;
  final double? accuracy;
  final double? strategy;

  int get duration {
    final startMillis = start.microsecondsSinceEpoch;
    final endMillis = end.microsecondsSinceEpoch;
    return endMillis - startMillis;
  }

  ComplexFigureTest({
    required this.id,
    this.type,
    this.orientation,
    required this.start,
    required this.end,
    this.width = 0,
    this.height = 0,
    this.events = const [],
    this.stokes = const [],
    this.accuracy,
    this.strategy,
    this.image,
    this.imageFile,
  });

  List<Path> toPaths({
    double time = double.maxFinite,
    double scale = 1,
  }) {
    final startMillis = start.microsecondsSinceEpoch;
    final initial = <Path>[];
    return events.fold(initial, (List<Path> result, e) {
      final _millis = e.timestamp.microsecondsSinceEpoch - startMillis;
      if (_millis > time) return result;

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

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'height': height,
      'width': width,
      'start': start,
      'end': end,
      'image': image,
      'events': events.map((e) => e.toMap()).toList(),
      'accuracy': accuracy,
      'strategy': strategy,
    };
  }

  factory ComplexFigureTest.fromMap(Map<String, dynamic> map) {
    return ComplexFigureTest(
      id: map['id'],
      type: map['type'],
      start: (map['start'] as Timestamp).toDate(),
      end: (map['end'] as Timestamp).toDate(),
      width: map['width'],
      height: map['height'],
      image: map['image'],
      events: serializeList(map['events'], MouseEvent.fromMap),
      accuracy: map['accuracy'],
      strategy: map['strategy'],
    );
  }
}
