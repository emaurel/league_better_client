class DodgeData {
  int? dodgerId;
  String? state;

  DodgeData({this.dodgerId, this.state});

  factory DodgeData.fromJson(Map<String, dynamic> json) {
    return DodgeData(dodgerId: json['dodgerId'], state: json['state']);
  }

  Map<String, dynamic> toJson() {
    return {'dodgerId': dodgerId, 'state': state};
  }
}
