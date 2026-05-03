import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/gameflow.dart';
import '_resource.dart';
import 'lcu_providers.dart';

final gameflowPhaseProvider = StreamProvider<GameflowPhase>((ref) async* {
  final session = ref.watch(lcuSessionProvider);
  if (session == null) {
    yield GameflowPhase.none;
    return;
  }
  yield* watchLcuResource<GameflowPhase>(
    session,
    path: '/lol-gameflow/v1/gameflow-phase',
    parse: (raw) => gameflowPhaseFromString(raw is String ? raw : null),
  ).map((p) => p ?? GameflowPhase.none);
});

final readyCheckProvider = StreamProvider<ReadyCheckState?>((ref) async* {
  final session = ref.watch(lcuSessionProvider);
  if (session == null) {
    yield null;
    return;
  }
  yield* watchLcuResource<ReadyCheckState>(
    session,
    path: '/lol-matchmaking/v1/ready-check',
    parse: (raw) => ReadyCheckState.fromJson(raw as Map<String, dynamic>),
  );
});
