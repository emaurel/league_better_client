import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lcu/lcu_connector.dart';
import '../lcu/lcu_session.dart';
import '../lcu/league_launcher.dart';

final leagueLauncherProvider = Provider<LeagueLauncher>((ref) {
  final l = LeagueLauncher();
  ref.onDispose(l.dispose);
  return l;
});

final lcuConnectorProvider = Provider<LcuConnector>((ref) {
  final c = LcuConnector()..start();
  ref.onDispose(c.dispose);
  return c;
});

final lcuConnectionStateProvider = StreamProvider<LcuConnectionState>((ref) {
  final connector = ref.watch(lcuConnectorProvider);
  return Stream<LcuConnectionState>.multi((controller) {
    controller.add(connector.state);
    final sub = connector.stream.listen(controller.add);
    controller.onCancel = sub.cancel;
  });
});

/// Convenience: the live [LcuSession] when connected, else null.
final lcuSessionProvider = Provider<LcuSession?>((ref) {
  return ref.watch(lcuConnectionStateProvider).valueOrNull?.session;
});

/// `true` when we have an open HTTP+WS session.
final lcuConnectedProvider = Provider<bool>((ref) {
  final state = ref.watch(lcuConnectionStateProvider).valueOrNull;
  return state?.status == LcuStatus.connected && state?.session != null;
});
