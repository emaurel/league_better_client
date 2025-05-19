class TacticalInfo {
  String damageType;
  int difficulty;
  int style;

  TacticalInfo({
    required this.damageType,
    required this.difficulty,
    required this.style,
  });

  factory TacticalInfo.fromJson(Map<String, dynamic> json) {
    return TacticalInfo(
      damageType: json['damageType'] ?? '',
      difficulty: json['difficulty'] ?? 0,
      style: json['style'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'damageType': damageType, 'difficulty': difficulty, 'style': style};
  }
}
