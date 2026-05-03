import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lcu/lcu_session.dart';
import 'lcu_providers.dart';

/// User-initiated commands sent to the LCU. Each method is a no-op if there
/// is no active session.
class LcuActions {
  LcuActions(this._session);

  final LcuSession? _session;

  Future<void> createLobby(int queueId) async {
    final s = _session;
    if (s == null) return;
    await s.http.post('/lol-lobby/v2/lobby', {'queueId': queueId});
  }

  Future<void> leaveLobby() async {
    final s = _session;
    if (s == null) return;
    await s.http.delete('/lol-lobby/v2/lobby');
  }

  Future<void> startMatchmaking() async {
    final s = _session;
    if (s == null) return;
    await s.http.post('/lol-lobby/v2/lobby/matchmaking/search');
  }

  Future<void> stopMatchmaking() async {
    final s = _session;
    if (s == null) return;
    await s.http.delete('/lol-lobby/v2/lobby/matchmaking/search');
  }

  Future<void> acceptReadyCheck() async {
    final s = _session;
    if (s == null) return;
    await s.http.post('/lol-matchmaking/v1/ready-check/accept');
  }

  Future<void> declineReadyCheck() async {
    final s = _session;
    if (s == null) return;
    await s.http.post('/lol-matchmaking/v1/ready-check/decline');
  }

  Future<void> hoverChampion(int actionId, int championId) async {
    final s = _session;
    if (s == null) return;
    await s.http.patch(
      '/lol-champ-select/v1/session/actions/$actionId',
      {'championId': championId, 'completed': false},
    );
  }

  Future<void> lockChampion(int actionId, int championId) async {
    final s = _session;
    if (s == null) return;
    await s.http.patch(
      '/lol-champ-select/v1/session/actions/$actionId',
      {'championId': championId, 'completed': true},
    );
  }

  Future<void> banChampion(int actionId, int championId) async {
    return lockChampion(actionId, championId);
  }

  Future<void> dodgeChampSelect() async {
    final s = _session;
    if (s == null) return;
    await s.http.post('/lol-login/v1/session/invoke?destination=lcdsServiceProxy'
        '&method=call&args=["", "teambuilder-draft", "quitV2", ""]');
  }

  Future<void> setLobbyPositionPreferences(String first, String second) async {
    final s = _session;
    if (s == null) return;
    await s.http.put('/lol-lobby/v2/lobby/members/localMember/position-preferences', {
      'firstPreference': first,
      'secondPreference': second,
    });
  }
}

final lcuActionsProvider = Provider<LcuActions>((ref) {
  final session = ref.watch(lcuSessionProvider);
  return LcuActions(session);
});
