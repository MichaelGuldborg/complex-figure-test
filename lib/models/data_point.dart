import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reyo/models/identifyable.dart';
import 'package:reyo/models/mouse_event.dart';

class DataPoint extends Identifiable {
  @override
  final String id;
  final int width;
  final int height;
  final String? orientation;
  final List<MouseEvent> events;
  final DateTime start;
  final DateTime end;
  final String? image;


  int get duration {
    final startMillis = start.microsecondsSinceEpoch;
    final endMillis = end.microsecondsSinceEpoch;
    return endMillis - startMillis;
  }

  DataPoint({
    required this.id,
    required this.start,
    required this.end,
    this.width = 0,
    this.height = 0,
    this.orientation,
    this.events = const [],
    this.image,
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

  factory DataPoint.fromMap(Map<String, dynamic> map) {
    return DataPoint(
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

List<T> serializeList<T>(
  dynamic e,
  T Function(Map<String, dynamic>) serializer,
) {
  if (e == null) return [];
  return (e as List).map((e) => serializer(e)).toList();
}
