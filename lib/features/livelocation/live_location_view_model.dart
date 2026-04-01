import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:teacher_tracker/core/services/web_socket_service.dart';

class LiveLocationViewModel extends ChangeNotifier {
  final WebSocketService _service = WebSocketService();

  bool get _isConnected => _service.isConnected;

  void connect(String url) {
    _service.connect(url);
    notifyListeners();
  }

  void sendLocation({
    required String uid,
    required double lat,
    required double long,
  }) {
    final data = jsonEncode({"uid": uid, "lat": lat, "long": long});

    return _service.send(data);
  }

  Stream get stream => _service.stream;

  @override
  void dispose() {
    // TODO: implement dispose
    _service.disconnect();
    super.dispose();
  }
}
