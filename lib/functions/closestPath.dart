import 'dart:math';

import 'package:flutter/material.dart';

int closestPath(List<Path> paths, Offset offset) {
  int index = 0;
  double minDist = double.maxFinite;
  for (int i = 0; i < paths.length; i++) {
    final path = paths[i];
    final dist = distanceToPath(path, offset);
    if (dist < minDist) {
      index = i;
      minDist = dist;
    }
  }
  return index;
}

double distanceToPath(Path path, Offset offset) {
  final metrics = path.computeMetrics();
  double minDistance = double.maxFinite;
  for (var element in metrics) {
    for (var i = 0; i < element.length; i++) {
      final tangent = element.getTangentForOffset(i.toDouble());
      final position = tangent?.position;
      if (position == null) continue;
      final distance = distanceOffset(position, offset);
      if (distance < minDistance) {
        minDistance = distance;
      }
    }
  }
  return minDistance;
}

double distanceOffset(Offset a, Offset b) {
  double dx = a.dx - b.dx;
  double dy = a.dy - b.dy;
  double distance = sqrt(dx * dx + dy * dy);
  return distance.abs();
}
