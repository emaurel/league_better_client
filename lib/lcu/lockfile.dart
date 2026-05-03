import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class Lockfile {
  final String process;
  final int pid;
  final int port;
  final String password;
  final String protocol;

  const Lockfile({
    required this.process,
    required this.pid,
    required this.port,
    required this.password,
    required this.protocol,
  });

  String get baseUrl => '$protocol://127.0.0.1:$port';
  String get wsUrl => 'wss://127.0.0.1:$port';
  String get basicAuth => 'riot:$password';

  static Lockfile? tryParse(String contents) {
    final parts = contents.trim().split(':');
    if (parts.length < 5) return null;
    final pid = int.tryParse(parts[1]);
    final port = int.tryParse(parts[2]);
    if (pid == null || port == null) return null;
    return Lockfile(
      process: parts[0],
      pid: pid,
      port: port,
      password: parts[3],
      protocol: parts[4],
    );
  }

  /// Candidate filesystem locations for the LCU lockfile on Windows.
  /// First match wins; users can override via [LcuPaths.lockfileOverride].
  static List<String> candidatePaths() {
    final candidates = <String>[];

    if (LcuPaths.lockfileOverride != null) {
      candidates.add(LcuPaths.lockfileOverride!);
    }

    for (final root in LcuPaths.installRoots()) {
      candidates.add(p.join(root, 'lockfile'));
    }

    return candidates;
  }

  @override
  String toString() => 'Lockfile(pid=$pid port=$port protocol=$protocol)';
}

/// Mutable, app-wide settings for where to find the League install.
/// Overrides persist across runs via SharedPreferences.
class LcuPaths {
  LcuPaths._();

  static String? _lockfileOverride;
  static String? _exeOverride;

  static const _prefLockfile = 'lcu_lockfile_override';
  static const _prefExe = 'lcu_exe_override';

  static String? get lockfileOverride => _lockfileOverride;
  static String? get leagueClientExeOverride => _exeOverride;

  /// Load persisted overrides at startup.
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _lockfileOverride = prefs.getString(_prefLockfile);
    _exeOverride = prefs.getString(_prefExe);
  }

  static Future<void> setLeagueClientExe(String? path) async {
    _exeOverride = (path == null || path.isEmpty) ? null : path;
    final prefs = await SharedPreferences.getInstance();
    if (_exeOverride == null) {
      await prefs.remove(_prefExe);
    } else {
      await prefs.setString(_prefExe, _exeOverride!);
    }
    // Lockfile lives next to the exe.
    if (_exeOverride != null) {
      _lockfileOverride = p.join(p.dirname(_exeOverride!), 'lockfile');
      await prefs.setString(_prefLockfile, _lockfileOverride!);
    }
  }

  /// League install root candidates (used to locate LeagueClient.exe and the
  /// lockfile that lives next to it).
  static List<String> installRoots() {
    final roots = <String>[];

    // Override exe → its directory is the canonical root.
    if (_exeOverride != null) {
      roots.add(p.dirname(_exeOverride!));
    }

    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData != null) {
      roots.add(p.join(localAppData, 'Riot Games', 'League of Legends'));
    }
    roots.addAll(const [
      r'C:\Riot Games\League of Legends',
      r'D:\Riot Games\League of Legends',
      r'E:\Riot Games\League of Legends',
      r'C:\Program Files\Riot Games\League of Legends',
      r'C:\Program Files (x86)\Riot Games\League of Legends',
      r'D:\Program Files\Riot Games\League of Legends',
      r'D:\Program Files (x86)\Riot Games\League of Legends',
      r'C:\Games\Riot Games\League of Legends',
      r'D:\Games\Riot Games\League of Legends',
    ]);
    return roots;
  }
}
