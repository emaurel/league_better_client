import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as p;
import 'package:win32/win32.dart';

import 'lockfile.dart';

/// Spawns `LeagueClient.exe` and keeps any windows belonging to its process
/// tree hidden (via ShowWindow(SW_HIDE)) for the lifetime of this object.
///
/// Windows appear at different points in the LCU's startup (patcher, splash,
/// main UI), so the hider runs on a polling loop rather than once.
class LeagueLauncher {
  LeagueLauncher();

  Timer? _hideTimer;
  final _hiddenHandles = <int>{};

  bool get isWindows => Platform.isWindows;

  /// Locate `LeagueClient.exe` on disk. Returns null if not found.
  String? findExecutable() {
    if (LcuPaths.leagueClientExeOverride != null) {
      final f = File(LcuPaths.leagueClientExeOverride!);
      if (f.existsSync()) return f.path;
    }
    for (final root in LcuPaths.installRoots()) {
      final exe = p.join(root, 'LeagueClient.exe');
      if (File(exe).existsSync()) return exe;
    }
    return null;
  }

  /// Returns true if any LeagueClient.exe is already running.
  bool isAlreadyRunning() {
    if (!isWindows) return false;
    return _enumerateLeagueWindows().isNotEmpty;
  }

  /// Spawns LeagueClient.exe (if not already running) and starts the hider.
  /// No-op on non-Windows platforms.
  Future<bool> launchAndHide() async {
    if (!isWindows) return false;
    if (!isAlreadyRunning()) {
      final exe = findExecutable();
      if (exe == null) return false;
      await Process.start(
        exe,
        const [],
        workingDirectory: p.dirname(exe),
        mode: ProcessStartMode.detached,
      );
    }
    _startHider();
    return true;
  }

  void _startHider() {
    _hideTimer?.cancel();
    _hideTimer = Timer.periodic(const Duration(milliseconds: 750), (_) {
      _hideAllLeagueWindows();
    });
    _hideAllLeagueWindows();
  }

  Future<void> dispose() async {
    _hideTimer?.cancel();
    _hideTimer = null;
  }

  void _hideAllLeagueWindows() {
    if (!isWindows) return;
    for (final hwnd in _enumerateLeagueWindows()) {
      if (_hiddenHandles.contains(hwnd)) continue;
      ShowWindow(hwnd, SW_HIDE);
      _hiddenHandles.add(hwnd);
    }
  }

  /// Enumerate top-level HWNDs whose owning process is a LeagueClient binary.
  List<int> _enumerateLeagueWindows() {
    if (!isWindows) return const [];
    final results = <int>[];
    final cb = Pointer.fromFunction<WNDENUMPROC>(_enumProc, 0);
    _enumResults = results;
    EnumWindows(cb, 0);
    _enumResults = null;
    return results;
  }
}

// EnumWindows can't capture closures, so the callback writes into a
// well-known static slot the launcher swaps in/out around each call.
List<int>? _enumResults;

int _enumProc(int hwnd, int lParam) {
  final list = _enumResults;
  if (list == null) return TRUE;
  if (_isLeagueClientWindow(hwnd)) {
    list.add(hwnd);
  }
  return TRUE;
}

bool _isLeagueClientWindow(int hwnd) {
  final pidPtr = calloc<Uint32>();
  try {
    GetWindowThreadProcessId(hwnd, pidPtr);
    final pid = pidPtr.value;
    if (pid == 0) return false;
    final hProcess = OpenProcess(
      PROCESS_QUERY_LIMITED_INFORMATION,
      FALSE,
      pid,
    );
    if (hProcess == 0) return false;
    try {
      final pathPtr = wsalloc(MAX_PATH);
      final sizePtr = calloc<Uint32>()..value = MAX_PATH;
      try {
        final ok = QueryFullProcessImageName(hProcess, 0, pathPtr, sizePtr);
        if (ok == 0) return false;
        final path = pathPtr.toDartString().toLowerCase();
        return path.endsWith(r'\leagueclient.exe') ||
            path.endsWith(r'\leagueclientux.exe') ||
            path.endsWith(r'\leagueclientuxrender.exe');
      } finally {
        free(pathPtr);
        calloc.free(sizePtr);
      }
    } finally {
      CloseHandle(hProcess);
    }
  } finally {
    calloc.free(pidPtr);
  }
}
