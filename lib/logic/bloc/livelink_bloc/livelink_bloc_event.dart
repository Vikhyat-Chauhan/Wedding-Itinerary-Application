part of 'livelink_bloc.dart';

abstract class LivelinkBlocEvent extends Equatable {
  const LivelinkBlocEvent();

  @override
  List<Object> get props => [];
}

class LivelinkRefresh extends LivelinkBlocEvent {
}
