import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lcu/lcu_session.dart';
import '../providers/lcu_providers.dart';
import '../theme/app_colors.dart';

/// Process-lifetime cache: the LCU's static assets (icons, splashes) don't
/// change while the client is open, and the bytes are small enough that
/// keeping them in memory is preferable to re-fetching on rebuild.
final _imageCache = <String, Uint8List>{};

/// Image loaded from the LCU at [path] (e.g.
/// `/lol-game-data/assets/v1/profile-icons/29.jpg`). Skips Flutter's
/// built-in `Image.network` because the LCU uses a self-signed cert and
/// requires Basic auth.
class LcuImage extends ConsumerWidget {
  const LcuImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
  });

  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(lcuSessionProvider);
    if (session == null) return _placeholder();
    return FutureBuilder<Uint8List?>(
      future: _load(session, path),
      builder: (context, snap) {
        final bytes = snap.data;
        if (bytes == null) return _placeholder();
        return Image.memory(
          bytes,
          fit: fit,
          width: width,
          height: height,
          gaplessPlayback: true,
        );
      },
    );
  }

  Widget _placeholder() {
    if (placeholder != null) return placeholder!;
    return Container(
      width: width,
      height: height,
      color: AppColors.navyElevated,
    );
  }

  static Future<Uint8List?> _load(LcuSession session, String path) async {
    final cached = _imageCache[path];
    if (cached != null) return cached;
    final client = HttpClient();
    client.badCertificateCallback = (_, _, _) => true;
    try {
      final uri = Uri.parse('${session.lockfile.baseUrl}$path');
      final req = await client.getUrl(uri);
      req.headers.set(
        HttpHeaders.authorizationHeader,
        'Basic ${base64Encode(utf8.encode('riot:${session.lockfile.password}'))}',
      );
      final res = await req.close();
      if (res.statusCode != 200) return null;
      final builder = BytesBuilder(copy: false);
      await for (final chunk in res) {
        builder.add(chunk);
      }
      final bytes = builder.takeBytes();
      _imageCache[path] = bytes;
      return bytes;
    } catch (_) {
      return null;
    } finally {
      client.close(force: true);
    }
  }
}
