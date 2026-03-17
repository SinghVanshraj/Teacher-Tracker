import 'package:flutter/material.dart';
import 'package:teacher_tracker/core/services/firebase_teachers_database.dart';
import 'package:teacher_tracker/features/institute/models/institute_model.dart';

class InstituteViewModel extends ChangeNotifier {
  final _firestore = FirebaseTeachersDatabase();
  InstituteModel? _instituteModel;
  InstituteModel? get instituteModel => _instituteModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> getInstitute(String iId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      InstituteModel? institute = await _firestore.getInstitute(
        instituteId: iId,
      );
      if (_instituteModel == null) {
        _error = "Something went wrong";
      } else {
        _instituteModel = institute;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
