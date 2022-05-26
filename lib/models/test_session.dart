import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reyo/models/identifyable.dart';
import 'package:reyo/models/serializeList.dart';

class TestSession extends Identifiable {
  @override
  final String? id;
  final DateTime start;
  final String? name;
  final DateTime? birthDate;
  final String? sex;
  final String? education;

  final List<String> testIds;

  TestSession({
    required this.id,
    required this.testIds,
    required this.start,
    this.name,
    this.birthDate,
    this.sex,
    this.education,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start': start,
      'name': name,
      'birthDate': birthDate,
      'sex': sex,
      'education': education,
      'testIds': testIds,
    };
  }

  factory TestSession.fromMap(Map<String, dynamic> map) {
    return TestSession(
      id: map['id'],
      testIds: serializeListString(map['testIds']),
      start: (map['start'] as Timestamp).toDate(),
      name: map['name'],
      // birthDate: (map['birthDate'] as Timestamp).toDate(),
      sex: map['sex'],
      education: map['education'],
    );
  }
}
