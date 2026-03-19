import 'package:flutter/material.dart';
import 'package:teacher_tracker/features/location/models/location_model.dart';

class LocationViewmodel extends ChangeNotifier {
  LocationModel? _locationModel;
  bool _tracking = false;
  bool get tracking => _tracking;
  String? _error;
  String? get error => _error;

  Future<void> getCurrentLocation() {

  }
  Future<void> checkPermission() {
    
  }
}
