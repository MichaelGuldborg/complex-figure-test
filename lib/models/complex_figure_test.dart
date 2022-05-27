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
  final int? accuracy;
  final int? strategy;


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

