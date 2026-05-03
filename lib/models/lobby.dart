class LobbyMember {
  const LobbyMember({
    required this.summonerId,
    required this.puuid,
    required this.displayName,
    required this.isLeader,
    required this.isReady,
    required this.firstPositionPreference,
    required this.secondPositionPreference,
  });

  final int summonerId;
  final String puuid;
  final String displayName;
  final bool isLeader;
  final bool isReady;
  final String firstPositionPreference;
  final String secondPositionPreference;

  factory LobbyMember.fromJson(Map<String, dynamic> json) {
    return LobbyMember(
      summonerId: (json['summonerId'] as num?)?.toInt() ?? 0,
      puuid: json['puuid'] as String? ?? '',
      displayName: json['summonerName'] as String? ?? json['displayName'] as String? ?? '',
      isLeader: json['isLeader'] as bool? ?? false,
      isReady: json['ready'] as bool? ?? false,
      firstPositionPreference: json['firstPositionPreference'] as String? ?? '',
      secondPositionPreference: json['secondPositionPreference'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'summonerId': summonerId,
        'puuid': puuid,
        'displayName': displayName,
        'isLeader': isLeader,
        'ready': isReady,
        'firstPositionPreference': firstPositionPreference,
        'secondPositionPreference': secondPositionPreference,
      };
}

class LobbyGameConfig {
  const LobbyGameConfig({
    required this.queueId,
    required this.mapId,
    required this.gameMode,
    required this.isCustom,
    required this.allowablePremadeSizes,
    required this.maxLobbySize,
  });

  final int queueId;
  final int mapId;
  final String gameMode;
  final bool isCustom;
  final List<int> allowablePremadeSizes;
  final int maxLobbySize;

  factory LobbyGameConfig.fromJson(Map<String, dynamic> json) {
    return LobbyGameConfig(
      queueId: (json['queueId'] as num?)?.toInt() ?? 0,
      mapId: (json['mapId'] as num?)?.toInt() ?? 0,
      gameMode: json['gameMode'] as String? ?? '',
      isCustom: json['isCustom'] as bool? ?? false,
      allowablePremadeSizes: (json['allowablePremadeSizes'] as List?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      maxLobbySize: (json['maxLobbySize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'queueId': queueId,
        'mapId': mapId,
        'gameMode': gameMode,
        'isCustom': isCustom,
        'allowablePremadeSizes': allowablePremadeSizes,
        'maxLobbySize': maxLobbySize,
      };
}

class Lobby {
  const Lobby({
    required this.partyId,
    required this.partyType,
    required this.canStartActivity,
    required this.gameConfig,
    required this.members,
    required this.localMember,
  });

  final String partyId;
  final String partyType;
  final bool canStartActivity;
  final LobbyGameConfig gameConfig;
  final List<LobbyMember> members;
  final LobbyMember? localMember;

  factory Lobby.fromJson(Map<String, dynamic> json) {
    final members = (json['members'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map(LobbyMember.fromJson)
            .toList() ??
        const <LobbyMember>[];
    final local = json['localMember'];
    return Lobby(
      partyId: json['partyId'] as String? ?? '',
      partyType: json['partyType'] as String? ?? '',
      canStartActivity: json['canStartActivity'] as bool? ?? false,
      gameConfig: LobbyGameConfig.fromJson(
        json['gameConfig'] as Map<String, dynamic>? ?? const {},
      ),
      members: members,
      localMember: local is Map<String, dynamic>
          ? LobbyMember.fromJson(local)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'partyId': partyId,
        'partyType': partyType,
        'canStartActivity': canStartActivity,
        'gameConfig': gameConfig.toJson(),
        'members': members.map((m) => m.toJson()).toList(),
        'localMember': localMember?.toJson(),
      };
}
