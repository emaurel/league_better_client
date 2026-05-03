import 'package:flutter_test/flutter_test.dart';
import 'package:league_better_client/lcu/lockfile.dart';
import 'package:league_better_client/models/champ_select.dart';
import 'package:league_better_client/models/summoner.dart';

void main() {
  test('Lockfile.tryParse parses the LCU lockfile format', () {
    final lf = Lockfile.tryParse('LeagueClient:1234:5678:abc-def:https');
    expect(lf, isNotNull);
    expect(lf!.process, 'LeagueClient');
    expect(lf.pid, 1234);
    expect(lf.port, 5678);
    expect(lf.password, 'abc-def');
    expect(lf.protocol, 'https');
    expect(lf.baseUrl, 'https://127.0.0.1:5678');
    expect(lf.wsUrl, 'wss://127.0.0.1:5678');
  });

  test('Lockfile.tryParse rejects malformed input', () {
    expect(Lockfile.tryParse(''), isNull);
    expect(Lockfile.tryParse('garbage'), isNull);
    expect(Lockfile.tryParse('LeagueClient:notapid:5678:p:https'), isNull);
  });

  test('Summoner.fromJson tolerates partial JSON', () {
    final s = Summoner.fromJson({
      'displayName': 'Foo',
      'summonerLevel': 42,
    });
    expect(s.displayName, 'Foo');
    expect(s.summonerLevel, 42);
    expect(s.profileIconId, 0);
  });

  test('ChampSelectSession flattens phased actions', () {
    final raw = {
      'localPlayerCellId': 0,
      'timer': {'phase': 'BAN_PICK', 'adjustedTimeLeftInPhase': 30000},
      'actions': [
        [
          {'id': 1, 'actorCellId': 0, 'championId': 0, 'type': 'ban'},
        ],
        [
          {'id': 2, 'actorCellId': 0, 'championId': 103, 'type': 'pick'},
        ],
      ],
      'myTeam': [
        {'cellId': 0, 'summonerId': 1, 'championId': 103},
      ],
      'theirTeam': [],
    };
    final s = ChampSelectSession.fromJson(raw);
    expect(s.actions.length, 2);
    expect(s.actions.first.type, 'ban');
    expect(s.localPlayer?.cellId, 0);
  });
}
