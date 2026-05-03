enum FriendAvailability { online, away, mobile, offline, dnd, chat, unknown }

FriendAvailability _availabilityFromString(String? raw) {
  switch (raw) {
    case 'chat':
      return FriendAvailability.chat;
    case 'online':
      return FriendAvailability.online;
    case 'away':
      return FriendAvailability.away;
    case 'mobile':
      return FriendAvailability.mobile;
    case 'offline':
      return FriendAvailability.offline;
    case 'dnd':
      return FriendAvailability.dnd;
  }
  return FriendAvailability.unknown;
}

class FriendLolPresence {
  const FriendLolPresence({
    required this.gameStatus,
    required this.queueType,
    required this.championId,
    required this.skinId,
    required this.level,
    required this.gameMode,
    required this.mapId,
  });

  /// e.g. inGame, inChampSelect, inLobby, hosting_NORMAL, outOfGame.
  final String gameStatus;
  final String queueType;
  final int championId;
  final int skinId;
  final int level;
  final String gameMode;
  final int mapId;

  bool get inGame => gameStatus == 'inGame';
  bool get inChampSelect => gameStatus == 'championSelect';
  bool get inLobby => gameStatus.startsWith('hosting_') || gameStatus == 'inQueue';

  factory FriendLolPresence.fromJson(Map<String, dynamic> json) {
    return FriendLolPresence(
      gameStatus: json['gameStatus'] as String? ?? '',
      queueType: json['queueId']?.toString() ?? json['gameQueueType'] as String? ?? '',
      championId: int.tryParse(json['championId']?.toString() ?? '') ?? 0,
      skinId: int.tryParse(json['skinVariant']?.toString() ?? '') ?? 0,
      level: int.tryParse(json['level']?.toString() ?? '') ?? 0,
      gameMode: json['gameMode'] as String? ?? '',
      mapId: int.tryParse(json['mapId']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'gameStatus': gameStatus,
        'queueType': queueType,
        'championId': championId,
        'skinId': skinId,
        'level': level,
        'gameMode': gameMode,
        'mapId': mapId,
      };
}

class Friend {
  const Friend({
    required this.id,
    required this.name,
    required this.gameName,
    required this.tagLine,
    required this.summonerId,
    required this.statusMessage,
    required this.availability,
    required this.icon,
    required this.lol,
  });

  final String id;
  final String name;
  final String gameName;
  final String tagLine;
  final int summonerId;
  final String statusMessage;
  final FriendAvailability availability;
  final int icon;
  final FriendLolPresence? lol;

  String get displayName {
    if (gameName.isNotEmpty) {
      return tagLine.isEmpty ? gameName : '$gameName#$tagLine';
    }
    return name;
  }

  bool get isOnline => availability != FriendAvailability.offline &&
      availability != FriendAvailability.unknown;

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      gameName: json['gameName'] as String? ?? '',
      tagLine: json['gameTag'] as String? ?? json['tagLine'] as String? ?? '',
      summonerId: (json['summonerId'] as num?)?.toInt() ?? 0,
      statusMessage: json['statusMessage'] as String? ?? '',
      availability: _availabilityFromString(json['availability'] as String?),
      icon: (json['icon'] as num?)?.toInt() ?? 0,
      lol: json['lol'] is Map<String, dynamic>
          ? FriendLolPresence.fromJson(json['lol'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'gameName': gameName,
        'tagLine': tagLine,
        'summonerId': summonerId,
        'statusMessage': statusMessage,
        'availability': availability.name,
        'icon': icon,
        'lol': lol?.toJson(),
      };
}
