import 'dart:io';

import 'package:path/path.dart' as p;

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
  /// First match wins; users can override via [LcuPaths.override].
  static List<String> candidatePaths() {
    final candidates = <String>[];

    if (LcuPaths.override != null) {
      candidates.add(LcuPaths.override!);
    }

    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData != null) {
      candidates.add(p.join(localAppData, 'Riot Games', 'League of Legends', 'lockfile'));
    }

    for (final root in const [
      r'C:\Riot Games\League of Legends',
      r'D:\Riot Games\League of Legends',
      r'E:\Riot Games\League of Legends',
      r'C:\Program Files\Riot Games\League of Legends',
      r'C:\Program Files (x86)\Riot Games\League of Legends',
    ]) {
      candidates.add(p.join(root, 'lockfile'));
    }

    return candidates;
  }

  @override
  String toString() => 'Lockfile(pid=$pid port=$port protocol=$protocol)';
}

/// Mutable, app-wide settings for where to find the League install.
/// Set [override] (e.g. from a settings screen) to bypass auto-detection.
class LcuPaths {
  LcuPaths._();
  static String? override;
  static String? leagueClientExeOverride;

  /// League install root candidates (used to locate LeagueClient.exe).
  static List<String> installRoots() {
    final roots = <String>[];
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
    ]);
    return roots;
  }
}
