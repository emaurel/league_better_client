import 'package:league_better_client/api/betterClientApi.dart';
import 'dart:convert';
import 'dart:io';

import 'package:league_better_client/models/Lobby.dart';
import 'package:league_better_client/models/Summoner.dart';

extension SummonerService on BetterClientApi {
  Future<Summoner?> getSummonerById(String summonerId) async {
    final response = await makeRequest(
      "lol-summoner/v1/summoners/$summonerId",
      RequestType.GET,
    );

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> jsonResponse = json.decode(responseBody);
      return Summoner.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}
