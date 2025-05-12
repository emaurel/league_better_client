import 'dart:io';
import 'dart:convert';



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

  Future<Map<String, dynamic>?> getSummonerInfo() async {
    if (lockfile == null) {
      print('Lockfile not found. please initialize the client first.');
      return null;
    }
    final client = HttpClient();
    client.badCertificateCallback = (cert, host, port) => true;

    final uri = Uri.parse(
      'https://127.0.0.1:${lockfile!.port}/lol-summoner/v1/current-summoner',
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
      print(jsonDecode(responseBody));
      summonerId = jsonDecode(responseBody)['summonerId'].toString();
      return jsonDecode(responseBody);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}