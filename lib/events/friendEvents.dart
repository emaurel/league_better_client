
import 'package:league_better_client/events/events.dart';

sealed class FriendListEvent extends Event {}

class FriendListUpdateEvent extends FriendListEvent {}

sealed class FriendEvent extends Event {}

class FriendUpdateEvent extends FriendEvent {
  final String friendId;

  FriendUpdateEvent(this.friendId);
}
