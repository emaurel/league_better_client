
import 'Skin.dart';

class QuestSkinInfo {
  String collectionCardPath;
  String collectionDescription;
  List<String> descriptionInfo;
  String name;
  String? productType;
  String splashPath;
  List<Skin> tiers;
  String tilePath;
  String incenteredSplashPath;

  QuestSkinInfo({
    required this.collectionCardPath,
    required this.collectionDescription,
    required this.descriptionInfo,
    required this.name,
    required this.productType,
    required this.splashPath,
    required this.tiers,
    required this.tilePath,
    required this.incenteredSplashPath,
  });

  factory QuestSkinInfo.fromJson(Map<String, dynamic> json) {
    return QuestSkinInfo(
      collectionCardPath: json['collectionCardPath'] ?? '',
      collectionDescription: json['collectionDescription'] ?? '',
      descriptionInfo: List<String>.from(json['descriptionInfo'] ?? []),
      name: json['name'] ?? '',
      productType: json['productType'] ?? '',
      splashPath: json['splashPath'] ?? '',
      tiers: (json['tiers'] as List<dynamic>)
          .map((tier) => Skin.fromJson(tier))
          .toList(),
      tilePath: json['tilePath'] ?? '',
      incenteredSplashPath: json['incenteredSplashPath'] ?? '',
    );
  }
}