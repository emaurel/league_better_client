import 'dart:async';

abstract class Event {}


class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;

  final StreamController<Event> _eventController = StreamController<Event>.broadcast();

  EventBus._internal();

  Stream<Event> get onEvent => _eventController.stream;

  void fire(Event event) {
    _eventController.add(event);
  }

  void dispose() {
    _eventController.close();
  }
}

final eventBus = EventBus();