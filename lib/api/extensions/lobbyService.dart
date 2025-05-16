import 'package:league_better_client/api/betterClientApi.dart';
import 'dart:convert';
import 'dart:io';

import 'package:league_better_client/models/Lobby.dart';
import 'package:league_better_client/models/LobbyMember.dart';

extension LobbyService on BetterClientApi {
  Future<void> joinLobby(String lobbyId) async {
    final response = await makeRequest(
      'lol-lobby/v2/party/$lobbyId/join',
      RequestType.POST,
    );
    if (response.statusCode == 204) {
      print('Successfully joined lobby: $lobbyId');
    } else {
      print('Failed to join lobby: ${response.statusCode}.');
      final responseBody = await response.transform(utf8.decoder).join();
      print(responseBody);
    }
    return;
  }

  Future<Lobby?> getCurrentLobby() async {
    final response = await makeRequest('lol-lobby/v2/lobby', RequestType.GET);

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final Map<String, dynamic> jsonResponse = json.decode(responseBody);
      Lobby lobby = Lobby.fromJson(jsonResponse);
      return lobby;
    } else {
      return null;
    }
  }

  Future<void> quitLobby() async {
    final response = await makeRequest(
      'lol-lobby/v2/lobby',
      RequestType.DELETE,
    );

    if (response.statusCode == 204) {
      print('Successfully quit lobby');
    } else {
      print('Failed to quit lobby: ${response.statusCode}.');
      final responseBody = await response.transform(utf8.decoder).join();
      print(responseBody);
    }
  }

  Future<bool> setRole(String role, bool isFirst, Member member) async {
    final body = {"firstPreference": "", "secondPreference": ""};
    String currentFirst = member.firstPositionPreference;
    String currentSecond = member.secondPositionPreference;
    print('Current first: $currentFirst');
    print('Current second: $currentSecond');
    if (isFirst) {
      body["firstPreference"] = role;
      if (currentSecond == role) {
        body["secondPreference"] = currentFirst;
      } else {
        body["secondPreference"] = currentSecond;
      }
    } else {
      body["secondPreference"] = role;
      if (currentFirst == role) {
        body["firstPreference"] = currentSecond;
      } else {
        body["firstPreference"] = currentFirst;
      }
    }

    final response = await makeRequest(
      'lol-lobby/v2/lobby/members/localMember/position-preferences',
      RequestType.PUT,
      body: body,
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      print('Failed to set role: ${response.statusCode}.');
      final responseBody = await response.transform(utf8.decoder).join();
      print(responseBody);
      return false;
    }
  }

  
}
