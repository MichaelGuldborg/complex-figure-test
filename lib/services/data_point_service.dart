import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reyo/models/data_point.dart';
import 'package:reyo/services/firestore_crud_service.dart';

final collection =
    FirebaseFirestore.instance.collection('data').withConverter<DataPoint>(
        toFirestore: (value, _) => value.toMap(),
        fromFirestore: (snapshot, _) {
          final data = snapshot.data() ?? {};
          return DataPoint.fromMap({...data, 'id': snapshot.id});
        });

class DataPointService extends FirestoreCrudService<DataPoint> {
  DataPointService() : super(collection);

  @override
  Future<List<DataPoint>> readAll() async {
    final response = await collection.orderBy('start', descending: true).get();
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
