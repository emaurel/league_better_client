import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:league_better_client/api/betterClientApi.dart';
import 'package:league_better_client/api/exports.dart';
import 'package:league_better_client/api/extensions/customGameService.dart';
import 'package:league_better_client/api/extensions/matchmakingService.dart';
import 'package:league_better_client/api/extensions/summonerService.dart';
import 'package:league_better_client/api/websockets/apiWebSocket.dart';
import 'package:league_better_client/closeClient.dart';
import 'package:league_better_client/events/champSelectEvents.dart';
import 'package:league_better_client/events/events.dart';
import 'package:league_better_client/events/lobbyEvents.dart';
import 'package:league_better_client/events/matchmakingEvents.dart';
import 'package:league_better_client/models/Lobby.dart';
import 'package:league_better_client/models/LobbyMember.dart';
import 'package:league_better_client/models/MatchmakingSearch.dart';
import 'package:league_better_client/models/Queue.dart';
import 'package:league_better_client/models/Summoner.dart';
import 'package:league_better_client/widgets/summonerWidgets.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({super.key});

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  late StreamSubscription _joinLobbySubscription;

  Lobby? lobby;
  Queue? queue;
  MatchmakingSearch? matchmaking;
  final LcuWebSocketClient _lobbySocketClient = LcuWebSocketClient();

  StreamSubscription<dynamic>? _friendListSocketSubscription;
  @override
  void initState() {
    super.initState();
    _refreshLobby();
    _checkMatchmaking();
    _initLobbySocket();

    _joinLobbySubscription = eventBus.onEvent.listen((event) {
      if (event is LobbyEvent) {
        _refreshLobby();
        if (event is JoinLobbyEvent) {
          setState(() {
            queue = event.queue;
          });
        }
      }
    });
  }

  Future<void> updateLobby(Lobby lobby) async {
    setState(() {
      this.lobby = lobby;
    });
  }

  String getMatchmakingSearchState() {
    if (lobby!.gameConfig.isCustom) {
      return 'Start game';
    }
    if (matchmaking == null) {
      return 'Find game';
    }
    switch (matchmaking!.searchState) {
      case MatchmakingSearchState.searching:
        return 'In queue';
      case MatchmakingSearchState.found:
        return 'Found';
      case MatchmakingSearchState.invalid:
        return 'Find game';
      case MatchmakingSearchState.error:
        return 'Error';
    }
  }

  Future<void> _socketOnLobbyEvent(
    Map<String, dynamic> data,
    String eventType,
  ) async {
    final lobby = Lobby.fromJson(data);
    if (eventType == 'Update') {
      updateLobby(lobby);
    } else if (eventType == 'Delete') {
      eventBus.fire(QuitLobbyEvent());
    } else if (eventType == 'Create') {
      updateLobby(lobby);
    }
  }

  Future<void> _socketOnMatchmakingEvent(
    Map<String, dynamic> data,
    String eventType,
  ) async {
    final matchmaking = MatchmakingSearch.fromJson(data);
    if (eventType == 'Update') {
      setState(() {
        this.matchmaking = matchmaking;
      });
    } else if (eventType == 'Delete') {
      setState(() {
        this.matchmaking = null;
      });
    } else if (eventType == 'Create') {
      setState(() {
        this.matchmaking = matchmaking;
      });
    }
  }

  Future<void> _initLobbySocket() async {
    await _lobbySocketClient.connect('OnJsonApiEvent_lol-lobby_v2_lobby');
    _friendListSocketSubscription = _lobbySocketClient.listen((event) async {
      final allEventData = jsonDecode(event);
      final eventData = allEventData[2];
      minimizeLeagueClient();
      print("babage");

      final data = eventData["data"];
      final eventType = eventData["eventType"];
      final uri = eventData["uri"];
      if (uri == "/lol-lobby/v2/lobby") {
        await _socketOnLobbyEvent(data, eventType);
      }
      if (uri == "/lol-lobby/v2/lobby/matchmaking/search-state") {
        await _socketOnMatchmakingEvent(data, eventType);
      }
    });
  }

  @override
  void dispose() {
    _joinLobbySubscription.cancel();
    _friendListSocketSubscription?.cancel();
    super.dispose();
  }

  void _refreshLobby() async {
    var fetchedLobby = await BetterClientApi.instance.getCurrentLobby();
    if (fetchedLobby == lobby) {
      return;
    }

    setState(() {
      lobby = fetchedLobby;
      if (lobby != null) {
        lobby!.updateName();
      }
    });
    _checkMatchmaking();
  }

  Future<void> quitLobby() async {
    setState(() {
      lobby = null;
    });
    await BetterClientApi.instance.quitLobby();
    eventBus.fire(QuitLobbyEvent());
  }

  final Map<String, Future<Summoner?>> _summonerCache = {};

  Future<Summoner?> fetchSummoner(String id) {
    return _summonerCache.putIfAbsent(id, () async {
      final summoner = await BetterClientApi.instance.getSummonerById(id);
      if (summoner != null) {
        await summoner.loadImages();
      }
      return summoner;
    });
  }

  Future<Lobby?> fetchLobby() async {
    final fetchedLobby = await BetterClientApi.instance.getCurrentLobby();
    return fetchedLobby;
  }

  Future<void> _checkMatchmaking() async {
    print('Checking matchmaking');
    final matchmaking = await BetterClientApi.instance.getMatchmakingSearch();
    if (matchmaking == null) {
      print('no matchmaking');
      eventBus.fire(MatchmakingCancelledEvent());
      return;
    }
    if (matchmaking.searchState == MatchmakingSearchState.searching) {
      eventBus.fire(MatchmakingStartEvent());
    } else if (matchmaking.searchState == MatchmakingSearchState.found) {
      eventBus.fire(MatchmakingFoundEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lobby == null ? 'Lobby' : lobby!.name),
        actions: [
          if (lobby != null)
            IconButton(icon: const Icon(Icons.delete), onPressed: quitLobby),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                lobby == null
                    ? Center(
                      child: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _refreshLobby,
                      ),
                    )
                    : ListView.builder(
                      itemCount: lobby!.members.length,
                      itemBuilder: (context, index) {
                        final summonerId =
                            lobby!.members[index].summonerId.toString();
                        return SummonerLobbyFutureWidget(
                          summonerFuture: fetchSummoner(summonerId),
                          lobbyFuture: fetchLobby(),
                        );
                      },
                    ),
          ),
          //play button
          if (lobby != null && lobby!.localMember.isLeader)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (lobby!.gameConfig.isCustom) {
                    BetterClientApi.instance.startCustomGame();
                    eventBus.fire(ChampSelectStartEvent());
                  } else {
                    BetterClientApi.instance.matchmakingStart();
                  }
                  eventBus.fire(MatchmakingStartEvent());
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 200,
                    vertical: 20,
                  ), // Bigger button
                  textStyle: const TextStyle(fontSize: 50), // Bigger text
                ),
                child: Text((getMatchmakingSearchState())),
              ),
            ),
          if (matchmaking != null &&
              matchmaking!.searchState == MatchmakingSearchState.found)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  BetterClientApi.instance.acceptGame();
                  eventBus.fire(MatchmakingStopEvent());
                  eventBus.fire(ChampSelectStartEvent());
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 200,
                    vertical: 20,
                  ), // Bigger button
                  textStyle: const TextStyle(fontSize: 30), // Bigger text
                ),
                child: const Text('Accept'),
              ),
            ),
          if (matchmaking != null &&
              matchmaking!.searchState == MatchmakingSearchState.found)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  BetterClientApi.instance.declineGame();
                  eventBus.fire(MatchmakingStopEvent());
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 200,
                    vertical: 20,
                  ), // Bigger button
                  textStyle: const TextStyle(fontSize: 30), // Bigger text
                ),
                child: const Text('Decline'),
              ),
            ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centers the buttons horizontally
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(
                  0,
                ), // Ensures no extra padding is applied to the button
                child: IconButton(
                  icon: const Icon(Icons.filter_1),
                  iconSize:
                      40, // Optional: Increase icon size if you need larger buttons
                  onPressed:
                      () => _showChoiceSheet(
                        context,
                        true,
                        lobby != null ? lobby!.localMember : null,
                      ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(
                  0,
                ), // Ensures no extra padding is applied to the button
                child: IconButton(
                  icon: const Icon(Icons.filter_2),
                  iconSize:
                      40, // Optional: Increase icon size if you need larger buttons
                  onPressed:
                      () => _showChoiceSheet(
                        context,
                        false,
                        lobby != null ? lobby!.localMember : null,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to display the bottom sheet with 5 widget options
  void _showChoiceSheet(BuildContext context, bool isFirst, Member? member) {
    List<String> options = ['Top', 'Jungle', 'Mid', 'ADC', 'Support'];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 300, // Set height for the bottom sheet
          child: Column(
            children: [
              Text(
                "Choose an action",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(options[index]),
                    onTap: () {
                      if (member == null) {
                        return;
                      }
                      _handleChoice(index, isFirst, member);
                      Navigator.pop(context); // Close the bottom sheet
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to handle the choice made by the user
  void _handleChoice(int index, bool isFirst, Member member) async {
    switch (index) {
      case 0:
        await BetterClientApi.instance.setRole("TOP", isFirst, member);
        eventBus.fire(LocalRoleChangeEvent());
        break;
      case 1:
        await BetterClientApi.instance.setRole("JUNGLE", isFirst, member);
        eventBus.fire(LocalRoleChangeEvent());
        break;
      case 2:
        await BetterClientApi.instance.setRole("MIDDLE", isFirst, member);
        eventBus.fire(LocalRoleChangeEvent());
        break;
      case 3:
        await BetterClientApi.instance.setRole("BOTTOM", isFirst, member);
        eventBus.fire(LocalRoleChangeEvent());
        break;
      case 4:
        await BetterClientApi.instance.setRole("UTILITY", isFirst, member);
        eventBus.fire(LocalRoleChangeEvent());
        break;
    }
  }
}
