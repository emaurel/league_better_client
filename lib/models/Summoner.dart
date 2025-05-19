import 'package:flutter/widgets.dart';
import 'package:league_better_client/api/betterClientApi.dart';
import 'package:league_better_client/api/extensions/imageService.dart';
import 'package:league_better_client/models/RerollPoints.dart';

class Summoner {
  int accountId;
  String displayName;
  String gameName;
  String internalName;
  bool nameChangeFlag;
  int percentCompleteForNextLevel;
  String privacy;
  int profileIconId;
  String puuid;
  RerollPoints rerollPoints;
  int summonerId;
  int summonerLevel;
  String tagLine;
  bool unnamed;
  int xpSinceLastLevel;
  int xpUntilNextLevel;

  Image summonerIcon = Image.asset(
    'assets/placeholder.png',
    width: 50,
    height: 50,
  );

  Summoner({
    required this.accountId,
    required this.displayName,
    required this.gameName,
    required this.internalName,
    required this.nameChangeFlag,
    required this.percentCompleteForNextLevel,
    required this.privacy,
    required this.profileIconId,
    required this.puuid,
    required this.rerollPoints,
    required this.summonerId,
    required this.summonerLevel,
    required this.tagLine,
    required this.unnamed,
    required this.xpSinceLastLevel,
    required this.xpUntilNextLevel,
  });

  factory Summoner.fromJson(Map<String, dynamic> json) {
    return Summoner(
      accountId: json['accountId'],
      displayName: json['displayName'],
      gameName: json['gameName'],
      internalName: json['internalName'],
      nameChangeFlag: json['nameChangeFlag'],
      percentCompleteForNextLevel: json['percentCompleteForNextLevel'],
      privacy: json['privacy'],
      profileIconId: json['profileIconId'],
      puuid: json['puuid'],
      rerollPoints: RerollPoints.fromJson(json['rerollPoints']),
      summonerId: json['summonerId'],
      summonerLevel: json['summonerLevel'],
      tagLine: json['tagLine'],
      unnamed: json['unnamed'],
      xpSinceLastLevel: json['xpSinceLastLevel'],
      xpUntilNextLevel: json['xpUntilNextLevel'],
    );
  }

  factory Summoner.empty() {
    return Summoner(
      accountId: 0,
      displayName: '',
      gameName: '',
      internalName: '',
      nameChangeFlag: false,
      percentCompleteForNextLevel: 0,
      privacy: 'PUBLIC',
      profileIconId: 0,
      puuid: '',
      rerollPoints: RerollPoints.empty(),
      summonerId: 0,
      summonerLevel: 0,
      tagLine: '',
      unnamed: true,
      xpSinceLastLevel: 0,
      xpUntilNextLevel: 0,
    );
  }

  Future<void> loadImages() async {
    summonerIcon = await BetterClientApi.instance.getProfileIcon(
      profileIconId.toString(),
    );
    summonerIcon = Image(image: summonerIcon.image, width: 50, height: 50);
  }

  Widget draw() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(child: SizedBox(width: 64, height: 64, child: summonerIcon)),
        const SizedBox(width: 16),
        Text('$gameName#$tagLine', style: const TextStyle(fontSize: 20)),
      ],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'displayName': displayName,
      'gameName': gameName,
      'internalName': internalName,
      'nameChangeFlag': nameChangeFlag,
      'percentCompleteForNextLevel': percentCompleteForNextLevel,
      'privacy': privacy,
      'profileIconId': profileIconId,
      'puuid': puuid,
      'rerollPoints': rerollPoints.toJson(),
      'summonerId': summonerId,
      'summonerLevel': summonerLevel,
      'tagLine': tagLine,
      'unnamed': unnamed,
      'xpSinceLastLevel': xpSinceLastLevel,
      'xpUntilNextLevel': xpUntilNextLevel,
    };
  }
}
