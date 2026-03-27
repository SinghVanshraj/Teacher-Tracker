import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;

  Stream get stream => _channel.stream;

  void connectStream(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void sendLocation(String location) {
    _channel.sink.add(location);
  }

  void disconnectLocation() {
    _channel.sink.close();
  }
}
