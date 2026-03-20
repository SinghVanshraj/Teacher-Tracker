import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teacher_tracker/features/location/models/location_model.dart';

class LocationViewmodel extends ChangeNotifier {
  LocationModel? _currentLocation;
  LocationModel? get currentLocation => _currentLocation;

  StreamSubscription? _streamSubscription;

  void startTracking(Stream<LocationModel> locationServiceStream) {
    _streamSubscription = locationServiceStream.listen((location) {
      _currentLocation = location;
      notifyListeners();
    });
  }

  void stopTracking() {
    _streamSubscription?.cancel();
  }

  void resumeTracking() {
    _streamSubscription?.resume();
  }

  void pauseTracking() {
    _streamSubscription?.pause();
  }
}
