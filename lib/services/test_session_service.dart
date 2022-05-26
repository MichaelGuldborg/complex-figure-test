import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reyo/models/test_session.dart';
import 'package:reyo/services/firestore_crud_service.dart';

final collection =
    FirebaseFirestore.instance.collection('session').withConverter<TestSession>(
        toFirestore: (value, _) => value.toMap(),
        fromFirestore: (snapshot, _) {
          final data = snapshot.data() ?? {};
          return TestSession.fromMap({...data, 'id': snapshot.id});
        });

class TestSessionService extends FirestoreCrudService<TestSession> {
  TestSessionService() : super(collection);

  @override
  Future<List<TestSession>> readAll() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final response = await collection
        // .where('userId', isEqualTo: currentUser!.uid)
        .orderBy('start', descending: true)
        .get();
    return response.docs.map((e) => e.data()).toList();
  }
}
