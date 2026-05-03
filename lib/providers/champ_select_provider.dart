import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/champ_select.dart';
import '_resource.dart';
import 'lcu_providers.dart';

final champSelectProvider = StreamProvider<ChampSelectSession?>((ref) async* {
  final session = ref.watch(lcuSessionProvider);
  if (session == null) {
    yield null;
    return;
  }
  yield* watchLcuResource<ChampSelectSession>(
    session,
    path: '/lol-champ-select/v1/session',
    parse: (raw) => ChampSelectSession.fromJson(raw as Map<String, dynamic>),
  );
});
