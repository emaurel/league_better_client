import 'package:league_better_client/models/SkinAugments.dart';

import 'Ownership.dart';

class Chroma {
  int championId;
  String chromaPath;
  List<String> colors;
  bool disabled;
  int id;
  bool lastSelected;
  String name;
  Ownership ownership;
  SkinAugments skinAugments;
  bool stillObtainable;

  Chroma({
    required this.championId,
    required this.chromaPath,
    required this.colors,
    required this.disabled,
    required this.id,
    required this.lastSelected,
    required this.name,
    required this.ownership,
    required this.skinAugments,
    required this.stillObtainable,
  });

  factory Chroma.fromJson(Map<String, dynamic> json) {
    return Chroma(
      championId: json['championId'] ?? 0,
      chromaPath: json['chromaPath'] ?? '',
      colors: List<String>.from(json['colors'] ?? []),
      disabled: json['disabled'] ?? false,
      id: json['id'] ?? 0,
      lastSelected: json['lastSelected'] ?? false,
      name: json['name'] ?? '',
      ownership: Ownership.fromJson(json['ownership']),
      skinAugments: SkinAugments.fromJson(json['skinAugments']),
      stillObtainable: json['stillObtainable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'championId': championId,
      'chromaPath': chromaPath,
      'colors': colors,
      'disabled': disabled,
      'id': id,
      'lastSelected': lastSelected,
      'name': name,
      'ownership': ownership.toJson(),
      'skinAugments': skinAugments.toJson(),
      'stillObtainable': stillObtainable,
    };
  }
}
