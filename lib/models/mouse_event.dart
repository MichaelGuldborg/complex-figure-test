import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';

enum MouseEventType {
  TAP,
  PAN_START,
  PAN_UPDATE,
  PAN_END,
}

class MouseEvent {
  final MouseEventType type;
  final DateTime timestamp;
  final Offset position;

  final Offset? delta;
  final Duration? duration;
  final PointerDeviceKind? device;

  MouseEvent({
    required this.type,
    required this.position,
    required this.timestamp,
    this.delta,
    this.duration,
    this.device,
  });

  @override
  String toString() {
    final _millis = _threeDigits(timestamp.millisecond);
    final _time =
        '${timestamp.hour}:${timestamp.minute}:${timestamp.second}.$_millis';
    // final _time = '${timestamp.toIso8601String()}';
    final _type = type.name;
    final _position = '$position'.replaceAll('Offset', '');
    final _delta = delta == null ? '' : '$delta'.replaceAll('Offset', '');
    return '$_time $_type $_position $_delta';
  }

  static String _threeDigits(int n) {
    if (n >= 100) return "$n";
    if (n >= 10) return "0$n";
    return "00$n";
  }

  factory MouseEvent.fromMap(Map<String, dynamic> map) {
    return MouseEvent(
      type: MouseEventType.values[map['type']],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      position: convertOffset(map['position']!),
      delta: convertOffset(map['delta']),
      duration: map['duration'] != null
          ? Duration(microseconds: map['duration'])
          : null,
      device: map['device'] != null
          ? PointerDeviceKind.values[map['device']]
          : null,
    );
  }

  static Offset convertOffset(String? e) {
    if (e == null) return Offset(0, 0);
    final split = e.split(';');
    return Offset(
      double.parse(split[0]),
      double.parse(split[1]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.index,
      'timestamp': timestamp,
      'position': '${position.dx};${position.dy}',
      'delta': delta != null ? '${delta?.dx};${delta?.dy}' : null,
      'duration': duration?.inMicroseconds,
      'device': device?.index,
    };
  }
}
