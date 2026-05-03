import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/lobby.dart';
import '_resource.dart';
import 'lcu_providers.dart';

final lobbyProvider = StreamProvider<Lobby?>((ref) async* {
  final session = ref.watch(lcuSessionProvider);
  if (session == null) {
    yield null;
    return;
  }
  yield* watchLcuResource<Lobby>(
    session,
    path: '/lol-lobby/v2/lobby',
    parse: (raw) => Lobby.fromJson(raw as Map<String, dynamic>),
  );
});
