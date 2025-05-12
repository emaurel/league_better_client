


class Rental {
  int endDate;  
  int purchaseDate;
  bool rented;
  int winCountRemaining;

  Rental({
    required this.endDate,
    required this.purchaseDate,
    required this.rented,
    required this.winCountRemaining,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    return Rental(
      endDate: json['endDate'] ?? 0,
      purchaseDate: json['purchaseDate'] ?? 0,
      rented: json['rented'] ?? false,
      winCountRemaining: json['winCountRemaining'] ?? 0,
    );
  }

}

