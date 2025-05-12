


import 'package:league_better_client/models/GameTypeConfig.dart';
import 'package:league_better_client/models/QueueRewards.dart';

class Queue {
  List<int> allowablePremadeSizes;
  bool areFreeChampionsAllowed;
  String assetMutator;
  String category;
  int championsRequiredToPlay;
  String description;
  String detailedDescription;
  String gameMode;
  String gameSelectCategory;
  String gameSelectModeGroup;
  int gameSelectPriority;
  GameTypeConfig gameTypeConfig;
  bool hidePlayerPosition;
  int id;
  bool isCustom;
  bool isRanked;
  bool isSkillTreeQueue;
  bool isTeamBuilderManaged;
  bool isVisible;
  int lastToggledOffTime;
  int lastToggledOnTime;
  int mapId;
  String maxDivisionForPremadeSize2;
  int maxLobbySpectatorCount;
  String maxTierForPremadeSize2;
  int maximumParticipantListSize;
  int minLevel;
  int minimumParticipantListSize;
  String name;
  int numPlayersPerTeam;
  int numberOfTeamsInLobby;
  String queueAvailability;
  QueueRewards queueRewards;
  bool removalFromGameAllowed;
  int removalFromGameDelayMinutes;
  String shortName;
  bool showPositionSelector;
  bool showQuickPlaySlotSelection;
  bool spectatorEnabled;
  String type;

  Queue({
    required this.allowablePremadeSizes,
    required this.areFreeChampionsAllowed,
    required this.assetMutator,
    required this.category,
    required this.championsRequiredToPlay,
    required this.description,
    required this.detailedDescription,
    required this.gameMode,
    required this.gameSelectCategory,
    required this.gameSelectModeGroup,
    required this.gameSelectPriority,
    required this.gameTypeConfig,
    required this.hidePlayerPosition,
    required this.id,
    required this.isCustom,
    required this.isRanked,
    required this.isSkillTreeQueue,
    required this.isTeamBuilderManaged,
    required this.isVisible,
    required this.lastToggledOffTime,
    required this.lastToggledOnTime,
    required this.mapId,
    required this.maxDivisionForPremadeSize2,
    required this.maxLobbySpectatorCount,
    required this.maxTierForPremadeSize2,
    required this.maximumParticipantListSize,
    required this.minLevel,
    required this.minimumParticipantListSize,
    required this.name,
    required this.numPlayersPerTeam,
    required this.numberOfTeamsInLobby,
    required this.queueAvailability,
    required this.queueRewards,
    required this.removalFromGameAllowed,
    required this.removalFromGameDelayMinutes,
    required this.shortName,
    required this.showPositionSelector,
    required this.showQuickPlaySlotSelection,
    required this.spectatorEnabled,
    required this.type,
  });

  factory Queue.fromJson(Map<String, dynamic> json) {
    return Queue(
      allowablePremadeSizes: List<int>.from(json['allowablePremadeSizes']),
      areFreeChampionsAllowed: json['areFreeChampionsAllowed'],
      assetMutator: json['assetMutator'],
      category: json['category'],
      championsRequiredToPlay: json['championsRequiredToPlay'],
      description: json['description'],
      detailedDescription: json['detailedDescription'],
      gameMode: json['gameMode'],
      gameSelectCategory: json['gameSelectCategory'],
      gameSelectModeGroup: json['gameSelectModeGroup'],
      gameSelectPriority: json['gameSelectPriority'],
      gameTypeConfig: GameTypeConfig.fromJson(json['gameTypeConfig']),
      hidePlayerPosition: json['hidePlayerPosition'],
      id: json['id'],
      isCustom: json['isCustom'],
      isRanked: json['isRanked'],
      isSkillTreeQueue: json['isSkillTreeQueue'],
      isTeamBuilderManaged: json['isTeamBuilderManaged'],
      isVisible: json['isVisible'],
      lastToggledOffTime: json['lastToggledOffTime'],
      lastToggledOnTime: json['lastToggledOnTime'],
      mapId: json['mapId'],
      maxDivisionForPremadeSize2: json['maxDivisionForPremadeSize2'] ?? '',
      maxLobbySpectatorCount: json['maxLobbySpectatorCount'] ?? 0,
      maxTierForPremadeSize2: json['maxTierForPremadeSize2'] ?? '',
      maximumParticipantListSize:
          (json['maximumParticipantListSize'] as int?) ?? 0,
      minLevel: (json['minLevel'] as int?) ?? 0,
      minimumParticipantListSize:
          (json['minimumParticipantListSize'] as int?) ?? 0,
      name: (json['name'] as String?) ?? '',
      numPlayersPerTeam: (json['numPlayersPerTeam'] as int?) ?? 0,
      numberOfTeamsInLobby: (json['numberOfTeamsInLobby'] as int?) ?? 0,
      queueAvailability: (json['queueAvailability'] as String?) ?? '',
      queueRewards: QueueRewards.fromJson(json['queueRewards']),
      removalFromGameAllowed:
          (json['removalFromGameAllowed'] as bool?) ?? false,
      removalFromGameDelayMinutes:
          (json['removalFromGameDelayMinutes'] as int?) ?? 0,
      shortName: (json['shortName'] as String?) ?? '',
      showPositionSelector: (json['showPositionSelector'] as bool?) ?? false,
      showQuickPlaySlotSelection:
          (json['showQuickPlaySlotSelection'] as bool?) ?? false,
      spectatorEnabled: (json['spectatorEnabled'] as bool?) ?? false,
      type: (json['type'] as String?) ?? '',
    );
  }
}
