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

  /// Create a 5v5 Summoner's Rift custom lobby with Tournament Draft rules
  /// (full pick/ban). Useful for testing champ select without queuing.
  ///
  /// The LCU's INVALID_LOBBY error is opaque — known requirements:
  ///   - `configuration.mutators.id` must be a real game-type config id
  ///     (6 = Tournament Draft, the format with full bans).
  ///   - `gameServerRegion` must be present (empty string OK).
  ///   - `lobbyPassword` must be a string, not null.
  Future<void> createCustomLobby({
    String name = 'LBC Test',
    int mapId = 11,
    String gameMode = 'CLASSIC',
    int teamSize = 5,
    int mutatorId = 1,
  }) async {
    final s = _session;
    if (s == null) return;
    await s.http.post('/lol-lobby/v2/lobby', {
      'customGameLobby': {
        'configuration': {
          'gameMode': gameMode,
          'gameMutator': '',
          'gameServerRegion': '',
          'mapId': mapId,
          'mutators': {'id': mutatorId},
          'spectatorPolicy': 'AllAllowed',
          'teamSize': teamSize,
        },
        'lobbyName': name,
        'lobbyPassword': '',
      },
      'isCustom': true,
    });
  }

  /// Returns the bot champion roster the LCU offers for the current custom
  /// lobby's map. Each entry: `{ id, name, botDifficulties: [...] }`.
  Future<List<Map<String, dynamic>>> availableBots() async {
    final s = _session;
    if (s == null) return const [];
    try {
      final raw = await s.http.get('/lol-lobby/v2/lobby/custom/available-bots');
      if (raw is List) {
        return raw.whereType<Map<String, dynamic>>().toList();
      }
    } catch (_) {/* ignore */}
    return const [];
  }

  /// Add one bot to the given team. `teamId` must be `"100"` (allies/blue)
  /// or `"200"` (enemies/red). Picks the first available champion at the
  /// requested difficulty (clamped to what the LCU advertises).
  Future<void> addBot({
    required String teamId,
    String difficulty = 'MEDIUM',
  }) async {
    final s = _session;
    if (s == null) return;
    final bots = await availableBots();
    if (bots.isEmpty) return;
    final pick = bots.first;
    final difficulties = (pick['botDifficulties'] as List?)
            ?.whereType<String>()
            .toList() ??
        const ['MEDIUM'];
    final chosen = difficulties.contains(difficulty)
        ? difficulty
        : difficulties.first;
    await s.http.post('/lol-lobby/v1/lobby/custom/bots', {
      'championId': pick['id'],
      'botDifficulty': chosen,
      'teamId': teamId,
    });
  }

  /// Add bots to both teams until each side reaches [teamSize]. Counts the
  /// human members already on each side.
  Future<void> fillCustomLobbyWithBots({int teamSize = 5}) async {
    final s = _session;
    if (s == null) return;
    final lobbyRaw = await s.http.get('/lol-lobby/v2/lobby');
    if (lobbyRaw is! Map<String, dynamic>) return;
    final teamOne = (lobbyRaw['teamOne'] as List?)?.length ?? 0;
    final teamTwo = (lobbyRaw['teamTwo'] as List?)?.length ?? 0;

    final allyMissing = (teamSize - teamOne).clamp(0, teamSize);
    final enemyMissing = (teamSize - teamTwo).clamp(0, teamSize);

    for (var i = 0; i < allyMissing; i++) {
      await addBot(teamId: '100');
    }
    for (var i = 0; i < enemyMissing; i++) {
      await addBot(teamId: '200');
    }
  }

  /// Move from a custom lobby into champion select.
  Future<void> startCustomChampSelect() async {
    final s = _session;
    if (s == null) return;
    await s.http.post('/lol-lobby/v1/lobby/custom/start-champ-select');
  }
}

final lcuActionsProvider = Provider<LcuActions>((ref) {
  final session = ref.watch(lcuSessionProvider);
  return LcuActions(session);
});
