part of 'event_bloc.dart';

abstract class EventBlocEvent extends Equatable {
  const EventBlocEvent();

  @override
  List<Object> get props => [];
}

class EventRefresh extends EventBlocEvent {
}
