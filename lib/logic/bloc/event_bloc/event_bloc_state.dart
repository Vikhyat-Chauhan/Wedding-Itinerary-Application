part of 'event_bloc.dart';

enum EventStatus{initial,serviceunavailable, working, undefined, normal}

class EventBlocState extends Equatable {
  const EventBlocState({
    this.status = EventStatus.initial,
    this.events = const <Event>[],
  });

  final EventStatus status;
  final List<Event> events;

  EventBlocState copyWith({
    EventStatus? status,
    List<Event>? events,
  }) {
    return EventBlocState(
      status: status ?? this.status,
      events: events ?? this.events,
    );
  }

  @override
  String toString() {
    return '''EventBlocState { status: $status, events: $events }''';
  }

  @override
  List<Object> get props => [status, events];
}