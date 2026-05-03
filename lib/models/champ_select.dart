class ChampSelectAction {
  const ChampSelectAction({
    required this.id,
    required this.actorCellId,
    required this.championId,
    required this.completed,
    required this.type,
    required this.isAllyAction,
  });

  final int id;
  final int actorCellId;
  final int championId;
  final bool completed;

  /// `pick`, `ban`, or `ten_bans_reveal`.
  final String type;
  final bool isAllyAction;

  factory ChampSelectAction.fromJson(Map<String, dynamic> json) {
    return ChampSelectAction(
      id: (json['id'] as num?)?.toInt() ?? 0,
      actorCellId: (json['actorCellId'] as num?)?.toInt() ?? -1,
      championId: (json['championId'] as num?)?.toInt() ?? 0,
      completed: json['completed'] as bool? ?? false,
      type: json['type'] as String? ?? '',
      isAllyAction: json['isAllyAction'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'actorCellId': actorCellId,
        'championId': championId,
        'completed': completed,
        'type': type,
        'isAllyAction': isAllyAction,
      };
}

class ChampSelectPlayer {
  const ChampSelectPlayer({
    required this.cellId,
    required this.summonerId,
    required this.championId,
    required this.championPickIntent,
    required this.assignedPosition,
    required this.spell1Id,
    required this.spell2Id,
  });

  final int cellId;
  final int summonerId;
  final int championId;
  final int championPickIntent;
  final String assignedPosition;
  final int spell1Id;
  final int spell2Id;

  factory ChampSelectPlayer.fromJson(Map<String, dynamic> json) {
    return ChampSelectPlayer(
      cellId: (json['cellId'] as num?)?.toInt() ?? 0,
      summonerId: (json['summonerId'] as num?)?.toInt() ?? 0,
      championId: (json['championId'] as num?)?.toInt() ?? 0,
      championPickIntent: (json['championPickIntent'] as num?)?.toInt() ?? 0,
      assignedPosition: json['assignedPosition'] as String? ?? '',
      spell1Id: (json['spell1Id'] as num?)?.toInt() ?? 0,
      spell2Id: (json['spell2Id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'cellId': cellId,
        'summonerId': summonerId,
        'championId': championId,
        'championPickIntent': championPickIntent,
        'assignedPosition': assignedPosition,
        'spell1Id': spell1Id,
        'spell2Id': spell2Id,
      };
}

class ChampSelectTimer {
  const ChampSelectTimer({
    required this.phase,
    required this.adjustedTimeLeftInPhaseMs,
    required this.totalTimeInPhaseMs,
    required this.isInfinite,
  });

  final String phase;
  final int adjustedTimeLeftInPhaseMs;
  final int totalTimeInPhaseMs;
  final bool isInfinite;

  factory ChampSelectTimer.fromJson(Map<String, dynamic> json) {
    return ChampSelectTimer(
      phase: json['phase'] as String? ?? '',
      adjustedTimeLeftInPhaseMs:
          (json['adjustedTimeLeftInPhase'] as num?)?.toInt() ?? 0,
      totalTimeInPhaseMs: (json['totalTimeInPhase'] as num?)?.toInt() ?? 0,
      isInfinite: json['isInfinite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'phase': phase,
        'adjustedTimeLeftInPhase': adjustedTimeLeftInPhaseMs,
        'totalTimeInPhase': totalTimeInPhaseMs,
        'isInfinite': isInfinite,
      };
}

class ChampSelectSession {
  const ChampSelectSession({
    required this.localPlayerCellId,
    required this.timer,
    required this.actions,
    required this.bans,
    required this.myTeam,
    required this.theirTeam,
  });

  final int localPlayerCellId;
  final ChampSelectTimer timer;

  /// Actions are a list of "phases", each phase is a list of actions.
  /// We flatten on read for convenience.
  final List<ChampSelectAction> actions;
  final List<ChampSelectAction> bans;
  final List<ChampSelectPlayer> myTeam;
  final List<ChampSelectPlayer> theirTeam;

  ChampSelectPlayer? get localPlayer {
    for (final p in myTeam) {
      if (p.cellId == localPlayerCellId) return p;
    }
    return null;
  }

  factory ChampSelectSession.fromJson(Map<String, dynamic> json) {
    final phases = (json['actions'] as List?) ?? const [];
    final actions = <ChampSelectAction>[];
    for (final phase in phases) {
      if (phase is List) {
        for (final a in phase) {
          if (a is Map<String, dynamic>) {
            actions.add(ChampSelectAction.fromJson(a));
          }
        }
      }
    }

    final bansRaw = json['bans'] as Map<String, dynamic>?;
    final bans = <ChampSelectAction>[];
    if (bansRaw != null) {
      for (final list in [bansRaw['myTeamBans'], bansRaw['theirTeamBans']]) {
        if (list is List) {
          for (final b in list) {
            if (b is num) {
              bans.add(ChampSelectAction(
                id: 0,
                actorCellId: -1,
                championId: b.toInt(),
                completed: true,
                type: 'ban',
                isAllyAction: list == bansRaw['myTeamBans'],
              ));
            }
          }
        }
      }
    }

    return ChampSelectSession(
      localPlayerCellId: (json['localPlayerCellId'] as num?)?.toInt() ?? 0,
      timer: ChampSelectTimer.fromJson(
        json['timer'] as Map<String, dynamic>? ?? const {},
      ),
      actions: actions,
      bans: bans,
      myTeam: (json['myTeam'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(ChampSelectPlayer.fromJson)
              .toList() ??
          const [],
      theirTeam: (json['theirTeam'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(ChampSelectPlayer.fromJson)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'localPlayerCellId': localPlayerCellId,
        'timer': timer.toJson(),
        'actions': actions.map((a) => a.toJson()).toList(),
        'bans': bans.map((b) => b.toJson()).toList(),
        'myTeam': myTeam.map((p) => p.toJson()).toList(),
        'theirTeam': theirTeam.map((p) => p.toJson()).toList(),
      };
}
