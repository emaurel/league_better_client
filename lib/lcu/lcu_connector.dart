import 'dart:async';

import 'lcu_http.dart';
import 'lcu_session.dart';
import 'lcu_websocket.dart';
import 'lockfile.dart';
import 'lockfile_watcher.dart';

enum LcuStatus { idle, searching, connecting, connected, disconnected, error }

class LcuConnectionState {
  const LcuConnectionState({
    required this.status,
    this.session,
    this.error,
  });

  final LcuStatus status;
  final LcuSession? session;
  final Object? error;

  LcuConnectionState copyWith({
    LcuStatus? status,
    LcuSession? session,
    Object? error,
    bool clearSession = false,
    bool clearError = false,
  }) {
    return LcuConnectionState(
      status: status ?? this.status,
      session: clearSession ? null : session ?? this.session,
      error: clearError ? null : error ?? this.error,
    );
  }
}

/// Top-level LCU lifecycle owner. Watches for the lockfile, opens an HTTP +
/// WebSocket session when found, tears it down when the lockfile disappears
/// or the WS dies, and reconnects automatically.
class LcuConnector {
  LcuConnector();

  final _watcher = LockfileWatcher();
  final _stateController = StreamController<LcuConnectionState>.broadcast();
  LcuConnectionState _state = const LcuConnectionState(status: LcuStatus.idle);
  StreamSubscription? _watchSub;
  StreamSubscription? _wsStatusSub;
  Timer? _reconnectTimer;
  bool _started = false;

  Stream<LcuConnectionState> get stream => _stateController.stream;
  LcuConnectionState get state => _state;
  LcuSession? get session => _state.session;

  void start() {
    if (_started) return;
    _started = true;
    _setState(_state.copyWith(status: LcuStatus.searching));
    _watcher.start();
    _watchSub = _watcher.stream.listen(_onLockfileChanged);
  }

  Future<void> dispose() async {
    _started = false;
    _reconnectTimer?.cancel();
    await _watchSub?.cancel();
    await _wsStatusSub?.cancel();
    await _watcher.dispose();
    await _state.session?.dispose();
    await _stateController.close();
  }

  Future<void> _onLockfileChanged(Lockfile? lockfile) async {
    if (lockfile == null) {
      await _teardown(LcuStatus.searching);
      return;
    }
    final current = _state.session;
    if (current != null &&
        current.lockfile.port == lockfile.port &&
        current.lockfile.password == lockfile.password) {
      return; // Same session, nothing to do.
    }
    await _connect(lockfile);
  }

  Future<void> _connect(Lockfile lockfile) async {
    await _teardown(LcuStatus.connecting);
    final http = LcuHttp(lockfile);
    final ws = LcuWebsocket(lockfile);
    try {
      await ws.connect();
    } catch (e) {
      http.close();
      await ws.dispose();
      _setState(_state.copyWith(status: LcuStatus.error, error: e));
      _scheduleReconnect();
      return;
    }
    final session = LcuSession(lockfile: lockfile, http: http, ws: ws);
    _wsStatusSub = ws.connectionStatus.listen((connected) {
      if (!connected && _state.session == session) {
        _teardown(LcuStatus.disconnected);
        _scheduleReconnect();
      }
    });
    _setState(LcuConnectionState(status: LcuStatus.connected, session: session));
  }

  Future<void> _teardown(LcuStatus nextStatus) async {
    await _wsStatusSub?.cancel();
    _wsStatusSub = null;
    final old = _state.session;
    if (old != null) {
      await old.dispose();
    }
    _setState(_state.copyWith(
      status: nextStatus,
      clearSession: true,
      clearError: true,
    ));
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 2), () {
      final lf = _watcher.current;
      if (lf != null) _connect(lf);
    });
  }

  void _setState(LcuConnectionState next) {
    _state = next;
    _stateController.add(next);
  }
}
