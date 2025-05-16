class ReadyCheck {
  List<int>? declinerIds;
  String? dodgeWarning;
  String? playerResponse;
  String? state;
  bool? suppressUx;
  double? timer;

  ReadyCheck({
    this.declinerIds,
    this.dodgeWarning,
    this.playerResponse,
    this.state,
    this.suppressUx,
    this.timer,
  });

  factory ReadyCheck.fromJson(Map<String, dynamic> json) {
    return ReadyCheck(
      declinerIds: json['declinerIds'] != null
          ? List<int>.from(json['declinerIds'])
          : null,
      dodgeWarning: json['dodgeWarning'],
      playerResponse: json['playerResponse'],
      state: json['state'],
      suppressUx: json['suppressUx'],
      timer: json['timer']?.toDouble(),
    );
  }
}