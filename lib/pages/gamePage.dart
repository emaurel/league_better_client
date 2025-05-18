import 'dart:async';

import 'package:flutter/material.dart';
import 'package:league_better_client/api/betterClientApi.dart';
import 'package:league_better_client/api/extensions/championService.dart';
import 'package:league_better_client/events/champSelectEvents.dart';
import 'package:league_better_client/events/events.dart';
import 'package:league_better_client/models/Champion.dart';
import 'package:league_better_client/pages/chamSelectPage.dart';
import 'package:league_better_client/pages/lobbyPage.dart';

class GamePage extends StatefulWidget {

  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool isChampSelect = false;
  final LobbyPage lobbyPage = const LobbyPage();
  final ChampSelectPage champSelectPage = const ChampSelectPage();
  late StreamSubscription _gameStateSubscription;

  _GamePageState();

  @override
  void initState() {
    super.initState();
    checkGameStatus();
  }

  Future<void> checkGameStatus() async {
    _gameStateSubscription = eventBus.onEvent.listen((event) {
      if (event is ChampSelectStartEvent) {
        setState(() {
          isChampSelect = true;
        });
      } if (event is ChampSelectEndEvent) {
        setState(() {
          isChampSelect = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _gameStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isChampSelect) Expanded(child: champSelectPage),
        if (!isChampSelect) Expanded(child: lobbyPage),
      ],
    );
  }
}
