import 'package:league_better_client/models/SkinAugments.dart';

import 'Chroma.dart';
import 'Ownership.dart';

class Skin {
  int championId;
  String? chromasPath;
  List<Chroma> chromas;
  String? collectionSplashPath;
  bool disabled;
  List<String> emblems;
  String? featuresText;
  int id;
  bool isBase;
  bool lastSelected;
  String loadScreenPath;
  String name;
  Ownership ownership;
  //QuestSkinInfo? questSkinInfo;
  SkinAugments skinAugments;
  String splashPath;
  String? splashVideoPath;
  bool stillOptainable;
  String tilePath;
  String uncensoredSplashPath;

  Skin({
    required this.championId,
    required this.chromasPath,
    required this.chromas,
    required this.collectionSplashPath,
    required this.disabled,
    required this.emblems,
    required this.featuresText,
    required this.id,
    required this.isBase,
    required this.lastSelected,
    required this.loadScreenPath,
    required this.name,
    required this.ownership,
    //required this.questSkinInfo,
    required this.skinAugments,
    required this.splashPath,
    required this.splashVideoPath,
    required this.stillOptainable,
    required this.tilePath,
    required this.uncensoredSplashPath,
  });

  factory Skin.fromJson(Map<String, dynamic> json) {
    return Skin(
      championId: json['championId'] ?? 0,
      chromasPath: json['chromasPath'] ?? '',
      chromas: List<Chroma>.from(
        json['chromas']?.map((x) => Chroma.fromJson(x)) ?? [],
      ),
      collectionSplashPath: json['collectionSplashPath'] ?? '',
      disabled: json['disabled'] ?? false,
      emblems: List<String>.from(json['emblems'] ?? []),
      featuresText: json['featuresText'] ?? '',
      id: json['id'] ?? 0,
      isBase: json['isBase'] ?? false,
      lastSelected: json['lastSelected'] ?? false,
      loadScreenPath: json['loadScreenPath'] ?? '',
      name: json['name'] ?? '',
      ownership: Ownership.fromJson(json['ownership']),
      //questSkinInfo: QuestSkinInfo.fromJson(json['questSkinInfo']),
      skinAugments: SkinAugments.fromJson(json['skinAugments']),
      splashPath: json['splashPath'] ?? '',
      splashVideoPath: json['splashVideoPath'] ?? '',
      stillOptainable: json['stillOptainable'] ?? false,
      tilePath: json['tilePath'] ?? '',
      uncensoredSplashPath: json['uncensoredSplashPath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'championId': championId,
      'chromasPath': chromasPath,
      'chromas': chromas.map((c) => c.toJson()).toList(),
      'collectionSplashPath': collectionSplashPath,
      'disabled': disabled,
      'emblems': emblems,
      'featuresText': featuresText,
      'id': id,
      'isBase': isBase,
      'lastSelected': lastSelected,
      'loadScreenPath': loadScreenPath,
      'name': name,
      'ownership': ownership.toJson(),
      'skinAugments': skinAugments.toJson(),
      'splashPath': splashPath,
      'splashVideoPath': splashVideoPath,
      'stillOptainable': stillOptainable,
      'tilePath': tilePath,
      'uncensoredSplashPath': uncensoredSplashPath,
    };
  }
}
