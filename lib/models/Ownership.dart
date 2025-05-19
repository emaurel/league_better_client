import 'Rental.dart';

class Ownership {
  bool loyalyReward;
  bool owned;
  Rental rental;
  bool xboxGPReward;

  Ownership({
    required this.loyalyReward,
    required this.owned,
    required this.rental,
    required this.xboxGPReward,
  });

  factory Ownership.fromJson(Map<String, dynamic> json) {
    return Ownership(
      loyalyReward: json['loyalyReward'] ?? false,
      owned: json['owned'] ?? false,
      rental: Rental.fromJson(json['rental']),
      xboxGPReward: json['xboxGPReward'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loyalyReward': loyalyReward,
      'owned': owned,
      'rental': rental.toJson(),
      'xboxGPReward': xboxGPReward,
    };
  }
}
