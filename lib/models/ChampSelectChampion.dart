import 'package:flutter/material.dart';
import 'package:league_better_client/api/exports.dart';

class ChampSelectChampion {
  final bool disabled;
  final bool freeToPlay;
  final bool freeToPlayForQueue;
  final int id;
  final bool loyaltyReward;
  final int masteryLevel;
  final int masteryPoints;
  final String name;
  final bool owned;
  final List<String> positionsFavorited;
  final bool rented;
  final List<String> roles;
  final SelectionStatus selectionStatus;
  final String squarePortraitPath;
  final bool xboxGPReward;

  late Image image;

  ChampSelectChampion({
    required this.disabled,
    required this.freeToPlay,
    required this.freeToPlayForQueue,
    required this.id,
    required this.loyaltyReward,
    required this.masteryLevel,
    required this.masteryPoints,
    required this.name,
    required this.owned,
    required this.positionsFavorited,
    required this.rented,
    required this.roles,
    required this.selectionStatus,
    required this.squarePortraitPath,
    required this.xboxGPReward,
  });

  factory ChampSelectChampion.fromJson(Map<String, dynamic> json) {
    return ChampSelectChampion(
      disabled: json['disabled'],
      freeToPlay: json['freeToPlay'],
      freeToPlayForQueue: json['freeToPlayForQueue'],
      id: json['id'],
      loyaltyReward: json['loyaltyReward'],
      masteryLevel: json['masteryLevel'],
      masteryPoints: json['masteryPoints'],
      name: json['name'],
      owned: json['owned'],
      positionsFavorited: List<String>.from(json['positionsFavorited']),
      rented: json['rented'],
      roles: List<String>.from(json['roles']),
      selectionStatus: SelectionStatus.fromJson(json['selectionStatus']),
      squarePortraitPath: json['squarePortraitPath'],
      xboxGPReward: json['xboxGPReward'],
    );
  }

  Future<void> loadImage() async {
    image = await BetterClientApi().getImageFromPath(squarePortraitPath);
  }

  Map<String, dynamic> toJson() {
    return {
      'disabled': disabled,
      'freeToPlay': freeToPlay,
      'freeToPlayForQueue': freeToPlayForQueue,
      'id': id,
      'loyaltyReward': loyaltyReward,
      'masteryLevel': masteryLevel,
      'masteryPoints': masteryPoints,
      'name': name,
      'owned': owned,
      'positionsFavorited': positionsFavorited,
      'rented': rented,
      'roles': roles,
      'selectionStatus': selectionStatus.toJson(),
      'squarePortraitPath': squarePortraitPath,
      'xboxGPReward': xboxGPReward,
    };
  }
}

class SelectionStatus {
  final bool banIntented;
  final bool banIntentedByMe;
  final bool isBanned;
  final bool pickIntented;
  final bool pickIntentedByMe;
  final String pickIntentedPosition;
  final bool pickedByOtherOrBanned;
  final bool selectedByMe;

  SelectionStatus({
    required this.banIntented,
    required this.banIntentedByMe,
    required this.isBanned,
    required this.pickIntented,
    required this.pickIntentedByMe,
    required this.pickIntentedPosition,
    required this.pickedByOtherOrBanned,
    required this.selectedByMe,
  });

  factory SelectionStatus.fromJson(Map<String, dynamic> json) {
    return SelectionStatus(
      banIntented: json['banIntented'],
      banIntentedByMe: json['banIntentedByMe'],
      isBanned: json['isBanned'],
      pickIntented: json['pickIntented'],
      pickIntentedByMe: json['pickIntentedByMe'],
      pickIntentedPosition: json['pickIntentedPosition'],
      pickedByOtherOrBanned: json['pickedByOtherOrBanned'],
      selectedByMe: json['selectedByMe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'banIntented': banIntented,
      'banIntentedByMe': banIntentedByMe,
      'isBanned': isBanned,
      'pickIntented': pickIntented,
      'pickIntentedByMe': pickIntentedByMe,
      'pickIntentedPosition': pickIntentedPosition,
      'pickedByOtherOrBanned': pickedByOtherOrBanned,
      'selectedByMe': selectedByMe,
    };
  }
}
