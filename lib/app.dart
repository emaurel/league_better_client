import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lcu/lcu_connector.dart';
import 'providers/lcu_providers.dart';
import 'screens/connecting_screen.dart';
import 'screens/home_shell.dart';
import 'theme/app_theme.dart';

class LeagueBetterApp extends ConsumerWidget {
  const LeagueBetterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'League Better Client',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const _Root(),
    );
  }
}

class _Root extends ConsumerWidget {
  const _Root();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lcuConnectionStateProvider).valueOrNull;
    if (state?.status == LcuStatus.connected && state?.session != null) {
      return const HomeShell();
    }
    return const ConnectingScreen();
  }
}
