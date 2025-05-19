import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:league_better_client/api/betterClientApi.dart';
import 'package:league_better_client/api/exports.dart';
import 'package:league_better_client/events/events.dart';
import 'package:league_better_client/events/friendEvents.dart';
import 'package:league_better_client/events/lobbyEvents.dart';
import 'package:league_better_client/models/Queue.dart';

class FriendInfo {
  String bannerIdSelected;
  String challengeCrystalLevel;
  String challengePoints;
  String challengeTokensSelected;
  String championId;
  String companionId;
  String damageSkinId;
  String gameId;
  String gameMode;
  String gameQueueType;
  String gameStatus;
  String iconOverride;
  String isObservable;
  String legendaryMasteryScore;
  String level;
  String mapId;
  String mapSkinId;
  String playerTitleSelected;
  String profileIcon;
  String? pty;
  String puuid;
  String queueId;
  String rankedLeagueDivision;
  String rankedLeagueQueue;
  String rankedLeagueTier;
  String rankedLosses;
  String rankedPrevSeasonDivision;
  String rankedPrevSeasonTier;
  String rankedSplitRewardLevel;
  String rankedWins;
  String regalia;
  String skinVariant;
  String skinname;
  String timeStamp;

  String partyId = '';
  int partyMaxPlayer = 0;
  int partyNbPlayers = 0;
  List<int> summoners = [];

  Queue? gameQueue;

  FriendInfo({
    required this.bannerIdSelected,
    required this.challengeCrystalLevel,
    required this.challengePoints,
    required this.challengeTokensSelected,
    required this.championId,
    required this.companionId,
    required this.damageSkinId,
    required this.gameId,
    required this.gameMode,
    required this.gameQueueType,
    required this.gameStatus,
    required this.iconOverride,
    required this.isObservable,
    required this.legendaryMasteryScore,
    required this.level,
    required this.mapId,
    required this.mapSkinId,
    required this.playerTitleSelected,
    required this.profileIcon,
    required this.pty,
    required this.puuid,
    required this.queueId,
    required this.rankedLeagueDivision,
    required this.rankedLeagueQueue,
    required this.rankedLeagueTier,
    required this.rankedLosses,
    required this.rankedPrevSeasonDivision,
    required this.rankedPrevSeasonTier,
    required this.rankedSplitRewardLevel,
    required this.rankedWins,
    required this.regalia,
    required this.skinVariant,
    required this.skinname,
    required this.timeStamp,
  });

  factory FriendInfo.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return FriendInfo(
        bannerIdSelected: '',
        challengeCrystalLevel: '',
        challengePoints: '',
        challengeTokensSelected: '',
        championId: '',
        companionId: '',
        damageSkinId: '',
        gameId: '',
        gameMode: '',
        gameQueueType: '',
        gameStatus: '',
        iconOverride: '',
        isObservable: '',
        legendaryMasteryScore: '',
        level: '',
        mapId: '',
        mapSkinId: '',
        playerTitleSelected: '',
        profileIcon: '',
        pty: '',
        puuid: '',
        queueId: '',
        rankedLeagueDivision: '',
        rankedLeagueQueue: '',
        rankedLeagueTier: '',
        rankedLosses: '0',
        rankedPrevSeasonDivision: '0',
        rankedPrevSeasonTier: '0',
        rankedSplitRewardLevel: '0',
        rankedWins: '0',
        regalia: '0',
        skinVariant: '0',
        skinname: '0',
        timeStamp: '0',
      );
    }
    var res = FriendInfo(
      bannerIdSelected: (json['bannerIdSelected'] ?? "") as String,
      challengeCrystalLevel: (json['challengeCrystalLevel'] ?? "") as String,
      challengePoints: (json['challengePoints'] ?? "") as String,
      challengeTokensSelected:
          (json['challengeTokensSelected'] ?? "") as String,
      championId: (json['championId'] ?? "") as String,
      companionId: (json['companionId'] ?? "") as String,
      damageSkinId: (json['damageSkinId'] ?? "") as String,
      gameId: (json['gameId'] ?? "") as String,
      gameMode: (json['gameMode'] ?? "") as String,
      gameQueueType: (json['gameQueueType'] ?? "") as String,
      gameStatus: (json['gameStatus'] ?? "") as String,
      iconOverride: (json['iconOverride'] ?? "") as String,
      isObservable: (json['isObservable'] ?? "") as String,
      legendaryMasteryScore: (json['legendaryMasteryScore'] ?? "") as String,
      level: (json['level'] ?? "") as String,
      mapId: (json['mapId'] ?? "") as String,
      mapSkinId: (json['mapSkinId'] ?? "") as String,
      playerTitleSelected: (json['playerTitleSelected'] ?? "") as String,
      profileIcon: (json['profileIcon'] ?? "") as String,
      pty: (json['pty'] ?? '') as String,
      puuid: (json['puuid'] ?? "") as String,
      queueId: (json['queueId'] ?? "") as String,
      rankedLeagueDivision: (json['rankedLeagueDivision'] ?? "") as String,
      rankedLeagueQueue: (json['rankedLeagueQueue'] ?? "") as String,
      rankedLeagueTier: (json['rankedLeagueTier'] ?? "") as String,
      rankedLosses: (json['rankedLosses'] ?? "") as String,
      rankedPrevSeasonDivision:
          (json["rankedPrevSeasonDivision"] ?? '') as String,
      rankedPrevSeasonTier: (json["rankedPrevSeasonTier"] ?? '') as String,
      rankedSplitRewardLevel: (json["rankedSplitRewardLevel"] ?? '') as String,
      rankedWins: (json["rankedWins"] ?? '') as String,
      regalia: (json["regalia"] ?? '') as String,
      skinVariant: (json["skinVariant"] ?? '') as String,
      skinname: (json["skinname"] ?? '') as String,
      timeStamp: (json["timeStamp"] ?? '') as String,
    );
    if (res.pty != "") {
      var ptyJson = jsonDecode(res.pty!);
      res.partyMaxPlayer = (ptyJson['maxPlayers'] ?? 0);
      res.partyNbPlayers = (ptyJson['summoners'] ?? []).length;
      res.summoners = List<int>.from((ptyJson['summoners']) ?? []);
      res.partyId = ptyJson['partyId'] ?? '';
    }

    return res;
  }

  Map<String, dynamic> toJson() {
    return {
      'bannerIdSelected': bannerIdSelected,
      'challengeCrystalLevel': challengeCrystalLevel,
      'challengePoints': challengePoints,
      'challengeTokensSelected': challengeTokensSelected,
      'championId': championId,
      'companionId': companionId,
      'damageSkinId': damageSkinId,
      'gameId': gameId,
      'gameMode': gameMode,
      'gameQueueType': gameQueueType,
      'gameStatus': gameStatus,
      'iconOverride': iconOverride,
      'isObservable': isObservable,
      'legendaryMasteryScore': legendaryMasteryScore,
      'level': level,
      'mapId': mapId,
      'mapSkinId': mapSkinId,
      'playerTitleSelected': playerTitleSelected,
      'profileIcon': profileIcon,
      'pty': pty,
      'puuid': puuid,
      'queueId': queueId,
      'rankedLeagueDivision': rankedLeagueDivision,
      'rankedLeagueQueue': rankedLeagueQueue,
      'rankedLeagueTier': rankedLeagueTier,
      'rankedLosses': rankedLosses,
      'rankedPrevSeasonDivision': rankedPrevSeasonDivision,
      'rankedPrevSeasonTier': rankedPrevSeasonTier,
      'rankedSplitRewardLevel': rankedSplitRewardLevel,
      'rankedWins': rankedWins,
      'regalia': regalia,
      'skinVariant': skinVariant,
      'skinname': skinname,
      'timeStamp': timeStamp,
      'partyId': partyId,
      'partyMaxPlayer': partyMaxPlayer,
      'partyNbPlayers': partyNbPlayers,
      'summoners': summoners,
      'gameQueue': gameQueue?.toJson(),
    };
  }
}

class Friend {
  String availability;
  int displayGroupId;
  String displayGroupName;
  String gameName;
  String gameTag;
  int groupId;
  String groupName;
  int icon;
  String id;
  bool isP2PConversationMuted;
  String? lastSeenOnlineTimestamp;
  FriendInfo lol;
  String name;
  String note;
  String patchline;
  String pid;
  String platformId;
  String product;
  String productName;
  String puuid;
  String statusMessage;
  String summary;
  int summonerId;
  int time;

  late String availabilityText = availability;

  late Image summonerIcon = Image.asset(
    'assets/placeholder.png',
    width: 50,
    height: 50,
  );

  Friend({
    required this.availability,
    required this.displayGroupId,
    required this.displayGroupName,
    required this.gameName,
    required this.gameTag,
    required this.groupId,
    required this.groupName,
    required this.icon,
    required this.id,
    required this.isP2PConversationMuted,
    this.lastSeenOnlineTimestamp,
    required this.lol,
    required this.name,
    required this.note,
    required this.patchline,
    required this.pid,
    required this.platformId,
    required this.product,
    required this.productName,
    required this.puuid,
    required this.statusMessage,
    required this.summary,
    required this.summonerId,
    required this.time,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    var res = Friend(
      availability: json['availability'] as String,
      displayGroupId: json['displayGroupId'] as int,
      displayGroupName: json['displayGroupName'] as String,
      gameName: json['gameName'] as String,
      gameTag: json['gameTag'] as String,
      groupId: json['groupId'] as int,
      groupName: json['groupName'] as String,
      icon: json['icon'] as int,
      id: json['id'] as String,
      isP2PConversationMuted: json['isP2PConversationMuted'] as bool,
      lastSeenOnlineTimestamp:
          (json["lastSeenOnlineTimestamp"] ?? '') as String?,
      lol: FriendInfo.fromJson(json['lol'] ?? {}),
      name: json['name'] as String,
      note: (json["note"] ?? '') as String,
      patchline: (json["patchline"] ?? '') as String,
      pid: (json["pid"] ?? '') as String,
      platformId: (json["platformId"] ?? '') as String,
      product: (json["product"] ?? '') as String,
      productName: (json["productName"] ?? '') as String,
      puuid: (json["puuid"] ?? '') as String,
      statusMessage: (json["statusMessage"] ?? '') as String,
      summary: (json["summary"] ?? '') as String,
      summonerId: (json["summonerId"] ?? 0) as int,
      time: (json["time"] ?? 0) as int,
    );
    if (res.lol.gameStatus == 'inGame' ||
        res.lol.gameStatus == 'championSelect') {
      res.availability = res.lol.gameStatus; // In Game
    }
    return res;
  }

  Future<void> loadImages() async {
    summonerIcon = await BetterClientApi.instance.getProfileIcon(
      icon.toString(),
    );
    summonerIcon = Image(image: summonerIcon.image, width: 50, height: 50);
  }

  Future<void> loadGameQueue() async {
    if (lol.pty != "") {
      try {
        var queue = await BetterClientApi.instance.getQueue(lol.queueId);
        lol.gameQueue = queue;
      } catch (e) {
        print("Error loading game queue: $e");
      }
    }
  }

  Color _getStatusColor() {
    switch (availability) {
      case 'chat': // Online
        return Colors.green;
      case 'dnd': // Do Not Disturb
        return Colors.red;
      case 'away': // Idle
        return Colors.orange;
      case 'inGame':
      case 'championSelect': // In Game
        return Colors.blue;
      case 'offline':
      default:
        return Colors.grey;
    }
  }

  void _setAvailabilityString() {
    switch (availability) {
      case 'chat':
        availabilityText = 'Online';
        break;
      case 'dnd':
        availabilityText = 'Do Not Disturb';
        break;
      case 'away':
        availabilityText = 'Away';
        break;
      case 'inGame':
        availabilityText = 'In Game';
        break;
      case 'championSelect':
        availabilityText = 'In Champion Select';
        break;
      case 'offline':
      default:
        availabilityText = 'Offline';
    }
  }

  Widget draw() {
    var currentColor = _getStatusColor();
    _setAvailabilityString();

    if (lol.partyId != "") {
      var queueName = "queue";
      if (lol.gameQueue != null) {
        queueName = lol.gameQueue!.shortName;
      }
      availabilityText =
          "in $queueName (${lol.partyNbPlayers}/${lol.partyMaxPlayer})";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max, // use full available width
      children: [
        Stack(
          children: [
            ClipOval(
              child: SizedBox(width: 48, height: 48, child: summonerIcon),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: currentColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gameName,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis, // 🟢 truncate with ...
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Text(
              availabilityText,
              style: TextStyle(fontSize: 12, color: currentColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            if (lol.partyId != "" &&
                !lol.summoners.contains(
                  int.parse(BetterClientApi.instance.summonerId!),
                ))
              ElevatedButton(
                onPressed: () {
                  BetterClientApi.instance.joinLobby(lol.partyId);
                  eventBus.fire(JoinLobbyEvent(lol.gameQueue));
                  eventBus.fire(FriendListUpdateEvent());
                },
                child: const Text("Join Party"),
              ),
          ],
        ),

        // 🟢 Flexible Text to prevent overflow
      ],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availability': availability,
      'displayGroupId': displayGroupId,
      'displayGroupName': displayGroupName,
      'gameName': gameName,
      'gameTag': gameTag,
      'groupId': groupId,
      'groupName': groupName,
      'icon': icon,
      'id': id,
      'isP2PConversationMuted': isP2PConversationMuted,
      'lastSeenOnlineTimestamp': lastSeenOnlineTimestamp,
      'lol': lol.toJson(),
      'name': name,
      'note': note,
      'patchline': patchline,
      'pid': pid,
      'platformId': platformId,
      'product': product,
      'productName': productName,
      'puuid': puuid,
      'statusMessage': statusMessage,
      'summary': summary,
      'summonerId': summonerId,
      'time': time,
    };
  }
}
