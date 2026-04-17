import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:teacher_tracker/core/services/web_socket_service.dart';

enum UserRole { teacher, admin }

class LiveLocationViewModel extends ChangeNotifier {
  final WebSocketService _service = WebSocketService();
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Stream get stream => _service.stream;
  void connect(String url) {
    _service.connect(url);

    _isConnected = true;
    notifyListeners();

    _service.stream.listen(
      (message) {
        debugPrint(message);
      },
      onError: (error) {
        _isConnected = false;
        notifyListeners();
      },
      onDone: () {
        _isConnected = false;
        notifyListeners();
      },
    );
  }

  void sendLocation({
    required String uid,
    required double lat,
    required double long,
    required String name,
    required String email,
    required String department,
    required String geofenceStatus,
  }) {
    final data = jsonEncode({
    'type': 'location',
    'uid': uid,
    'lat': lat,
    'long': long,
    'name': name,
    'email': email,
    'department': department,
    'geofenceStatus': geofenceStatus,
    'timestamp': DateTime.now().toIso8601String(),
  });
    return _service.send(data);
  }

  void disconnect() {
    _service.disconnect();

    _isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _service.disconnect();
    super.dispose();
  }
}
