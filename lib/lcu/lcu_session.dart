import 'dart:async';

import 'lcu_http.dart';
import 'lcu_websocket.dart';
import 'lockfile.dart';

/// A live, connected LCU session: HTTP client + websocket sharing one lockfile.
/// Owned by [LcuConnector]; do not construct directly outside the LCU layer.
class LcuSession {
  LcuSession({required this.lockfile, required this.http, required this.ws});

  final Lockfile lockfile;
  final LcuHttp http;
  final LcuWebsocket ws;

  Future<void> dispose() async {
    http.close();
    await ws.dispose();
  }
}
