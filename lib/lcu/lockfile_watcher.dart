import 'dart:async';
import 'dart:io';

import 'lockfile.dart';

/// Polls the candidate lockfile locations and emits the parsed [Lockfile]
/// when one appears, and `null` when it disappears.
///
/// Filesystem watchers are unreliable on Windows for files mutated by other
/// processes, so we poll. The cadence is fast enough (1s) to feel instant.
class LockfileWatcher {
  LockfileWatcher({this.pollInterval = const Duration(seconds: 1)});

  final Duration pollInterval;
  final _controller = StreamController<Lockfile?>.broadcast();
  Timer? _timer;
  Lockfile? _last;

  Stream<Lockfile?> get stream => _controller.stream;
  Lockfile? get current => _last;

  void start() {
    if (_timer != null) return;
    _tick();
    _timer = Timer.periodic(pollInterval, (_) => _tick());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> dispose() async {
    stop();
    await _controller.close();
  }

  Future<void> _tick() async {
    final found = await _findLockfile();
    final changed = !_lockfilesEqual(found, _last);
    if (changed) {
      _last = found;
      _controller.add(found);
    }
  }

  Future<Lockfile?> _findLockfile() async {
    for (final path in Lockfile.candidatePaths()) {
      final file = File(path);
      if (!await file.exists()) continue;
      try {
        final contents = await file.readAsString();
        final parsed = Lockfile.tryParse(contents);
        if (parsed != null) return parsed;
      } on FileSystemException {
        // File may be momentarily locked while LCU writes it; retry next tick.
      }
    }
    return null;
  }

  bool _lockfilesEqual(Lockfile? a, Lockfile? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return a.pid == b.pid && a.port == b.port && a.password == b.password;
  }
}
