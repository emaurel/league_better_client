import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/friend.dart';
import 'lcu_providers.dart';

/// Friends list. Initial fetch then patch the in-memory list as
/// `/lol-chat/v1/friends/<id>` events arrive.
final friendsProvider = StreamProvider<List<Friend>>((ref) async* {
  final session = ref.watch(lcuSessionProvider);
  if (session == null) {
    yield const [];
    return;
  }

  final byId = <String, Friend>{};
  try {
    final raw = await session.http.get('/lol-chat/v1/friends');
    if (raw is List) {
      for (final f in raw) {
        if (f is Map<String, dynamic>) {
          final friend = Friend.fromJson(f);
          byId[friend.id] = friend;
        }
      }
    }
  } catch (_) {
    // Empty list is the right initial state if fetch fails.
  }
  yield _sorted(byId.values);

  await for (final ev in session.ws.events) {
    if (!ev.matches('/lol-chat/v1/friends')) continue;

    if (ev.eventType == 'Delete') {
      // The URI looks like /lol-chat/v1/friends/<id>; the id is the trailing
      // segment. If it's the parent path, the whole list went away.
      if (ev.uri == '/lol-chat/v1/friends') {
        byId.clear();
      } else {
        final id = ev.uri.split('/').last;
        byId.remove(id);
      }
      yield _sorted(byId.values);
      continue;
    }

    final data = ev.data;
    if (data is Map<String, dynamic>) {
      final friend = Friend.fromJson(data);
      byId[friend.id] = friend;
      yield _sorted(byId.values);
    } else if (data is List) {
      byId.clear();
      for (final f in data) {
        if (f is Map<String, dynamic>) {
          final friend = Friend.fromJson(f);
          byId[friend.id] = friend;
        }
      }
      yield _sorted(byId.values);
    }
  }
});

List<Friend> _sorted(Iterable<Friend> friends) {
  int rank(Friend f) {
    if (f.lol?.inGame == true) return 0;
    if (f.lol?.inChampSelect == true) return 1;
    if (f.lol?.inLobby == true) return 2;
    if (f.isOnline) return 3;
    return 4;
  }

  final list = friends.toList()
    ..sort((a, b) {
      final ra = rank(a);
      final rb = rank(b);
      if (ra != rb) return ra.compareTo(rb);
      return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    });
  return List.unmodifiable(list);
}
