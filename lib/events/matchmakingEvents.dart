import 'package:league_better_client/events/events.dart';


sealed class MatchmakingEvent extends Event {}

class MatchmakingStartEvent extends MatchmakingEvent {}
class MatchmakingStopEvent extends MatchmakingEvent {}
class MatchmakingFoundEvent extends MatchmakingEvent {}
class MatchmakingAcceptedEvent extends MatchmakingEvent {}
class MatchmakingDeclinedEvent extends MatchmakingEvent {}
class MatchmakingCancelledEvent extends MatchmakingEvent {}
class MatchmakingErrorEvent extends MatchmakingEvent {}