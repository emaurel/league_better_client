/// Top-level state of the LCU's gameflow state machine. We render different
/// screens based on this. See `/lol-gameflow/v1/gameflow-phase`.
enum GameflowPhase {
  none,
  lobby,
  matchmaking,
  checkedIntoTournament,
  readyCheck,
  champSelect,
  gameStart,
  failedToLaunch,
  inProgress,
  reconnect,
  waitingForStats,
  preEndOfGame,
  endOfGame,
  terminatedInError,
  unknown,
}

GameflowPhase gameflowPhaseFromString(String? raw) {
  switch (raw) {
    case 'None':
      return GameflowPhase.none;
    case 'Lobby':
      return GameflowPhase.lobby;
    case 'Matchmaking':
      return GameflowPhase.matchmaking;
    case 'CheckedIntoTournament':
      return GameflowPhase.checkedIntoTournament;
    case 'ReadyCheck':
      return GameflowPhase.readyCheck;
    case 'ChampSelect':
      return GameflowPhase.champSelect;
    case 'GameStart':
      return GameflowPhase.gameStart;
    case 'FailedToLaunch':
      return GameflowPhase.failedToLaunch;
    case 'InProgress':
      return GameflowPhase.inProgress;
    case 'Reconnect':
      return GameflowPhase.reconnect;
    case 'WaitingForStats':
      return GameflowPhase.waitingForStats;
    case 'PreEndOfGame':
      return GameflowPhase.preEndOfGame;
    case 'EndOfGame':
      return GameflowPhase.endOfGame;
    case 'TerminatedInError':
      return GameflowPhase.terminatedInError;
  }
  return GameflowPhase.unknown;
}

class ReadyCheckState {
  const ReadyCheckState({
    required this.state,
    required this.playerResponse,
    required this.timerMs,
  });

  /// `Invalid`, `InProgress`, `Done`.
  final String state;

  /// `None`, `Accepted`, `Declined`.
  final String playerResponse;

  final int timerMs;

  bool get isActive => state == 'InProgress';

  factory ReadyCheckState.fromJson(Map<String, dynamic> json) {
    return ReadyCheckState(
      state: json['state'] as String? ?? '',
      playerResponse: json['playerResponse'] as String? ?? '',
      timerMs: ((json['timer'] as num?) ?? 0).toInt() * 1000,
    );
  }

  Map<String, dynamic> toJson() => {
        'state': state,
        'playerResponse': playerResponse,
        'timer': timerMs ~/ 1000,
      };
}
