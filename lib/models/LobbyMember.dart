class Member {
  final bool allowedChangeActivity;
  final bool allowedInviteOthers;
  final bool allowedKickOthers;
  final bool allowedStartActivity;
  final bool allowedToggleInvite;
  final bool autoFillEligible;
  final bool autoFillProtectedForPromos;
  final bool autoFillProtectedForRemedy;
  final bool autoFillProtectedForSoloing;
  final bool autoFillProtectedForStreaking;
  final int botChampionId;
  final String botDifficulty;
  final String botId;
  final String botPosition;
  final String botUuid;
  final String firstPositionPreference;
  final int? intraSubteamPosition;
  final bool isBot;
  final bool isLeader;
  final bool isSpectator;
  final dynamic memberData;
  final List<dynamic> playerSlots;
  final String puuid;
  final bool ready;
  final String secondPositionPreference;
  final bool showGhostedBanner;
  final int? strawberryMapId;
  final int? subteamIndex;
  final int summonerIconId;
  final int summonerId;
  final String summonerInternalName;
  final int summonerLevel;
  final String summonerName;
  final int teamId;

  Member({
    required this.allowedChangeActivity,
    required this.allowedInviteOthers,
    required this.allowedKickOthers,
    required this.allowedStartActivity,
    required this.allowedToggleInvite,
    required this.autoFillEligible,
    required this.autoFillProtectedForPromos,
    required this.autoFillProtectedForRemedy,
    required this.autoFillProtectedForSoloing,
    required this.autoFillProtectedForStreaking,
    required this.botChampionId,
    required this.botDifficulty,
    required this.botId,
    required this.botPosition,
    required this.botUuid,
    required this.firstPositionPreference,
    this.intraSubteamPosition,
    required this.isBot,
    required this.isLeader,
    required this.isSpectator,
    this.memberData,
    required this.playerSlots,
    required this.puuid,
    required this.ready,
    required this.secondPositionPreference,
    required this.showGhostedBanner,
    this.strawberryMapId,
    this.subteamIndex,
    required this.summonerIconId,
    required this.summonerId,
    required this.summonerInternalName,
    required this.summonerLevel,
    required this.summonerName,
    required this.teamId,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      allowedChangeActivity: json['allowedChangeActivity'],
      allowedInviteOthers: json['allowedInviteOthers'],
      allowedKickOthers: json['allowedKickOthers'],
      allowedStartActivity: json['allowedStartActivity'],
      allowedToggleInvite: json['allowedToggleInvite'],
      autoFillEligible: json['autoFillEligible'],
      autoFillProtectedForPromos: json['autoFillProtectedForPromos'],
      autoFillProtectedForRemedy: json['autoFillProtectedForRemedy'],
      autoFillProtectedForSoloing: json['autoFillProtectedForSoloing'],
      autoFillProtectedForStreaking: json['autoFillProtectedForStreaking'],
      botChampionId: json['botChampionId'],
      botDifficulty: json['botDifficulty'],
      botId: json['botId'],
      botPosition: json['botPosition'],
      botUuid: json['botUuid'],
      firstPositionPreference: json['firstPositionPreference'],
      intraSubteamPosition: json['intraSubteamPosition'],
      isBot: json['isBot'],
      isLeader: json['isLeader'],
      isSpectator: json['isSpectator'],
      memberData: json['memberData'],
      playerSlots: json['playerSlots'],
      puuid: json['puuid'],
      ready: json['ready'],
      secondPositionPreference: json['secondPositionPreference'],
      showGhostedBanner: json['showGhostedBanner'],
      strawberryMapId: json['strawberryMapId'],
      subteamIndex: json['subteamIndex'],
      summonerIconId: json['summonerIconId'],
      summonerId: json['summonerId'],
      summonerInternalName: json['summonerInternalName'],
      summonerLevel: json['summonerLevel'],
      summonerName: json['summonerName'],
      teamId: json['teamId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowedChangeActivity': allowedChangeActivity,
      'allowedInviteOthers': allowedInviteOthers,
      'allowedKickOthers': allowedKickOthers,
      'allowedStartActivity': allowedStartActivity,
      'allowedToggleInvite': allowedToggleInvite,
      'autoFillEligible': autoFillEligible,
      'autoFillProtectedForPromos': autoFillProtectedForPromos,
      'autoFillProtectedForRemedy': autoFillProtectedForRemedy,
      'autoFillProtectedForSoloing': autoFillProtectedForSoloing,
      'autoFillProtectedForStreaking': autoFillProtectedForStreaking,
      'botChampionId': botChampionId,
      'botDifficulty': botDifficulty,
      'botId': botId,
      'botPosition': botPosition,
      'botUuid': botUuid,
      'firstPositionPreference': firstPositionPreference,
      'intraSubteamPosition': intraSubteamPosition,
      'isBot': isBot,
      'isLeader': isLeader,
      'isSpectator': isSpectator,
      'memberData': memberData,
      'playerSlots': playerSlots,
      'puuid': puuid,
      'ready': ready,
      'secondPositionPreference': secondPositionPreference,
      'showGhostedBanner': showGhostedBanner,
      'strawberryMapId': strawberryMapId,
      'subteamIndex': subteamIndex,
      'summonerIconId': summonerIconId,
      'summonerId': summonerId,
      'summonerInternalName': summonerInternalName,
      'summonerLevel': summonerLevel,
      'summonerName': summonerName,
      'teamId': teamId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (other is! Member) return false;
    return other.summonerId == summonerId &&
        other.summonerName == summonerName &&
        other.summonerIconId == summonerIconId &&
        other.summonerLevel == summonerLevel &&
        other.teamId == teamId && other.isLeader == isLeader
        && other.ready == ready && other.firstPositionPreference == firstPositionPreference
        && other.secondPositionPreference == secondPositionPreference;
  }

  @override
  int get hashCode {
    return summonerId.hashCode ^
        summonerName.hashCode ^
        summonerIconId.hashCode ^
        summonerLevel.hashCode ^
        teamId.hashCode;
  }
}
