import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_color/rainbow_color.dart';
import 'package:reyo/models/identifyable.dart';
import 'package:reyo/models/mouse_event.dart';
import 'package:reyo/models/serializeList.dart';

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
  final String? notes;

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
    this.notes,
    this.image,
    this.imageFile,
  });

  List<Stroke> toStrokes({
    double time = double.maxFinite,
    double scale = 1,
    List<Color> colors = const [],
  }) {
    return createStrokes(
      events,
      time: time,
      scale: scale,
      colors: colors,
    );
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
      'notes': notes,
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
      notes: map['notes'],
    );
  }
}

List<Stroke> createStrokes(
  List<MouseEvent> events, {
  double time = double.maxFinite,
  double scale = 1,
  List<Color> colors = const [],
  bool hideTouch = true,
}) {
  if (events.isEmpty) return [];
  final startMillis = events.first.timestamp.microsecondsSinceEpoch;
  final endMillis = events.last.timestamp.microsecondsSinceEpoch;
  final durationMillis = endMillis - startMillis;
  final _colors = colors.isEmpty ? [Colors.black, Colors.black] : colors;
  final rainbow = RainbowColorTween(_colors);
  final List<Stroke> strokes = [];

  var skip = false;
  for (var i = 0; i < events.length; i++) {
    final e = events[i];
    final _millis = e.timestamp.microsecondsSinceEpoch - startMillis;
    final _percent = _millis / durationMillis;
    if (_millis > time) return strokes;

    final isTouch = e.device == PointerDeviceKind.touch;
    if (hideTouch && e.type == MouseEventType.PAN_START) {
      skip = isTouch;
    }
    if (skip) continue;

    if (e.type == MouseEventType.PAN_START) {
      final path = Path();
      final dx = e.position.dx * scale;
      final dy = e.position.dy * scale;
      path.moveTo(dx, dy);
      strokes.add(
        Stroke(
          index: strokes.length,
          path: path,
          color: rainbow.transform(_percent),
          start: e.timestamp,
        ),
      );
    } else if (e.type == MouseEventType.PAN_UPDATE) {
      final dx = e.position.dx * scale;
      final dy = e.position.dy * scale;
      strokes.last.path.lineTo(dx, dy);
      strokes.last.end = e.timestamp;
    } else if (e.type == MouseEventType.UNDO) {
      strokes.removeLast();
    }
  }

  return strokes;
}

class Stroke {
  final int index;
  final Path path;
  final Color color;
  DateTime? start;
  DateTime? end;

  Stroke({
    required this.index,
    required this.path,
    required this.color,
    this.start,
    this.end,
  });
}
