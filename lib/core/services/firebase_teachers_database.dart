import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:teacher_tracker/core/services/firebase_services.dart';
import 'package:teacher_tracker/features/teacher/models/teacher_model.dart';

class FirebaseTeachersDatabase {
  final _firestore = FirebaseServices.firestore;

  TeacherModel? _teacherDataBase(DocumentSnapshot doc) {
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return null;

    return TeacherModel.fromJson(data);
  }

  Future<TeacherModel?> addTeacherDetail({
    required String uid,
    required String name,
    required String email,
    required String department,
    required String workingStartTime,
    required String workingEndTime,
  }) async {
    try {
      final docRef = _firestore.collection("teachers").doc(uid);
      final teacherData = {
        'name': name,
        'email': email,
        'department': department,
        'workingStartTime': workingStartTime,
        'workingEndTime': workingEndTime,
      };

      await docRef.set(teacherData);

      final doc = await docRef.get();
      return _teacherDataBase(doc);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<TeacherModel?> getTeacherDetail({required String uid}) async {
    try {
      final docRef = await _firestore.collection('teachers').doc(uid).get();
      return _teacherDataBase(docRef);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<QuerySnapshot> getTeachers() {
    return _firestore.collection("teachers").get();
  }
}
