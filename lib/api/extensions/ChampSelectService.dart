import 'dart:convert';

import 'package:league_better_client/api/betterClientApi.dart';
import 'package:league_better_client/models/ChampSelect.dart';
import 'package:league_better_client/models/ChampSelectChampion.dart';

extension ChampSelectService on BetterClientApi {
  Future<List<ChampSelectChampion>> getChampSelectChampions() async {
    final response = await makeRequest(
      "lol-champ-select/v1/all-grid-champions",
      RequestType.GET,
    );
    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final List<dynamic> jsonResponse = json.decode(responseBody);

      List<ChampSelectChampion> champions = [];

      for (var champion in jsonResponse) {
        champions.add(ChampSelectChampion.fromJson(champion));
      }
      return champions;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }

  Future<void> patchAction(Action currentAction, Action newAction) async {
    final response = await makeRequest(
      "lol-champ-select/v1/session/actions/${currentAction.id}",
      RequestType.PATCH,
      body: {
        "id": currentAction.id,
        "actorCellId": currentAction.actorCellId,
        "championId": newAction.championId,
        "completed": newAction.completed,
      },
    );
    if (response.statusCode == 200) {
      print('Action applied successfully.');
    } else {
      print('Failed to apply action: ${response.statusCode}.');
      final responseBody = await response.transform(utf8.decoder).join();
      print('Response body: $responseBody');
    }
  }
}
