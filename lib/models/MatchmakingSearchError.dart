class MatchmakingSearchError {
  int? id;
  String? errorType;
  int? penalizedSummonerId;
  double? penaltyTimeRemaining;
  String? message;

  MatchmakingSearchError({
    this.id,
    this.errorType,
    this.penalizedSummonerId,
    this.penaltyTimeRemaining,
    this.message,
  });

  factory MatchmakingSearchError.fromJson(Map<String, dynamic> json) {
    return MatchmakingSearchError(
      id: json['id'],
      errorType: json['errorType'],
      penalizedSummonerId: json['penalizedSummonerId'],
      penaltyTimeRemaining: json['penaltyTimeRemaining']?.toDouble(),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'errorType': errorType,
      'penalizedSummonerId': penalizedSummonerId,
      'penaltyTimeRemaining': penaltyTimeRemaining,
      'message': message,
    };
  }
}
