import 'package:flutter/material.dart';
import 'package:teacher_tracker/features/institute/models/institute_model.dart';

class InstituteViewModel extends ChangeNotifier {
  InstituteModel? _instituteModel;
  InstituteModel? get instituteModel => _instituteModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  
}
