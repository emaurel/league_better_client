import 'package:league_better_client/api/betterClientApi.dart';
import 'dart:convert';
import 'dart:io';
import 'package:league_better_client/models/Friend.dart';

extension FriendService on BetterClientApi {
  Future<List<Friend>> getAllFriends() async {
    final response = await makeRequest('lol-chat/v1/friends', RequestType.GET);

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final List<dynamic> jsonResponse = json.decode(responseBody);
      List<Friend> friends = [];
      for (var friend in jsonResponse) {
        friends.add(Friend.fromJson(friend));
      }

      return friends;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }

  Future<Friend> getFriendById(String id) async {
    if (lockfile == null) {
      throw Exception(
        'Lockfile not found. please initialize the client first.',
      );
    }
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => true;

    final uri = Uri.parse(
      'https://127.0.0.1:${lockfile!.port}/lol-chat/v1/friends/$id',
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
      Friend friend = Friend.fromJson(jsonResponse);
      return friend;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }
}
