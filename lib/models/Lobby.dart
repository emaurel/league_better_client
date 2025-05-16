import 'package:flutter/foundation.dart';
import 'package:league_better_client/models/GameConfig.dart';
import 'package:league_better_client/models/Invitation.dart';
import 'package:league_better_client/models/LobbyMember.dart';
import 'package:league_better_client/models/MucJwtDto.dart';
import 'package:league_better_client/models/Queue.dart';
import 'package:league_better_client/models/Summoner.dart';

class Lobby {
  final bool canStartActivity;
  final GameConfig gameConfig;
  final List<Invitation> invitations;
  final Member localMember;
  final List<Member> members;
  final MucJwtDto mucJwtDto;
  final String multiUserChatId;
  final String multiUserChatPassword;
  final String partyId;
  final String partyType;
  final List<dynamic> popularChampions;
  final List<dynamic> restrictions;
  final List<String> scarcePositions;
  final List<dynamic> warnings;

  late List<Summoner> summoners = [];
  late Queue? queue = null;
  late String name = "Lobby";

  Lobby({
    required this.canStartActivity,
    required this.gameConfig,
    required this.invitations,
    required this.localMember,
    required this.members,
    required this.mucJwtDto,
    required this.multiUserChatId,
    required this.multiUserChatPassword,
    required this.partyId,
    required this.partyType,
    required this.popularChampions,
    required this.restrictions,
    required this.scarcePositions,
    required this.warnings,
  });

  factory Lobby.fromJson(Map<String, dynamic> json) {
    var res = Lobby(
      canStartActivity: json['canStartActivity'],
      gameConfig: GameConfig.fromJson(json['gameConfig']),
      invitations: List<Invitation>.from(
        json['invitations'].map((x) => Invitation.fromJson(x)),
      ),
      localMember: Member.fromJson(json['localMember']),
      members: List<Member>.from(
        json['members'].map((x) => Member.fromJson(x)),
      ),
      mucJwtDto: MucJwtDto.fromJson(json['mucJwtDto']),
      multiUserChatId: json['multiUserChatId'],
      multiUserChatPassword: json['multiUserChatPassword'],
      partyId: json['partyId'],
      partyType: json['partyType'],
      popularChampions: json['popularChampions'],
      restrictions: (json['restrictions'] ?? []),
      scarcePositions: List<String>.from(json['scarcePositions']),
      warnings: json['warnings'],
    );
    res.name = "${res.gameConfig.mapName} - ${res.gameConfig.gameMode} - ${res.partyType} (${res.members.length}/${res.gameConfig.maxLobbySize})";
    return res;
  }

  void updateName() {
    name = "${gameConfig.mapName}, ${gameConfig.gameMode}";
    if (queue != null) {
      name += queue!.isRanked ? " - Ranked" : " - Normal";
    }
    name += "(${members.length}/${gameConfig.maxLobbySize})";
  }

  Map<String, dynamic> toJson() {
    return {
      'canStartActivity': canStartActivity,
      'gameConfig': gameConfig.toJson(),
      'invitations': List<dynamic>.from(invitations.map((x) => x.toJson())),
      'localMember': localMember.toJson(),
      'members': List<dynamic>.from(members.map((x) => x.toJson())),
      'multiUserChatId': multiUserChatId,
      'multiUserChatPassword': multiUserChatPassword,
      'partyId': partyId,
      'partyType': partyType,
      'popularChampions': popularChampions,
      'restrictions': restrictions,
      'scarcePositions': scarcePositions,
      'warnings': warnings,
    };
  }

  @override
  bool operator ==(Object other) {
    bool isLobby = other is Lobby;
    if (!isLobby) return false;
    bool isSameParty = other.partyId == partyId;
    if (!isSameParty) return false;
    bool isSameMembers = other.members.length == members.length;
    if (!isSameMembers) return false;
    for (int i = 0; i < members.length; i++) {
      if (other.members[i] != members[i]) {
        return false;
      }
    }
    bool isSameConfig = other.gameConfig == gameConfig;
    if (!isSameConfig) return false;
    bool isSamePartyType = other.partyType == partyType;
    if (!isSamePartyType) return false;
    return true;
  }

  @override
  int get hashCode => Object.hash(partyId, partyType, members);
}
