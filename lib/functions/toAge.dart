String toAge(DateTime? date) {
  if (date == null) return '';
  final now = DateTime.now();
  final nowMillis = now.millisecondsSinceEpoch;
  final millis = date.millisecondsSinceEpoch;
  final diff = nowMillis - millis;
  return (diff / 31557600000).floor().toString();
}
