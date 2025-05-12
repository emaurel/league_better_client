import 'package:flutter/widgets.dart';
import 'package:league_better_client/api/betterClientApi.dart';
import 'package:league_better_client/api/extensions/imageService.dart';

class Summoner {
  String accountId;
  String summonerId;
  String gameName;
  String puuid;
  String tagLine;
  String profileIconId;
  String summonerIconUrl = '';
  int summonerLevel;
  int xpSinceLastLevel;
  int xpUntilNextLevel;

  Image summonerIcon = Image.asset(
    'assets/placeholder.png',
    width: 50,
    height: 50,
  );

  Summoner({
    required this.accountId,
    required this.summonerId,
    required this.gameName,
    required this.puuid,
    required this.tagLine,
    required this.profileIconId,
    required this.summonerLevel,
    this.xpSinceLastLevel = 0,
    this.xpUntilNextLevel = 0,
  });

  factory Summoner.fromJson(Map<String, dynamic> json) {
    return Summoner(
      accountId: json['accountId'].toString(),
      summonerId: json['summonerId'].toString(),
      gameName: json['gameName'] as String,
      puuid: json['puuid'] as String,
      tagLine: json['tagLine'] as String,
      profileIconId: json['profileIconId'].toString(),
      summonerLevel: json['summonerLevel'] as int,
      xpSinceLastLevel: json['xpSinceLastLevel'] as int? ?? 0,
      xpUntilNextLevel: json['xpUntilNextLevel'] as int? ?? 0,
    );
  }

  Future<void> loadImages() async {
    summonerIcon = await BetterClientApi.instance.getProfileIcon(profileIconId);
    print("images loaded");
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
}
