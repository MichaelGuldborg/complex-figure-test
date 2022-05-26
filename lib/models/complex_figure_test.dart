import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reyo/models/identifyable.dart';
import 'package:reyo/models/mouse_event.dart';
import 'package:reyo/models/serializeList.dart';

class ComplexFigureTest extends Identifiable {
  @override
  final String id;
  final String? type; // copy, immediate-recall, delayed-recall
  final int width;
  final int height;
  final String? orientation;
  final List<MouseEvent> events;
  final DateTime start;
  final DateTime end;
  final String? image;
  final Picture? imageFile;


  int get duration {
    final startMillis = start.microsecondsSinceEpoch;
    final endMillis = end.microsecondsSinceEpoch;
    return endMillis - startMillis;
  }

  ComplexFigureTest({
    required this.id,
    this.type,
    required this.start,
    required this.end,
    this.width = 0,
    this.height = 0,
    this.orientation,
    this.events = const [],
    this.image,
    this.imageFile,
  });

  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'width': width,
      'start': start,
      'end': end,
      'image': image,
      'events': events.map((e) => e.toMap()).toList(),
    };
  }

  factory ComplexFigureTest.fromMap(Map<String, dynamic> map) {
    return ComplexFigureTest(
      id: map['id'],
      start: (map['start'] as Timestamp).toDate(),
      end: (map['end'] as Timestamp).toDate(),
      width: map['width'],
      height: map['height'],
      image: map['image'],
      events: serializeList(map['events'], MouseEvent.fromMap),
    );
  }
}

