class Summoner {
  const Summoner({
    required this.summonerId,
    required this.puuid,
    required this.displayName,
    required this.gameName,
    required this.tagLine,
    required this.summonerLevel,
    required this.profileIconId,
    required this.xpSinceLastLevel,
    required this.xpUntilNextLevel,
  });

  final int summonerId;
  final String puuid;
  final String displayName;
  final String gameName;
  final String tagLine;
  final int summonerLevel;
  final int profileIconId;
  final int xpSinceLastLevel;
  final int xpUntilNextLevel;

  String get rifleName => tagLine.isEmpty ? gameName : '$gameName#$tagLine';

  double get levelProgress {
    if (xpUntilNextLevel <= 0) return 0;
    final total = xpSinceLastLevel + xpUntilNextLevel;
    if (total <= 0) return 0;
    return xpSinceLastLevel / total;
  }

  factory Summoner.fromJson(Map<String, dynamic> json) {
    return Summoner(
      summonerId: (json['summonerId'] as num?)?.toInt() ?? 0,
      puuid: json['puuid'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      gameName: json['gameName'] as String? ?? '',
      tagLine: json['tagLine'] as String? ?? '',
      summonerLevel: (json['summonerLevel'] as num?)?.toInt() ?? 0,
      profileIconId: (json['profileIconId'] as num?)?.toInt() ?? 0,
      xpSinceLastLevel: (json['xpSinceLastLevel'] as num?)?.toInt() ?? 0,
      xpUntilNextLevel: (json['xpUntilNextLevel'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'summonerId': summonerId,
        'puuid': puuid,
        'displayName': displayName,
        'gameName': gameName,
        'tagLine': tagLine,
        'summonerLevel': summonerLevel,
        'profileIconId': profileIconId,
        'xpSinceLastLevel': xpSinceLastLevel,
        'xpUntilNextLevel': xpUntilNextLevel,
      };
}
