import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:league_better_client/api/betterClientApi.dart';
import 'package:league_better_client/api/exports.dart';
import 'package:league_better_client/api/websockets/apiWebSocket.dart';
import 'package:league_better_client/events/champSelectEvents.dart';
import 'package:league_better_client/events/events.dart';
import 'package:league_better_client/models/ChampSelect.dart' as cs;
import 'package:league_better_client/models/ChampSelectChampion.dart';
import 'package:league_better_client/models/Champion.dart';

class ChampSelectPage extends StatefulWidget {
  const ChampSelectPage({super.key});

  @override
  State<ChampSelectPage> createState() => _ChampSelectPageState();
}

class _ChampSelectPageState extends State<ChampSelectPage> {
  List<ChampSelectChampion> selectableChampions = [];
  late cs.ChampSelect? champSelect = null;
  final LcuWebSocketClient _champSelectWebSocket = LcuWebSocketClient();
  String search = '';
  ChampSelectChampion? selected;

  @override
  void initState() {
    super.initState();
    initWebSocket();
    getChampSelectChampions();
  }

  Future<void> getChampSelectChampions() async {
    final champs = await BetterClientApi().getChampSelectChampions();
    for (var champ in champs) {
      await champ.loadImage();
    }
    setState(() {
      selectableChampions = champs;
    });
  }

  void applyAction() {
    for (var actions in champSelect!.actions) {
      for (var action in actions) {
        switch (action.type) {
          case cs.ActionType.ban:
            print("Ban action");
          case cs.ActionType.pick:
            print("Pick action");
        }
      }
    }
  }

  Future<void> initWebSocket() async {
    await _champSelectWebSocket.connect(
      "OnJsonApiEvent_lol-champ-select_v1_session",
    );
    _champSelectWebSocket.listen((event) {
      eventBus.fire(ChampSelectStartEvent());
      final allEventData = jsonDecode(event);
      final eventData = allEventData[2];
      final data = eventData["data"];
      final eventType = eventData["eventType"];
      final uri = eventData["uri"];
      if (eventType == "Delete") {
        eventBus.fire(ChampSelectEndEvent());
      }
      if (eventType == "Update") {
        var champSelect = cs.ChampSelect.fromJson(data);
        setState(() {
          this.champSelect = champSelect;
        });
        applyAction();
      }
    });
  }

  String getCurrentState() {
    if (champSelect == null) {
      return "";
    }
    if (champSelect!.actions.last[0].type == cs.ActionType.ban && champSelect!.actions.last[0].completed == false) {
      return "Ban";
    } else if (champSelect!.actions.last[0].type == cs.ActionType.pick && champSelect!.actions.last[0].completed == false) {
      return "Pick";
    }
    return "Waiting for other players";
  }

  @override
  Widget build(BuildContext context) {
      final filtered =
        selectableChampions
            .where((c) => c.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
      filtered.sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 40),
          // Title + Timer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${getCurrentState()} a champion",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(width: 16),
              // Add your own timer logic
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 800,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onChanged: (value) => setState(() => search = value),
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Champions Grid
          SizedBox(
            width: 800,
            height: 500, // or whatever fixed width you want
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 50,
                crossAxisSpacing: 50,
                childAspectRatio: 0.9,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final champ = filtered[index];
                return GestureDetector(
                  onTap: () => setState(() => selected = champ),
                  child: Image(
                    image: champ.image.image,
                    width: 10,
                    height: 10,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          // Lock In Button
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[900],
            child: ElevatedButton(
              onPressed: selected != null ? () => doAction(selected!) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selected != null ? Colors.green : Colors.grey,
              ),
              child: Text("${getCurrentState()} ${selected?.name ?? ''}"),
            ),
          ),
        ],
      ),
    );
  }

  void doAction(ChampSelectChampion champ) {
    var newAction = cs.Action(
      id: champSelect!.actions.last[0].id,
      actorCellId: champSelect!.actions.last[0].actorCellId,
      championId: champ.id,
      completed: true,
      isAllyAction: champSelect!.actions.last[0].isAllyAction,
      isInProgress: champSelect!.actions.last[0].isInProgress,
      type: cs.ActionType.pick,
      pickTurn: champSelect!.actions.last[0].pickTurn,
    );
    BetterClientApi().patchAction(
      champSelect!.actions.last[0],
      newAction,
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${champ.name} ${getCurrentState()}ed!')));
  }
}
