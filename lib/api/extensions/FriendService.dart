import 'package:league_better_client/api/betterClientApi.dart';
import 'dart:convert';
import 'dart:io';
import 'package:league_better_client/models/Friend.dart';

extension FriendService on BetterClientApi {
  Future<List<Friend>> getAllFriends() async {
    if (lockfile == null) {
      print('Lockfile not found. please initialize the client first.');
      return [];
    }
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => true;

    final uri = Uri.parse(
      'https://127.0.0.1:${lockfile!.port}/lol-chat/v1/friends',
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
      List<Friend> friends = [];
      for (var friend in jsonResponse) {
        friends.add(Friend.fromJson(friend));
        if (friend['gameName'] == "Obésité Morbide"){
          //print(JsonEncoder.withIndent("  ").convert(friend));
        }
      }
      for (var friend in friends) {
        if (friend.lol.pty != null) {
          //print(friend.lol.pty);
        }
      }
      
      return friends;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }
}
