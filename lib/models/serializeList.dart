List<T> serializeList<T>(
  dynamic e,
  T Function(Map<String, dynamic>) serializer,
) {
  if (e == null) return [];
  return (e as List).map((e) => serializer(e)).toList();
}

List<String> serializeListString(dynamic e) {
  if (e == null) return [];
  return (e as List).map((e) => e as String).toList();
}
