import 'package:flutter/material.dart';
import 'package:teacher_tracker/core/services/firebase_teachers_database.dart';
import 'package:teacher_tracker/features/teacher/models/teacher_model.dart';

class TeacherViewmodel extends ChangeNotifier {
  final _firestore = FirebaseTeachersDatabase();
  TeacherModel? _teacher;
  TeacherModel? get teacher => _teacher;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _error;
  String? get error => _error;

  Future<void> fetchTeacher(String uid) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      TeacherModel? list = await _firestore.getTeacherDetail(uid: uid);

      if (list == null) {
        _error = "No teacher exist";
      } else {
        _teacher = list;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTeacher(
    String uid,
    String name,
    String email,
    String department,
    String workingStartTime,
    String workingEndTime,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      TeacherModel? list = await _firestore.addTeacherDetail(
        uid: uid,
        name: name,
        email: email,
        department: department,
        workingStartTime: workingStartTime,
        workingEndTime: workingEndTime,
      );

      if (list == null) _error = "No teacher exist";
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
