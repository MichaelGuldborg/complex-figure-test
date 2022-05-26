abstract class CrudService<T> {
  Future<List<T>> readAll();

  Future<T?> create(T value);

  Future<T?> read(String? id);

  Future<T?> update(String? id, Map<String, dynamic>? value);

  Future delete(String? id);
}
