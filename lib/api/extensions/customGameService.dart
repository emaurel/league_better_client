


import 'dart:convert';

import 'package:league_better_client/api/betterClientApi.dart';

extension CustomGameService on BetterClientApi {
  Future<void> startCustomGame() async {
    final response = await makeRequest(
      'lol-lobby/v1/lobby/custom/start-champ-select',
      RequestType.POST,
    );
    if (response.statusCode == 204) {
      print('Successfully started custom game');
    } else {
      print('Failed to start custom game: ${response.statusCode}.');
      final responseBody = await response.transform(utf8.decoder).join();
      print(responseBody);
    }
  }
}