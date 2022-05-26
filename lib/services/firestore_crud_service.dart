import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reyo/models/identifyable.dart';
import 'package:reyo/services/crud_service.dart';

class FirestoreCrudService<T extends Identifiable> extends CrudService<T> {
  final CollectionReference<T> collection;

  FirestoreCrudService(this.collection);

  @override
  Future<T?> create(T value) async {
    final response = await collection.add(value);
    return await read(response.id);
  }

  @override
  Future delete(String? id) async {
    await collection.doc(id).delete();
  }

  @override
  Future<T?> read(String? id) async {
    final response = await collection.doc(id).get();
    return response.data();
  }

  @override
  Future<List<T>> readAll() async {
    final response = await collection.get();
    return response.docs.map((e) => e.data()).toList();
  }

  @override
  Future<T?> update(String? id, Map<String, dynamic>? value) async {
    if (id == null || value == null) return null;
    await collection.doc(id).update(value);
    return read(id);
  }
}
