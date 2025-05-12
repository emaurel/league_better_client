class GameTypeConfig {
  bool advancedLearningQuests;
  bool allowTrades;
  String banMode;
  int banTimerDuration;
  bool battleBoost;
  bool crossTeamChampionPool;
  bool deathMatch;
  bool doNotRemove;
  bool duplicatePick;
  bool exclusivePick;
  String? gameModeOverride;
  int id;
  bool learningQuests;
  int mainPickTimerDuration;
  int maxAllowableBans;
  String name;
  int? numPlayerPerTeamOverride;
  bool? onboardCoopBegineer;
  String pickMode;
  int postPickTimerDuration;
  bool reroll;
  bool teamChampionPool;

  GameTypeConfig({
    required this.advancedLearningQuests,
    required this.allowTrades,
    required this.banMode,
    required this.banTimerDuration,
    required this.battleBoost,
    required this.crossTeamChampionPool,
    required this.deathMatch,
    required this.doNotRemove,
    required this.duplicatePick,
    required this.exclusivePick,
    this.gameModeOverride,
    required this.id,
    required this.learningQuests,
    required this.mainPickTimerDuration,
    required this.maxAllowableBans,
    required this.name,
    this.numPlayerPerTeamOverride,
    required this.onboardCoopBegineer,
    required this.pickMode,
    required this.postPickTimerDuration,
    required this.reroll,
    required this.teamChampionPool,
  });

  factory GameTypeConfig.fromJson(Map<String, dynamic> json) {
    return GameTypeConfig(
      advancedLearningQuests: json['advancedLearningQuests'],
      allowTrades: json['allowTrades'],
      banMode: json['banMode'],
      banTimerDuration: json['banTimerDuration'],
      battleBoost: json['battleBoost'],
      crossTeamChampionPool: json['crossTeamChampionPool'],
      deathMatch: json['deathMatch'],
      doNotRemove: json['doNotRemove'],
      duplicatePick: json['duplicatePick'],
      exclusivePick: json['exclusivePick'],
      gameModeOverride: json['gameModeOverride'],
      id: json['id'],
      learningQuests: json['learningQuests'],
      mainPickTimerDuration: json['mainPickTimerDuration'],
      maxAllowableBans: json['maxAllowableBans'],
      name: json['name'],
      numPlayerPerTeamOverride: json['numPlayerPerTeamOverride'],
      onboardCoopBegineer: (json['onboardCoopBegineer'] ?? false) as bool,
      pickMode: json['pickMode'],
      postPickTimerDuration: json['postPickTimerDuration'],
      reroll: json['reroll'],
      teamChampionPool: json['teamChampionPool'],
    );
  }
}
