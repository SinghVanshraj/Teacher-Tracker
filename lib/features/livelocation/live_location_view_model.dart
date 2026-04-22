import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:teacher_tracker/core/services/web_socket_service.dart';
import 'package:teacher_tracker/features/livelocation/live_location_model.dart';

class LiveLocationViewModel extends ChangeNotifier {
  final WebSocketService _service = WebSocketService();

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  String? _role;
  String? _uid;

  Timer? _locationTimer;

  // Admin sees all teachers keyed by uid
  final Map<String, LiveLocationModel> _teacherLocations = {};
  Map<String, LiveLocationModel> get teacherLocations => _teacherLocations;

  void connect({
    required String url,
    required String uid,
    required String role,
  }) {
    _role = role;
    _uid = uid;

    _service.connect(url);

    // Register with server after connecting
    Future.delayed(const Duration(milliseconds: 500), () {
      _service.send(jsonEncode({
        'type': 'register',
        'uid': uid,
        'role': role,
      }));
      _isConnected = true;
      notifyListeners();
    });

    _service.stream.listen(
      (message) {
        _handleMessage(message);
        notifyListeners();
      },
      onError: (error) {
        debugPrint('WS Error: $error');
        _isConnected = false;
        notifyListeners();
      },
      onDone: () {
        _isConnected = false;
        notifyListeners();
      },
    );
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String);
      if (data['type'] == 'location') {
        final location = LiveLocationModel.fromJson(data);
        if (_role == 'admin') {
          // admin stores all teachers keyed by uid
          _teacherLocations[location.uid] = location;
        }
      }
    } catch (e) {
      debugPrint('Parse error: $e');
    }
  }

  // Teacher calls this to start sending location every 5 seconds
  void startSendingLocation({
    required double lat,
    required double long,
    required String name,
    required String email,
    required String department,
    required String geofenceStatus,
  }) {
    if (_role != 'teacher') return;
    _locationTimer?.cancel();

    // send immediately then every 5 seconds
    _sendLocation(
      lat: lat,
      long: long,
      name: name,
      email: email,
      department: department,
      geofenceStatus: geofenceStatus,
    );

    _locationTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _sendLocation(
        lat: lat,
        long: long,
        name: name,
        email: email,
        department: department,
        geofenceStatus: geofenceStatus,
      );
    });
  }

  void _sendLocation({
    required double lat,
    required double long,
    required String name,
    required String email,
    required String department,
    required String geofenceStatus,
  }) {
    final data = jsonEncode({
      'type': 'location',
      'uid': _uid,
      'lat': lat,
      'long': long,
      'name': name,
      'email': email,
      'department': department,
      'geofenceStatus': geofenceStatus,
      'timestamp': DateTime.now().toIso8601String(),
    });
    _service.send(data);
  }

  void stopSendingLocation() {
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  void disconnect() {
    stopSendingLocation();
    _service.disconnect();
    _isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    stopSendingLocation();
    _service.dispose();
    super.dispose();
  }
}