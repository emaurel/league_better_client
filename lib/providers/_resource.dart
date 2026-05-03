import 'dart:async';

import '../lcu/lcu_session.dart';

/// Fetch [path] once over HTTP, then keep emitting updates whenever an
/// LCU websocket event lands under that path.
///
/// Emits `null` when:
///   - the initial GET fails (e.g. 404 because the resource isn't present
///     yet — like champ-select before queue pops),
///   - a websocket `Delete` event is received,
///   - or the event's `data` field is null.
Stream<T?> watchLcuResource<T>(
  LcuSession session, {
  required String path,
  required T Function(dynamic raw) parse,
}) async* {
  try {
    final initial = await session.http.get(path);
    yield initial == null ? null : parse(initial);
  } catch (_) {
    yield null;
  }
  await for (final ev in session.ws.events) {
    if (!ev.matches(path)) continue;
    if (ev.eventType == 'Delete' || ev.data == null) {
      yield null;
    } else {
      try {
        yield parse(ev.data);
      } catch (_) {
        // Skip malformed events rather than tearing down the stream.
      }
    }
  }
}
