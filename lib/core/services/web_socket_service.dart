import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final _controller = StreamController<dynamic>.broadcast();
  Stream<dynamic> get stream => _controller.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void connect(String url) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));

      _isConnected = true;

      _channel!.stream.listen(
        (message) {
          _controller.add(message);
        },
        onError: (error) {
          debugPrint("Websocket");
          _isConnected = false;
        },
        onDone: () {
          debugPrint("object");
          _isConnected = false;
        },
      );
    } catch (e) {
      debugPrint("object");
      _isConnected = false;
    }
  }

  void send(dynamic data) {
    if (_channel != null && _isConnected) {
      _channel!.sink.add(data);
    } else {
      debugPrint("WebSocket not connected");
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
  }

  Future<void> reconnect(String url) async {
    disconnect();
    await Future.delayed(const Duration(seconds: 2));
    connect(url);
  }

  void dispose() {
    _controller.close();
    disconnect();
  }
}
