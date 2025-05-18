
import 'package:league_better_client/events/events.dart';

sealed class ChampSelectEvent extends Event {}

class ChampSelectStartEvent extends ChampSelectEvent {}
class ChampSelectEndEvent extends ChampSelectEvent {}