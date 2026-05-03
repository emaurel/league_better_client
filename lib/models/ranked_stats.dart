class RankedQueueStats {
  const RankedQueueStats({
    required this.queueType,
    required this.tier,
    required this.division,
    required this.leaguePoints,
    required this.wins,
    required this.losses,
  });

  /// e.g. RANKED_SOLO_5x5, RANKED_FLEX_SR.
  final String queueType;
  final String tier;
  final String division;
  final int leaguePoints;
  final int wins;
  final int losses;

  bool get isUnranked => tier.isEmpty || tier.toUpperCase() == 'NONE';
  int get totalGames => wins + losses;
  double get winRate => totalGames == 0 ? 0 : wins / totalGames;

  String get displayRank {
    if (isUnranked) return 'Unranked';
    final base = '${_titleCase(tier)} $division';
    return '$base · $leaguePoints LP';
  }

  factory RankedQueueStats.fromJson(Map<String, dynamic> json) {
    return RankedQueueStats(
      queueType: json['queueType'] as String? ?? '',
      tier: json['tier'] as String? ?? '',
      division: json['division'] as String? ?? '',
      leaguePoints: (json['leaguePoints'] as num?)?.toInt() ?? 0,
      wins: (json['wins'] as num?)?.toInt() ?? 0,
      losses: (json['losses'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'queueType': queueType,
        'tier': tier,
        'division': division,
        'leaguePoints': leaguePoints,
        'wins': wins,
        'losses': losses,
      };
}

class RankedStats {
  const RankedStats({required this.queues});

  /// Keyed by queueType, e.g. RANKED_SOLO_5x5.
  final Map<String, RankedQueueStats> queues;

  RankedQueueStats? get soloDuo => queues['RANKED_SOLO_5x5'];
  RankedQueueStats? get flex => queues['RANKED_FLEX_SR'];

  factory RankedStats.fromJson(Map<String, dynamic> json) {
    final raw = json['queueMap'] as Map<String, dynamic>? ?? {};
    final queues = <String, RankedQueueStats>{};
    raw.forEach((k, v) {
      if (v is Map<String, dynamic>) {
        queues[k] = RankedQueueStats.fromJson(v);
      }
    });
    return RankedStats(queues: queues);
  }

  Map<String, dynamic> toJson() => {
        'queueMap': queues.map((k, v) => MapEntry(k, v.toJson())),
      };
}

String _titleCase(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}
