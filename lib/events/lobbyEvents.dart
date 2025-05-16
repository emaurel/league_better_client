
import 'package:league_better_client/events/events.dart';
import 'package:league_better_client/models/Queue.dart';

sealed class LobbyEvent extends Event {}

class JoinLobbyEvent extends LobbyEvent {
  final Queue? queue;

  JoinLobbyEvent(this.queue);
}
class QuitLobbyEvent extends LobbyEvent {}
class RefreshLobbyEvent extends LobbyEvent {}
class LocalRoleChangeEvent extends LobbyEvent {}

