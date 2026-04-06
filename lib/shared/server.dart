import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';

final Map<WebSocket, Map<String, String>> cilents = {};

void main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  debugPrint("WebSocket server running");

  await for (HttpRequest request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      final ws = await WebSocketTransformer.upgrade(request);
      debugPrint('New client connected');
      handleClient(ws);
    }
  }
}

void handleClient(WebSocket ws) {
  cilents[ws] = {};

  ws.listen(
    (message) {
      try {
        final data = jsonDecode(message as String);

        if (data['type'] == 'register') {
          cilents[ws] = {'role': data['role'], 'uid': data['uid']};
          debugPrint("Registered");
          return;
        }

        if (data['type'] == 'location') {
          final sender = cilents[ws];
          if (sender?['role'] != 'teacher') return;

          debugPrint('Location');

          cilents.forEach((cilent, info) {
            if (info['role'] == 'admin' &&
                cilent.readyState == WebSocket.open) {
              cilent.add(
                jsonEncode({
                  'type': 'location',
                  'uid': sender?['uid'],
                  'lat': data['lat'],
                  'long': data['long'],
                  'timestamp': data['timestamp'],
                }),
              );
            }
          });
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    },
    onDone: () {
      cilents.remove(ws);
    },
    onError: (error) {
      cilents.remove(ws);
    },
  );
}
