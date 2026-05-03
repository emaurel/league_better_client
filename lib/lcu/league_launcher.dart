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

  /// Locate the best executable to launch. Prefers `RiotClientServices.exe`
  /// (the top-level Riot launcher used by desktop shortcuts) over
  /// `LeagueClient.exe` directly, since the LeagueClient binary can be
  /// access-locked by Vanguard and refuses CreateProcess in that state.
  String? findExecutable() {
    for (final candidate in _riotClientCandidates()) {
      if (File(candidate).existsSync()) return candidate;
    }
    for (final candidate in candidateExePaths()) {
      if (File(candidate).existsSync()) return candidate;
    }
    return null;
  }

  /// All paths the launcher will probe, in order. Useful for diagnostics.
  List<String> candidateExePaths() {
    final out = <String>[];
    if (LcuPaths.leagueClientExeOverride != null) {
      out.add(LcuPaths.leagueClientExeOverride!);
    }
    for (final root in LcuPaths.installRoots()) {
      out.add(p.join(root, 'LeagueClient.exe'));
    }
    out.addAll(_riotClientCandidates());
    return out;
  }

  List<String> _riotClientCandidates() {
    return const [
      r'C:\Riot Games\Riot Client\RiotClientServices.exe',
      r'D:\Riot Games\Riot Client\RiotClientServices.exe',
      r'E:\Riot Games\Riot Client\RiotClientServices.exe',
      r'C:\Program Files\Riot Games\Riot Client\RiotClientServices.exe',
      r'C:\Program Files (x86)\Riot Games\Riot Client\RiotClientServices.exe',
    ];
  }

  /// Returns true if any LeagueClient.exe is already running. Uses the
  /// lockfile (most reliable signal) and falls back to window enumeration.
  bool isAlreadyRunning() {
    if (!isWindows) return false;
    for (final path in Lockfile.candidatePaths()) {
      if (File(path).existsSync()) return true;
    }
    return _enumerateLeagueWindows().isNotEmpty;
  }

  /// Spawns the League/Riot client (if not already running) and starts the
  /// hider. No-op on non-Windows platforms.
  ///
  /// Spawns through `cmd /c start` so Windows resolves the launch the same
  /// way it would for a desktop shortcut (ShellExecute path) — direct
  /// CreateProcess on RiotClientServices/LeagueClient often returns
  /// ERROR_ACCESS_DENIED because of Vanguard ACLs.
  Future<bool> launchAndHide() async {
    if (!isWindows) return false;
    if (!isAlreadyRunning()) {
      final exe = findExecutable();
      if (exe == null) return false;
      final isRiotClient = exe.toLowerCase().endsWith('riotclientservices.exe');
      final args = <String>[
        '/c',
        'start',
        '""',
        '/D',
        p.dirname(exe),
        exe,
        if (isRiotClient) ...const [
          '--launch-product=league_of_legends',
          '--launch-patchline=live',
        ],
      ];
      await Process.start(
        'cmd.exe',
        args,
        mode: ProcessStartMode.detached,
        runInShell: false,
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
