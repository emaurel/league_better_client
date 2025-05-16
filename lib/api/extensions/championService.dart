import 'package:league_better_client/api/betterClientApi.dart';
import 'dart:convert';
import 'dart:io';
import 'package:league_better_client/models/Champion.dart';

extension ChampionService on BetterClientApi {
  Future<List<Champion>> getAllChampions(String summonerId) async {
    final response = await makeRequest(
      "lol-champions/v1/inventories/$summonerId/champions",
      RequestType.GET,
    );

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final List<dynamic> jsonResponse = json.decode(responseBody);

      List<Champion> champions = [];

      for (var champion in jsonResponse) {
        champions.add(Champion.fromJson(champion));
      }
      return champions;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }
}
