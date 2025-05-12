import 'package:league_better_client/api/betterClientApi.dart';
import 'dart:convert';
import 'dart:io';
import 'package:league_better_client/models/Champion.dart';

extension ChampionService on BetterClientApi {
  Future<List<Champion>> getAllChampions(String summonerId) async {
    if (lockfile == null) {
      print('Lockfile not found. please initialize the client first.');
      return [];
    }
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => true;

    final uri = Uri.parse(
      'https://127.0.0.1:${lockfile!.port}/lol-champions/v1/inventories/$summonerId/champions',
    );
    print('Requesting: $uri');
    final request = await client.getUrl(uri);

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('riot:${lockfile!.password}'))}';
    request.headers.set(HttpHeaders.authorizationHeader, basicAuth);

    final response = await request.close();

    print('Response status: ${response.statusCode}');

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
