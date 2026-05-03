import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ranked_stats.dart';
import '../models/summoner.dart';
import '_resource.dart';
import 'lcu_providers.dart';

final currentSummonerProvider = StreamProvider<Summoner?>((ref) async* {
  final session = ref.watch(lcuSessionProvider);
  if (session == null) {
    yield null;
    return;
  }
  yield* watchLcuResource<Summoner>(
    session,
    path: '/lol-summoner/v1/current-summoner',
    parse: (raw) => Summoner.fromJson(raw as Map<String, dynamic>),
  );
});

final rankedStatsProvider = FutureProvider<RankedStats?>((ref) async {
  final session = ref.watch(lcuSessionProvider);
  if (session == null) return null;
  try {
    final raw = await session.http.get('/lol-ranked/v1/current-ranked-stats');
    if (raw is! Map<String, dynamic>) return null;
    return RankedStats.fromJson(raw);
  } catch (_) {
    return null;
  }
});
