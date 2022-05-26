String formatDateTime(DateTime e) {
  final year = e.year;
  final month = '${e.month}'.padLeft(2, '0');
  final day = '${e.day}'.padLeft(2, '0');
  final hours = '${e.hour}'.padLeft(2, '0');
  final minutes = '${e.minute}'.padLeft(2, '0');
  return '$day/$month/$year $hours:$minutes';
}
