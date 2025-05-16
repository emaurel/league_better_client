import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:league_better_client/api/exports.dart';
import 'package:league_better_client/models/Lobby.dart';
import 'package:league_better_client/models/LobbyMember.dart';
import 'package:league_better_client/models/Summoner.dart';
import 'package:league_better_client/widgets/iconWidget.dart';

class SummonerLobbyFutureWidget extends StatelessWidget {
  final Future<Summoner?> summonerFuture;
  final Future<Lobby?> lobbyFuture;

  const SummonerLobbyFutureWidget({
    super.key,
    required this.summonerFuture,
    required this.lobbyFuture,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([summonerFuture, lobbyFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          _emptySummonerDisplay();
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data found'));
        }

        final Summoner? summoner = snapshot.data![0] as Summoner?;
        final Lobby? lobby = snapshot.data![1] as Lobby?;

        if (summoner == null || lobby == null) {
          return const Center(child: Text('Data unavailable'));
        }

        final Member member = lobby.members.firstWhere(
          (member) => member.summonerId == summoner.summonerId,
          orElse: () => lobby.localMember,
        );

        return _defaultSummonerDisplay(summoner, member);
      },
    );
  }

  static Widget _emptySummonerDisplay() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        leading: const Icon(Icons.account_circle),
        title: Text('No Summoner Data'),
        subtitle: Text('Level '),
        trailing: Text('XP: '),
      ),
    );
  }

  static Widget _defaultSummonerDisplay(Summoner summoner, Member member) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: summoner.summonerIcon.image,
          backgroundColor: Colors.transparent,
        ),
        title: Row(
          children: [
            Text(summoner.gameName),
            SizedBox(width: 16),
            if (member.firstPositionPreference != "")
            SvgPicture.file(
              File("assets/icons/position/${member.firstPositionPreference}.svg"),
              width: 40,
              height: 40,
            ),
            SizedBox(width: 4),
            if (member.secondPositionPreference != "")
            SvgPicture.file(
              File("assets/icons/position/${member.secondPositionPreference}.svg"),
              width: 40,
              height: 40,
            ),
          ],
        ),
        subtitle: Text(
          'Level ${summoner.summonerLevel}${member.isLeader ? "  -  Leader" : ""}',
        ),
        trailing: Text(
          'XP: ${summoner.xpSinceLastLevel}/${summoner.xpUntilNextLevel}',
        ),
      ),
    );
  }
}
