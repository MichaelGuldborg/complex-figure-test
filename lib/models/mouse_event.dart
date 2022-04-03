import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
    this.delta,
    this.duration,
    this.device,
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    final _time = '${timestamp.hour}:${timestamp.minute}:${timestamp.second}.${_threeDigits(timestamp.millisecond)}';
    // final _time = '${timestamp.toIso8601String()}';
    final _type = type.name;
    final _position = '$position'.replaceAll('Offset', '');
    final _delta = delta == null ? '' : '$delta'.replaceAll('Offset', '');
    return '$_time $_type $_position $_delta';
  }

  static String _threeDigits(int n) {
    if (n >= 100) return "${n}";
    if (n >= 10) return "0${n}";
    return "00${n}";
  }
}
