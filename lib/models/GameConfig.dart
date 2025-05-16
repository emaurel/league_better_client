
class GameConfig {
  final List<int> allowablePremadeSizes;
  final String customLobbyName;
  final String customMutatorName;
  final List<dynamic> customRewardsDisabledReasons;
  final String customSpectatorPolicy;
  final List<dynamic> customSpectators;
  final List<dynamic> customTeam100;
  final List<dynamic> customTeam200;
  final String gameMode;
  final bool isCustom;
  final bool isLobbyFull;
  final bool isTeamBuilderManaged;
  final int mapId;
  final int maxHumanPlayers;
  final int maxLobbySize;
  final int maxTeamSize;
  final String pickType;
  final bool premadeSizeAllowed;
  final int queueId;
  final bool shouldForceScarcePositionSelection;
  final bool showPositionSelector;
  final bool showQuickPlaySlotSelection;

  late String mapName = "";

  GameConfig({
    required this.allowablePremadeSizes,
    required this.customLobbyName,
    required this.customMutatorName,
    required this.customRewardsDisabledReasons,
    required this.customSpectatorPolicy,
    required this.customSpectators,
    required this.customTeam100,
    required this.customTeam200,
    required this.gameMode,
    required this.isCustom,
    required this.isLobbyFull,
    required this.isTeamBuilderManaged,
    required this.mapId,
    required this.maxHumanPlayers,
    required this.maxLobbySize,
    required this.maxTeamSize,
    required this.pickType,
    required this.premadeSizeAllowed,
    required this.queueId,
    required this.shouldForceScarcePositionSelection,
    required this.showPositionSelector,
    required this.showQuickPlaySlotSelection,
  });

  factory GameConfig.fromJson(Map<String, dynamic> json) {
    var res = GameConfig(
      allowablePremadeSizes:
          List<int>.from(json['allowablePremadeSizes'].map((x) => x)),
      customLobbyName: json['customLobbyName'],
      customMutatorName: json['customMutatorName'],
      customRewardsDisabledReasons: json['customRewardsDisabledReasons'],
      customSpectatorPolicy: json['customSpectatorPolicy'],
      customSpectators: json['customSpectators'],
      customTeam100: json['customTeam100'],
      customTeam200: json['customTeam200'],
      gameMode: json['gameMode'],
      isCustom: json['isCustom'],
      isLobbyFull: json['isLobbyFull'],
      isTeamBuilderManaged: json['isTeamBuilderManaged'],
      mapId: json['mapId'],
      maxHumanPlayers: json['maxHumanPlayers'],
      maxLobbySize: json['maxLobbySize'],
      maxTeamSize: json['maxTeamSize'],
      pickType: json['pickType'],
      premadeSizeAllowed: json['premadeSizeAllowed'],
      queueId: json['queueId'],
      shouldForceScarcePositionSelection:
          json['shouldForceScarcePositionSelection'],
      showPositionSelector: json['showPositionSelector'],
      showQuickPlaySlotSelection: json['showQuickPlaySlotSelection'],
    );

    if (res.mapId == 11) {
      res.mapName = "Summoner's Rift";
    } else if (res.mapId == 12) {
      res.mapName = "Howling Abyss";
    } else if (res.mapId == 13) {
      res.mapName = "Twisted Treeline";
    } else if (res.mapId == 14) {
      res.mapName = "Crystal Scar";
    } else if (res.mapId == 15) {
      res.mapName = "The Proving Grounds";
    } else if (res.mapId == 16) {
      res.mapName = "The Rift";
    } else if (res.mapId == 30) {
      res.mapName = "Arena";
    }
    else {
      res.mapName = res.mapId.toString();
    }
    return res;
  }

  Map<String, dynamic> toJson() {
    return {
      'allowablePremadeSizes': List<dynamic>.from(allowablePremadeSizes),
      'customLobbyName': customLobbyName,
      'customMutatorName': customMutatorName,
      'customRewardsDisabledReasons': customRewardsDisabledReasons,
      'customSpectatorPolicy': customSpectatorPolicy,
      'customSpectators': customSpectators,
      'customTeam100': customTeam100,
      'customTeam200': customTeam200,
      'gameMode': gameMode,
      'isCustom': isCustom,
      'isLobbyFull': isLobbyFull,
      'isTeamBuilderManaged': isTeamBuilderManaged,
      'mapId': mapId,
      'maxHumanPlayers': maxHumanPlayers,
      'maxLobbySize': maxLobbySize,
      'maxTeamSize': maxTeamSize,
      'pickType': pickType,
      'premadeSizeAllowed': premadeSizeAllowed,
      'queueId': queueId,
      'shouldForceScarcePositionSelection':
          shouldForceScarcePositionSelection,
      'showPositionSelector': showPositionSelector,
      'showQuickPlaySlotSelection': showQuickPlaySlotSelection,
    };
  }


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GameConfig &&
        other.customLobbyName == customLobbyName &&
        other.customMutatorName == customMutatorName &&
        other.customSpectatorPolicy == customSpectatorPolicy &&
        other.gameMode == gameMode &&
        other.isCustom == isCustom &&
        other.isLobbyFull == isLobbyFull &&
        other.isTeamBuilderManaged == isTeamBuilderManaged &&
        other.mapId == mapId &&
        other.maxHumanPlayers == maxHumanPlayers &&
        other.maxLobbySize == maxLobbySize &&
        other.maxTeamSize == maxTeamSize &&
        other.pickType == pickType &&
        other.premadeSizeAllowed == premadeSizeAllowed &&
        other.queueId == queueId &&
        other.shouldForceScarcePositionSelection ==
            shouldForceScarcePositionSelection &&
        other.showPositionSelector == showPositionSelector &&
        other.showQuickPlaySlotSelection == showQuickPlaySlotSelection;
  }

  @override
  int get hashCode {
    return customLobbyName.hashCode ^
        customMutatorName.hashCode ^
        customSpectatorPolicy.hashCode ^
        gameMode.hashCode ^
        isCustom.hashCode ^
        isLobbyFull.hashCode ^
        isTeamBuilderManaged.hashCode ^
        mapId.hashCode ^
        maxHumanPlayers.hashCode ^
        maxLobbySize.hashCode ^
        maxTeamSize.hashCode ^
        pickType.hashCode ^
        premadeSizeAllowed.hashCode ^
        queueId.hashCode ^
        shouldForceScarcePositionSelection.hashCode ^
        showPositionSelector.hashCode ^
        showQuickPlaySlotSelection.hashCode;
  }
}