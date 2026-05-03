import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/champion.dart';
import 'lcu_providers.dart';

/// All playable champions, indexed by id. Sourced once per session from the
/// game-data assets endpoint exposed by the LCU.
final championsProvider = FutureProvider<Map<int, Champion>>((ref) async {
  final session = ref.watch(lcuSessionProvider);
  if (session == null) return const {};
  try {
    final raw = await session.http.get(
      '/lol-game-data/assets/v1/champion-summary.json',
    );
    if (raw is! List) return const {};
    final out = <int, Champion>{};
    for (final c in raw) {
      if (c is! Map<String, dynamic>) continue;
      final champ = Champion.fromJson(c);
      if (champ.id <= 0) continue; // -1 entry is "None"
      out[champ.id] = champ;
    }
    return out;
  } catch (_) {
    return const {};
  }
});
