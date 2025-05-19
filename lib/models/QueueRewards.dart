class QueueRewards {
  bool isChampionPointsEnabled;
  bool usIpEnabled;
  bool isXpEnabled;
  List<dynamic> partySizeIpRewards;

  QueueRewards({
    required this.isChampionPointsEnabled,
    required this.usIpEnabled,
    required this.isXpEnabled,
    required this.partySizeIpRewards,
  });

  factory QueueRewards.fromJson(Map<String, dynamic> json) {
    return QueueRewards(
      isChampionPointsEnabled: json['isChampionPointsEnabled'],
      usIpEnabled: (json['usIpEnabled'] ?? false) as bool,
      isXpEnabled: json['isXpEnabled'],
      partySizeIpRewards: json['partySizeIpRewards'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isChampionPointsEnabled': isChampionPointsEnabled,
      'usIpEnabled': usIpEnabled,
      'isXpEnabled': isXpEnabled,
      'partySizeIpRewards': partySizeIpRewards,
    };
  }
}
