import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'lockfile.dart';

/// REST client for the LCU. The LCU serves HTTPS with a self-signed
/// certificate and Basic auth (`riot:<password>` from the lockfile).
class LcuHttp {
  LcuHttp(this._lockfile)
      : _client = IOClient(_buildClient()),
        _authHeader =
            'Basic ${base64Encode(utf8.encode('riot:${_lockfile.password}'))}';

  static HttpClient _buildClient() {
    final c = HttpClient();
    c.badCertificateCallback = (_, _, _) => true;
    return c;
  }

  final Lockfile _lockfile;
  final IOClient _client;
  final String _authHeader;

  Map<String, String> get _headers => {
        'Authorization': _authHeader,
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  Uri _uri(String path) => Uri.parse('${_lockfile.baseUrl}$path');

  Future<dynamic> get(String path) async {
    final res = await _client.get(_uri(path), headers: _headers);
    return _decode(res);
  }

  Future<dynamic> post(String path, [Object? body]) async {
    final res = await _client.post(
      _uri(path),
      headers: _headers,
      body: body == null ? null : jsonEncode(body),
    );
    return _decode(res);
  }

  Future<dynamic> put(String path, [Object? body]) async {
    final res = await _client.put(
      _uri(path),
      headers: _headers,
      body: body == null ? null : jsonEncode(body),
    );
    return _decode(res);
  }

  Future<dynamic> patch(String path, [Object? body]) async {
    final res = await _client.patch(
      _uri(path),
      headers: _headers,
      body: body == null ? null : jsonEncode(body),
    );
    return _decode(res);
  }

  Future<dynamic> delete(String path) async {
    final res = await _client.delete(_uri(path), headers: _headers);
    return _decode(res);
  }

  dynamic _decode(http.Response res) {
    if (res.statusCode >= 400) {
      throw LcuHttpException(res.statusCode, res.body);
    }
    if (res.body.isEmpty) return null;
    return jsonDecode(res.body);
  }

  void close() => _client.close();
}

class LcuHttpException implements Exception {
  LcuHttpException(this.statusCode, this.body);
  final int statusCode;
  final String body;

  @override
  String toString() => 'LcuHttpException($statusCode): $body';
}
