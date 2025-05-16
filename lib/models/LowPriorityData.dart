

class LowPriorityData {
  String? bustedLeaveAccessToken;
  List<int>? penalizedSummonerIds;
  double? penaltyTime;
  double? penaltyTimeRemaining;
  String? reason;

  LowPriorityData({
    this.bustedLeaveAccessToken,
    this.penalizedSummonerIds,
    this.penaltyTime,
    this.penaltyTimeRemaining,
    this.reason,
  });

  factory LowPriorityData.fromJson(Map<String, dynamic> json) {
    return LowPriorityData(
      bustedLeaveAccessToken: json['bustedLeaveAccessToken'],
      penalizedSummonerIds: json['penalizedSummonerIds'] != null
          ? List<int>.from(json['penalizedSummonerIds'])
          : null,
      penaltyTime: json['penaltyTime']?.toDouble(),
      penaltyTimeRemaining: json['penaltyTimeRemaining']?.toDouble(),
      reason: json['reason'],
    );
  }
}