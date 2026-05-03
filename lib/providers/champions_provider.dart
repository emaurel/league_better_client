import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/champion.dart';
import 'lcu_providers.dart';

/// All playable champions, indexed by id. Tries the static asset endpoint
/// first; falls back to the dynamic LCU endpoint if that fails (some clients
/// don't expose the asset path until login completes).
final championsProvider = FutureProvider<Map<int, Champion>>((ref) async {
  final session = ref.watch(lcuSessionProvider);
  if (session == null) return const {};

  Map<int, Champion> parseList(dynamic raw) {
    if (raw is! List) return const {};
    final out = <int, Champion>{};
    for (final c in raw) {
      if (c is! Map<String, dynamic>) continue;
      final champ = Champion.fromJson(c);
      if (champ.id <= 0) continue;
      out[champ.id] = champ;
    }
    return out;
  }

  // Primary: static game-data asset.
  try {
    final raw = await session.http.get(
      '/lol-game-data/assets/v1/champion-summary.json',
    );
    final parsed = parseList(raw);
    if (parsed.isNotEmpty) return parsed;
  } catch (_) {/* fall through */}

  // Fallback: minimal champions list — works once the user is logged in.
  try {
    final raw = await session.http.get('/lol-champions/v1/owned-champions-minimal');
    final parsed = parseList(raw);
    if (parsed.isNotEmpty) return parsed;
  } catch (_) {/* fall through */}

  // Last resort: champ-select's own grid endpoint (only works inside champ select).
  try {
    final raw = await session.http.get(
      '/lol-champ-select/v1/all-grid-champions',
    );
    final parsed = parseList(raw);
    if (parsed.isNotEmpty) return parsed;
  } catch (_) {/* fall through */}

  return const {};
});
