import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:teacher_tracker/core/services/firebase_services.dart';
import 'package:teacher_tracker/features/userdatainitalmodel/userinitial_model.dart';

class FirebaseUserLoginDb {
  final _firestore = FirebaseServices.firestore;

  UserinitialModel? _userDataFromFirebase(DocumentSnapshot doc) {
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) return null;

    return UserinitialModel.fromJson(data);
  }

  Future<UserinitialModel?> addUserInitial({
    required String userId,
    required String email,
    required String role,
  }) async {
    try {
      final docRef = _firestore.collection("users").doc(userId);

      final userData = {'email': email, 'role': role};

      await docRef.set(userData);

      final doc = await docRef.get();
      return _userDataFromFirebase(doc);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<UserinitialModel?> getUserDetail(String userId) async {
    try {
      final doc = await _firestore.collection("users").doc(userId).get();
      return _userDataFromFirebase(doc);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
