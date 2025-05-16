import 'package:league_better_client/api/betterClientApi.dart';
import 'package:league_better_client/models/MatchmakingSearch.dart';
import 'dart:convert';

import 'package:league_better_client/models/MatchmakingSearchError.dart';

extension MatchmakingService on BetterClientApi {
  Future<void> matchmakingStart() async {
    final response = await makeRequest(
      'lol-lobby/v2/lobby/matchmaking/search',
      RequestType.POST,
      showDebug: true,
    );

    if (response.statusCode == 204) {
      print('Successfully started matchmaking');
    } else {
      print('Failed to start matchmaking: ${response.statusCode}.');
    }
  }

  Future<void> matchmakingStop() async {
    final response = await makeRequest(
      'lol-matchmaking/v1/search',
      RequestType.DELETE,
    );

    if (response.statusCode == 204) {
      print('Successfully stopped matchmaking');
    } else {
      print('Failed to stop matchmaking: ${response.statusCode}.');
    }
  }

  Future<void> acceptGame() async {
    final response = await makeRequest(
      'lol-matchmaking/v1/ready-check/accept',
      RequestType.POST,
    );
    if (response.statusCode == 204) {
      print('Successfully accepted game');
    } else {
      print('Failed to accept game: ${response.statusCode}.');
      final responseBody = await response.transform(utf8.decoder).join();
      print(responseBody);
    }
  }

  Future<void> declineGame() async {
    final response = await makeRequest(
      'lol-matchmaking/v1/ready-check/decline',
      RequestType.POST,
    );
    if (response.statusCode == 204) {
      print('Successfully declined game');
    } else {
      print('Failed to decline game: ${response.statusCode}.');
      final responseBody = await response.transform(utf8.decoder).join();
      print(responseBody);
    }
  }

  Future<MatchmakingSearch?> getMatchmakingSearch() async {
    final response = await makeRequest(
      'lol-matchmaking/v1/search',
      RequestType.GET,
    );

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> jsonResponse = json.decode(responseBody);
      MatchmakingSearch matchmakingSearch = MatchmakingSearch.fromJson(
        jsonResponse,
      );
      return matchmakingSearch;
    } else if (response.statusCode == 404) {
      print('No matchmaking search found: ${response.statusCode}.');
      return null;
      } else {
      print('Failed to get matchmaking search: ${response.statusCode}.');
      final responseBody = await response.transform(utf8.decoder).join();
      print(JsonEncoder.withIndent("   ").convert(responseBody));
      throw Exception(
        'Failed to get matchmaking search: ${response.statusCode}.',
      );
    }
  }
}



/*  DODGE
{
  "dodgeData": {
    "dodgerId": 0,
    "state": "Invalid"
  },
  "errors": [
    {
      "errorType": "QUEUE_DODGER",
      "id": 0,
      "message": "QUEUE_DODGER",
      "penalizedSummonerId": 78877506,
      "penaltyTimeRemaining": 292.627
    }
  ],
  "estimatedQueueTime": 0.0,
  "isCurrentlyInQueue": false,
  "lobbyId": "",
  "lowPriorityData": {
    "bustedLeaverAccessToken": "",
    "penalizedSummonerIds": [],
    "penaltyTime": 0.0,
    "penaltyTimeRemaining": 0.0,
    "reason": ""
  },
  "queueId": 400,
  "readyCheck": {
    "declinerIds": [],
    "dodgeWarning": "None",
    "playerResponse": "None",
    "state": "Invalid",
    "suppressUx": false,
    "timer": 0.0
  },
  "searchState": "Error",
  "timeInQueue": 0.0
}
*/