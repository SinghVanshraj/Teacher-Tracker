import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_tracker/core/services/firebase_teachers_database.dart';

class AdminViewModel extends ChangeNotifier {
  final _firestore = FirebaseTeachersDatabase();

  QuerySnapshot? _teachers;
  QuerySnapshot? get teachers => _teachers;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _error;
  String? get error => _error;

  Future<void> fetchTeachers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _teachers = await _firestore.getTeachers();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
