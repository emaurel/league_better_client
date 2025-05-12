import 'package:league_better_client/api/betterClientApi.dart';
import 'dart:convert';
import 'dart:io';

import 'package:league_better_client/models/Queue.dart';

extension QueueService on BetterClientApi {
  Future<Queue> getQueue(String queueId) async {
    if (lockfile == null) {
      print('Lockfile not found. please initialize the client first.');
      throw Exception('Lockfile not found');
    }
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => true;

    final uri = Uri.parse(
      'https://127.0.0.1:${lockfile!.port}/lol-game-queues/v1/queues/$queueId',
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
      final Map<String, dynamic> jsonResponse = json.decode(responseBody);
      Queue queue = Queue.fromJson(jsonResponse);
      return queue;
    } else {
      print('getQueue failed with status: ${response.statusCode}.');
      print('Response body: ${await response.transform(utf8.decoder).join()}');
      throw Exception('getQueue failed with status: ${response.statusCode}');
    }
  }
}
