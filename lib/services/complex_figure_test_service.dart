import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reyo/models/complex_figure_test.dart';
import 'package:reyo/services/firestore_crud_service.dart';

final collection = FirebaseFirestore.instance
    .collection('test')
    .withConverter<ComplexFigureTest>(
        toFirestore: (value, _) => value.toMap(),
        fromFirestore: (snapshot, _) {
          final data = snapshot.data() ?? {};
          return ComplexFigureTest.fromMap({...data, 'id': snapshot.id});
        });

class ComplexFigureTestService extends FirestoreCrudService<ComplexFigureTest> {
  ComplexFigureTestService() : super(collection);

  @override
  Future<List<ComplexFigureTest>> readAll() async {
    final response = await collection.orderBy('start', descending: false).get();
    return response.docs.map((e) => e.data()).toList();
  }

  static Future<String?> uploadImage(final filename, Uint8List? data) async {
    if (data == null) return null;
    final ref = FirebaseStorage.instance.ref('data/$filename');
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putData(data, metadata);
    return ref.getDownloadURL();
  }
}
