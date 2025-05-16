import 'package:league_better_client/api/betterClientApi.dart';
import 'dart:convert';
import 'dart:io';

import 'package:league_better_client/models/Queue.dart';

extension QueueService on BetterClientApi {
  Future<Queue> getQueue(String queueId) async {
    final response = await makeRequest(
      'lol-game-queues/v1/queues/$queueId',
      RequestType.GET,
    );
    
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
