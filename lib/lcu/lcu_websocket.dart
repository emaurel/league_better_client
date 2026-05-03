import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/io.dart';

import 'lockfile.dart';

/// One LCU pub/sub event. The LCU uses a WAMP-flavored protocol: client sends
/// `[5, "OnJsonApiEvent"]` to subscribe to everything, server pushes
/// `[8, "OnJsonApiEvent_<resource>", { uri, eventType, data }]`.
class LcuEvent {
  LcuEvent({required this.uri, required this.eventType, required this.data});

  /// Resource path the event refers to, e.g. `/lol-summoner/v1/current-summoner`.
  final String uri;

  /// `Create`, `Update`, or `Delete`.
  final String eventType;

  /// Decoded JSON payload — usually a Map, sometimes a List or null.
  final dynamic data;

  bool matches(String prefix) => uri.startsWith(prefix);

  @override
  String toString() => 'LcuEvent($eventType $uri)';
}

class LcuWebsocket {
  LcuWebsocket(this._lockfile);

  final Lockfile _lockfile;
  IOWebSocketChannel? _channel;
  StreamSubscription? _sub;
  final _events = StreamController<LcuEvent>.broadcast();
  final _connected = StreamController<bool>.broadcast();
  bool _isConnected = false;

  Stream<LcuEvent> get events => _events.stream;
  Stream<bool> get connectionStatus => _connected.stream;
  bool get isConnected => _isConnected;

  Future<void> connect() async {
    final httpClient = HttpClient();
    httpClient.badCertificateCallback = (_, _, _) => true;

    final auth = base64Encode(utf8.encode('riot:${_lockfile.password}'));

    final socket = await WebSocket.connect(
      _lockfile.wsUrl,
      headers: {
        'Authorization': 'Basic $auth',
      },
      customClient: httpClient,
    );

    final channel = IOWebSocketChannel(socket);
    _channel = channel;

    // Subscribe to all JSON API events.
    channel.sink.add(jsonEncode([5, 'OnJsonApiEvent']));

    _sub = channel.stream.listen(
      _onMessage,
      onError: (e, st) => _handleClose(),
      onDone: _handleClose,
      cancelOnError: false,
    );

    _setConnected(true);
  }

  Future<void> close() async {
    _setConnected(false);
    await _sub?.cancel();
    _sub = null;
    await _channel?.sink.close();
    _channel = null;
  }

  Future<void> dispose() async {
    await close();
    await _events.close();
    await _connected.close();
  }

  void _onMessage(dynamic raw) {
    if (raw is! String || raw.isEmpty) return;
    final dynamic parsed;
    try {
      parsed = jsonDecode(raw);
    } catch (_) {
      return;
    }
    // [opcode, eventName, payload]
    if (parsed is! List || parsed.length < 3) return;
    final payload = parsed[2];
    if (payload is! Map) return;
    final uri = payload['uri'];
    final eventType = payload['eventType'];
    if (uri is! String || eventType is! String) return;
    _events.add(
      LcuEvent(uri: uri, eventType: eventType, data: payload['data']),
    );
  }

  void _handleClose() {
    _setConnected(false);
  }

  void _setConnected(bool value) {
    if (_isConnected == value) return;
    _isConnected = value;
    _connected.add(value);
  }
}
