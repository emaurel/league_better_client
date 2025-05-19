class RerollPoints {
  int currentPoints;
  int maxRolls;
  int numberOfRolls;
  int pointsCostToRoll;
  int pointsToReroll;

  RerollPoints({
    required this.currentPoints,
    required this.maxRolls,
    required this.numberOfRolls,
    required this.pointsCostToRoll,
    required this.pointsToReroll,
  });

  factory RerollPoints.fromJson(Map<String, dynamic> json) {
    return RerollPoints(
      currentPoints: json['currentPoints'],
      maxRolls: json['maxRolls'],
      numberOfRolls: json['numberOfRolls'],
      pointsCostToRoll: json['pointsCostToRoll'],
      pointsToReroll: json['pointsToReroll'],
    );
  }

  factory RerollPoints.empty() {
    return RerollPoints(
      currentPoints: 0,
      maxRolls: 0,
      numberOfRolls: 0,
      pointsCostToRoll: 0,
      pointsToReroll: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPoints': currentPoints,
      'maxRolls': maxRolls,
      'numberOfRolls': numberOfRolls,
      'pointsCostToRoll': pointsCostToRoll,
      'pointsToReroll': pointsToReroll,
    };
  }
}
