import 'dart:io';
import 'dart:convert';

enum RequestType { GET, POST, PUT, DELETE, PATCH }

class LockfileInfo {
  final String password;
  final int port;

  LockfileInfo({required this.password, required this.port});
}

Future<LockfileInfo?> readLockfile() async {
  try {
    // Change this path depending on your installation
    final file = File(r'C:\Riot Games\League of Legends\lockfile');
    final contents = await file.readAsString();
    final parts = contents.split(':');

    return LockfileInfo(password: parts[3], port: int.parse(parts[2]));
  } catch (e) {
    print('Error reading lockfile: $e');
    return null;
  }
}

class BetterClientApi {
  static final BetterClientApi _instance = BetterClientApi._internal();

  static BetterClientApi get instance => _instance;

  BetterClientApi._internal();

  factory BetterClientApi() {
    return _instance;
  }

  LockfileInfo? lockfile;
  String? summonerId;

  Future<void> init() async {
    if (lockfile != null) {
      return;
    }
    lockfile = await readLockfile() ?? LockfileInfo(password: '', port: 0);
    await getSummonerInfo();
  }

  Future<HttpClientResponse> makeRequest(
    String path,
    RequestType type, {
    dynamic body, bool showDebug = false,
  }) async {
    if (lockfile == null) {
      throw ('Lockfile not found. please initialize the client first.');
    }
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => true;

    final uri = Uri.parse('https://127.0.0.1:${lockfile!.port}/$path');
    if (showDebug) {
      print('Requesting: $uri');
    }
    HttpClientRequest request;
    switch (type) {
      case RequestType.GET:
        request = await client.getUrl(uri);

      case RequestType.POST:
        request = await client.postUrl(uri);

      case RequestType.PUT:
        request = await client.putUrl(uri);

      case RequestType.DELETE:
        request = await client.deleteUrl(uri);

      case RequestType.PATCH:
        request = await client.patchUrl(uri);
    }

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('riot:${lockfile!.password}'))}';
    request.headers.set(HttpHeaders.authorizationHeader, basicAuth);
    if (body != null) {
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(body));
    }

    final response = await request.close();
    if (showDebug) {
      print('Response status: ${response.statusCode}');
      response.transform(utf8.decoder).listen((contents) {
        print('Response body: $contents');
      });
    }
    return response;
  }

  Future<Map<String, dynamic>?> getSummonerInfo() async {
    final response = await makeRequest(
      'lol-summoner/v1/current-summoner',
      RequestType.GET,
    );

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      summonerId = jsonDecode(responseBody)['summonerId'].toString();
      return jsonDecode(responseBody);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}
