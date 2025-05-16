import 'dart:convert';
import 'dart:io';

import 'package:league_better_client/api/betterClientApi.dart';
import 'package:web_socket_channel/io.dart';

class LcuWebSocketClient {
  late IOWebSocketChannel? _channel = null;
  late LockfileInfo? lockfile = null;

  LcuWebSocketClient();

  Future<void> connect(String eventType) async {
    lockfile ??= await readLockfile() ?? LockfileInfo(password: '', port: 0);
    final basicAuth = base64Encode(utf8.encode('riot:${lockfile!.password}'));

    final uri = Uri.parse('wss://127.0.0.1:${lockfile!.port}');

    final socket = await WebSocket.connect(
      uri.toString(),
      customClient:
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true,
      headers: {HttpHeaders.authorizationHeader: 'Basic $basicAuth'},
    );

    _channel = IOWebSocketChannel(socket);

    _channel!.sink.add(jsonEncode([5, eventType]));
    print('Connected to $eventType WebSocket');

  }

  void disconnect() {
    _channel!.sink.close();
  }

  void sendMessage(String message) {
    _channel!.sink.add(message);
  }

  void listen(void Function(dynamic) onMessage) {
    _channel!.stream.listen(onMessage);
  }
}
