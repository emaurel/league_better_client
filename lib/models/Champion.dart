import 'package:flutter/material.dart';
import 'package:league_better_client/api/betterClientApi.dart';
import 'package:league_better_client/api/extensions/imageService.dart';

import 'Skin.dart';
import 'Ownership.dart';
import 'Spell.dart';
import 'TacticalInfo.dart';

BetterClientApi client = BetterClientApi();

class Champion {
  bool active;
  String alias;
  String banVoPath;
  String baseLoadScreenPath;
  String baseSplashPath;
  bool botEnabled;
  String chooseVoPath;
  List<String> disabledQueues;
  bool freeToPlay;
  int id;
  String name;
  Ownership ownership;
  Spell passive;
  int purchased;
  bool rankedPlayEnabled;
  List<String> roles;
  List<Skin> skins;
  List<Spell> spells;
  String squarePortraitPath;
  String stingerSfxPath;
  TacticalInfo tacticalInfo;
  String title;

  late Image baseLoadScreen;
  late Image baseSplash;
  late Image squarePortrait;

  Champion({
    required this.active,
    required this.alias,
    required this.banVoPath,
    required this.baseLoadScreenPath,
    required this.baseSplashPath,
    required this.botEnabled,
    required this.chooseVoPath,
    required this.disabledQueues,
    required this.freeToPlay,
    required this.id,
    required this.name,
    required this.ownership,
    required this.passive,
    required this.purchased,
    required this.rankedPlayEnabled,
    required this.roles,
    required this.skins,
    required this.spells,
    required this.squarePortraitPath,
    required this.stingerSfxPath,
    required this.tacticalInfo,
    required this.title,
  });

  factory Champion.fromJson(Map<String, dynamic> json) {
    return Champion(
      active: json['active'],
      alias: json['alias'],
      banVoPath: json['banVoPath'],
      baseLoadScreenPath: json['baseLoadScreenPath'],
      baseSplashPath: json['baseSplashPath'],
      botEnabled: json['botEnabled'],
      chooseVoPath: json['chooseVoPath'],
      disabledQueues: List<String>.from(json['disabledQueues']),
      freeToPlay: json['freeToPlay'],
      id: json['id'],
      name: json['name'],
      ownership: Ownership.fromJson(json['ownership']),
      passive: Spell.fromJson(json['passive']),
      purchased: json['purchased'],
      rankedPlayEnabled: json['rankedPlayEnabled'],
      roles: List<String>.from(json['roles']),
      skins: (json['skins'] as List).map((e) => Skin.fromJson(e)).toList(),
      spells: (json['spells'] as List).map((e) => Spell.fromJson(e)).toList(),
      squarePortraitPath: json['squarePortraitPath'],
      stingerSfxPath: json['stingerSfxPath'],
      tacticalInfo: TacticalInfo.fromJson(json['tacticalInfo']),
      title: json['title'],
    );
  }

  Future<void> loadImages() async {
    baseLoadScreen = await client.getImageFromPath(baseLoadScreenPath);
    baseSplash = await client.getImageFromPath(baseSplashPath);
    squarePortrait = await client.getImageFromPath(squarePortraitPath);
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'alias': alias,
      'banVoPath': banVoPath,
      'baseLoadScreenPath': baseLoadScreenPath,
      'baseSplashPath': baseSplashPath,
      'botEnabled': botEnabled,
      'chooseVoPath': chooseVoPath,
      'disabledQueues': disabledQueues,
      'freeToPlay': freeToPlay,
      'id': id,
      'name': name,
      'ownership': ownership.toJson(),
      'passive': passive.toJson(),
      'purchased': purchased,
      'rankedPlayEnabled': rankedPlayEnabled,
      'roles': roles,
      'skins': skins.map((e) => e.toJson()).toList(),
      'spells': spells.map((e) => e.toJson()).toList(),
      'squarePortraitPath': squarePortraitPath,
      'stingerSfxPath': stingerSfxPath,
      'tacticalInfo': tacticalInfo.toJson(),
      'title': title,
    };
  }
}
