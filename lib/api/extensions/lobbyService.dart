import 'package:league_better_client/api/betterClientApi.dart';
import 'dart:convert';
import 'dart:io';

extension LobbyService on BetterClientApi {
  Future<void> joinLobby(String lobbyId) async {
    if (lockfile == null) {
      print('Lockfile not found. please initialize the client first.');
      return;
    }
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => true;

    final uri = Uri.parse(
      'https://127.0.0.1:${lockfile!.port}/lol-lobby/v2/party/$lobbyId/join',
    );
    print('Requesting: $uri');
    final request = await client.postUrl(uri);

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('riot:${lockfile!.password}'))}';
    request.headers.set(HttpHeaders.authorizationHeader, basicAuth);

    final response = await request.close();

    print('Response status: ${response.statusCode}');
    if (response.statusCode == 204) {
      print('Successfully joined lobby: $lobbyId');
    } else {
      print('Failed to join lobby: ${response.statusCode}.');
      final responseBody = await response.transform(utf8.decoder).join();
        print(responseBody);
    }
    return;
  }
}
