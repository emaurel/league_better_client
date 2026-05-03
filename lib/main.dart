import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'lcu/lockfile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LcuPaths.load();
  runApp(const ProviderScope(child: LeagueBetterApp()));
}
