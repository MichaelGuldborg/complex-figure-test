String capitalize(String? s) {
  if (s == null || s.isEmpty) return '';
  if (s.length == 1) return s.toUpperCase();
  final firstLetter = s[0].toUpperCase();
  return '$firstLetter${s.substring(1)}';
}
