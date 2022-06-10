import 'dart:math';

String truncate(String? s, int maxLength) {
  if (s == null) return '';
  final suffix = s.length > maxLength ? '...' : '';
  return s.substring(0, min(maxLength, s.length)).trim() + suffix;
}
