import 'Augment.dart';

class SkinAugments {
  List<Augment> augments;

  SkinAugments({required this.augments});

  factory SkinAugments.fromJson(Map<String, dynamic> json) {
    return SkinAugments(
      augments: List<Augment>.from(
        json['augments']?.map((x) => Augment.fromJson(x)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'augments': augments.map((a) => a.toJson()).toList()};
  }
}
