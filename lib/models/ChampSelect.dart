import 'package:league_better_client/models/MucJwtDto.dart';

class ChampSelect {
  final List<List<Action>> actions;
  final bool allowBattleBoost;
  final bool allowDuplicatePicks;
  final bool allowLockedEvents;
  final bool allowRerolling;
  final bool allowSkinSelection;
  final bool allowSubsetChampionPicks;
  final Bans bans;
  final List<dynamic> benchChampions;
  final bool benchEnabled;
  final int boostableSkinCount;
  final ChatDetails chatDetails;
  final int counter;
  final int gameId;
  final bool hasSimultaneousBans;
  final bool hasSimultaneousPicks;
  final String id;
  final bool isCustomGame;
  final bool isLegacyChampSelect;
  final bool isSpectating;
  final int localPlayerCellId;
  final int lockedEventIndex;
  final List<Player> myTeam;
  final List<dynamic> pickOrderSwaps;
  final List<dynamic> positionSwaps;
  final int rerollsRemaining;
  final bool showQuitButton;
  final bool skipChampionSelect;
  final List<dynamic> theirTeam;
  final Timer timer;
  final List<dynamic> trades;

  ChampSelect({
    required this.actions,
    required this.allowBattleBoost,
    required this.allowDuplicatePicks,
    required this.allowLockedEvents,
    required this.allowRerolling,
    required this.allowSkinSelection,
    required this.allowSubsetChampionPicks,
    required this.bans,
    required this.benchChampions,
    required this.benchEnabled,
    required this.boostableSkinCount,
    required this.chatDetails,
    required this.counter,
    required this.gameId,
    required this.hasSimultaneousBans,
    required this.hasSimultaneousPicks,
    required this.id,
    required this.isCustomGame,
    required this.isLegacyChampSelect,
    required this.isSpectating,
    required this.localPlayerCellId,
    required this.lockedEventIndex,
    required this.myTeam,
    required this.pickOrderSwaps,
    required this.positionSwaps,
    required this.rerollsRemaining,
    required this.showQuitButton,
    required this.skipChampionSelect,
    required this.theirTeam,
    required this.timer,
    required this.trades,
  });

  factory ChampSelect.fromJson(Map<String, dynamic> json) {
    return ChampSelect(
      actions:
          (json['actions'] as List)
              .map(
                (innerList) =>
                    (innerList as List)
                        .map((item) => Action.fromJson(item))
                        .toList(),
              )
              .toList(),
      allowBattleBoost: json['allowBattleBoost'],
      allowDuplicatePicks: json['allowDuplicatePicks'],
      allowLockedEvents: json['allowLockedEvents'],
      allowRerolling: json['allowRerolling'],
      allowSkinSelection: json['allowSkinSelection'],
      allowSubsetChampionPicks: json['allowSubsetChampionPicks'],
      bans: Bans.fromJson(json['bans']),
      benchChampions: json['benchChampions'],
      benchEnabled: json['benchEnabled'],
      boostableSkinCount: json['boostableSkinCount'],
      chatDetails: ChatDetails.fromJson(json['chatDetails']),
      counter: json['counter'],
      gameId: json['gameId'],
      hasSimultaneousBans: json['hasSimultaneousBans'],
      hasSimultaneousPicks: json['hasSimultaneousPicks'],
      id: json['id'],
      isCustomGame: json['isCustomGame'],
      isLegacyChampSelect: json['isLegacyChampSelect'],
      isSpectating: json['isSpectating'],
      localPlayerCellId: json['localPlayerCellId'],
      lockedEventIndex: json['lockedEventIndex'],
      myTeam: (json['myTeam'] as List).map((e) => Player.fromJson(e)).toList(),
      pickOrderSwaps: json['pickOrderSwaps'],
      positionSwaps: json['positionSwaps'],
      rerollsRemaining: json['rerollsRemaining'],
      showQuitButton: json['showQuitButton'],
      skipChampionSelect: json['skipChampionSelect'],
      theirTeam: json['theirTeam'],
      timer: Timer.fromJson(json['timer']),
      trades: json['trades'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actions':
          actions
              .map(
                (innerList) => innerList.map((item) => item.toJson()).toList(),
              )
              .toList(),
      'allowBattleBoost': allowBattleBoost,
      'allowDuplicatePicks': allowDuplicatePicks,
      'allowLockedEvents': allowLockedEvents,
      'allowRerolling': allowRerolling,
      'allowSkinSelection': allowSkinSelection,
      'allowSubsetChampionPicks': allowSubsetChampionPicks,
      'bans': bans.toJson(),
      'benchChampions': benchChampions,
      'benchEnabled': benchEnabled,
      'boostableSkinCount': boostableSkinCount,
      'chatDetails': chatDetails.toJson(),
      'counter': counter,
      'gameId': gameId,
      'hasSimultaneousBans': hasSimultaneousBans,
      'hasSimultaneousPicks': hasSimultaneousPicks,
      'id': id,
      'isCustomGame': isCustomGame,
      'isLegacyChampSelect': isLegacyChampSelect,
      'isSpectating': isSpectating,
      'localPlayerCellId': localPlayerCellId,
      'lockedEventIndex': lockedEventIndex,
      'myTeam': myTeam.map((e) => e.toJson()).toList(),
      'pickOrderSwaps': pickOrderSwaps,
      'positionSwaps': positionSwaps,
      'rerollsRemaining': rerollsRemaining,
      'showQuitButton': showQuitButton,
      'skipChampionSelect': skipChampionSelect,
      'theirTeam': theirTeam,
      'timer': timer.toJson(),
      'trades': trades,
    };
  }
}

enum ActionType {
  ban,
  pick;

  String get value {
    switch (this) {
      case ActionType.ban:
        return 'ban';
      case ActionType.pick:
        return 'pick';
    }
  }

  static ActionType fromString(String value) {
    switch (value) {
      case 'ban':
        return ActionType.ban;
      case 'pick':
        return ActionType.pick;
      default:
        throw Exception('Unknown ActionType: $value');
    }
  }
}

class Action {
  final int actorCellId;
  final int championId;
  final bool completed;
  final int id;
  final bool isAllyAction;
  final bool isInProgress;
  final int pickTurn;
  final ActionType type;

  Action({
    required this.actorCellId,
    required this.championId,
    required this.completed,
    required this.id,
    required this.isAllyAction,
    required this.isInProgress,
    required this.pickTurn,
    required this.type,
  });

  factory Action.fromJson(Map<String, dynamic> json) {
    return Action(
      actorCellId: json['actorCellId'],
      championId: json['championId'],
      completed: json['completed'],
      id: json['id'],
      isAllyAction: json['isAllyAction'],
      isInProgress: json['isInProgress'],
      pickTurn: json['pickTurn'],
      type: ActionType.fromString(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'actorCellId': actorCellId,
      'championId': championId,
      'completed': completed,
      'id': id,
      'isAllyAction': isAllyAction,
      'isInProgress': isInProgress,
      'pickTurn': pickTurn,
      'type': type.value,
    };
  }
}

class Bans {
  final List<dynamic> myTeamBans;
  final int numBans;
  final List<dynamic> theirTeamBans;

  Bans({
    required this.myTeamBans,
    required this.numBans,
    required this.theirTeamBans,
  });

  factory Bans.fromJson(Map<String, dynamic> json) {
    return Bans(
      myTeamBans: json['myTeamBans'],
      numBans: json['numBans'],
      theirTeamBans: json['theirTeamBans'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'myTeamBans': myTeamBans,
      'numBans': numBans,
      'theirTeamBans': theirTeamBans,
    };
  }
}

class ChatDetails {
  final MucJwtDto mucJwtDto;
  final String multiUserChatId;
  final String multiUserChatPassword;

  ChatDetails({
    required this.mucJwtDto,
    required this.multiUserChatId,
    required this.multiUserChatPassword,
  });

  factory ChatDetails.fromJson(Map<String, dynamic> json) {
    return ChatDetails(
      mucJwtDto: MucJwtDto.fromJson(json['mucJwtDto']),
      multiUserChatId: json['multiUserChatId'],
      multiUserChatPassword: json['multiUserChatPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mucJwtDto': mucJwtDto.toJson(),
      'multiUserChatId': multiUserChatId,
      'multiUserChatPassword': multiUserChatPassword,
    };
  }
}

class Player {
  final String assignedPosition;
  final int cellId;
  final int championId;
  final int championPickIntent;
  final String gameName;
  final String internalName;
  final bool isHumanoid;
  final String nameVisibilityType;
  final String obfuscatedPuuid;
  final int obfuscatedSummonerId;
  final int pickMode;
  final int pickTurn;
  final String playerAlias;
  final String playerType;
  final String puuid;
  final int selectedSkinId;
  final int spell1Id;
  final int spell2Id;
  final int summonerId;
  final String tagLine;
  final int team;
  final int wardSkinId;

  Player({
    required this.assignedPosition,
    required this.cellId,
    required this.championId,
    required this.championPickIntent,
    required this.gameName,
    required this.internalName,
    required this.isHumanoid,
    required this.nameVisibilityType,
    required this.obfuscatedPuuid,
    required this.obfuscatedSummonerId,
    required this.pickMode,
    required this.pickTurn,
    required this.playerAlias,
    required this.playerType,
    required this.puuid,
    required this.selectedSkinId,
    required this.spell1Id,
    required this.spell2Id,
    required this.summonerId,
    required this.tagLine,
    required this.team,
    required this.wardSkinId,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      assignedPosition: json['assignedPosition'],
      cellId: json['cellId'],
      championId: json['championId'],
      championPickIntent: json['championPickIntent'],
      gameName: json['gameName'],
      internalName: json['internalName'],
      isHumanoid: json['isHumanoid'],
      nameVisibilityType: json['nameVisibilityType'],
      obfuscatedPuuid: json['obfuscatedPuuid'],
      obfuscatedSummonerId: json['obfuscatedSummonerId'],
      pickMode: json['pickMode'],
      pickTurn: json['pickTurn'],
      playerAlias: json['playerAlias'],
      playerType: json['playerType'],
      puuid: json['puuid'],
      selectedSkinId: json['selectedSkinId'],
      spell1Id: json['spell1Id'],
      spell2Id: json['spell2Id'],
      summonerId: json['summonerId'],
      tagLine: json['tagLine'],
      team: json['team'],
      wardSkinId: json['wardSkinId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assignedPosition': assignedPosition,
      'cellId': cellId,
      'championId': championId,
      'championPickIntent': championPickIntent,
      'gameName': gameName,
      'internalName': internalName,
      'isHumanoid': isHumanoid,
      'nameVisibilityType': nameVisibilityType,
      'obfuscatedPuuid': obfuscatedPuuid,
      'obfuscatedSummonerId': obfuscatedSummonerId,
      'pickMode': pickMode,
      'pickTurn': pickTurn,
      'playerAlias': playerAlias,
      'playerType': playerType,
      'puuid': puuid,
      'selectedSkinId': selectedSkinId,
      'spell1Id': spell1Id,
      'spell2Id': spell2Id,
      'summonerId': summonerId,
      'tagLine': tagLine,
      'team': team,
      'wardSkinId': wardSkinId,
    };
  }
}

class Timer {
  final int adjustedTimeLeftInPhase;
  final int internalNowInEpochMs;
  final bool isInfinite;
  final String phase;
  final int totalTimeInPhase;

  Timer({
    required this.adjustedTimeLeftInPhase,
    required this.internalNowInEpochMs,
    required this.isInfinite,
    required this.phase,
    required this.totalTimeInPhase,
  });

  factory Timer.fromJson(Map<String, dynamic> json) {
    return Timer(
      adjustedTimeLeftInPhase: json['adjustedTimeLeftInPhase'],
      internalNowInEpochMs: json['internalNowInEpochMs'],
      isInfinite: json['isInfinite'],
      phase: json['phase'],
      totalTimeInPhase: json['totalTimeInPhase'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adjustedTimeLeftInPhase': adjustedTimeLeftInPhase,
      'internalNowInEpochMs': internalNowInEpochMs,
      'isInfinite': isInfinite,
      'phase': phase,
      'totalTimeInPhase': totalTimeInPhase,
    };
  }
}
