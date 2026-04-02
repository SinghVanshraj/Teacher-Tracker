import 'dart:convert';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import 'package:teacher_tracker/core/services/web_socket_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
  }) {
    final data = jsonEncode({"uid": uid, "lat": lat, "long": long});

    return _service.send(data);
  }

  void disconnect() {
    _service.disconnect();

    _isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _service.disconnect();
    super.dispose();
  }
}
