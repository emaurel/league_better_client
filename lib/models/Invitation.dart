
class Invitation {
  final String invitationId;
  final String invitationType;
  final String state;
  final String timestamp;
  final int toSummonerId;
  final String toSummonerName;

  Invitation({
    required this.invitationId,
    required this.invitationType,
    required this.state,
    required this.timestamp,
    required this.toSummonerId,
    required this.toSummonerName,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      invitationId: json['invitationId'],
      invitationType: json['invitationType'],
      state: json['state'],
      timestamp: json['timestamp'],
      toSummonerId: json['toSummonerId'],
      toSummonerName: json['toSummonerName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invitationId': invitationId,
      'invitationType': invitationType,
      'state': state,
      'timestamp': timestamp,
      'toSummonerId': toSummonerId,
      'toSummonerName': toSummonerName,
    };
  }
}