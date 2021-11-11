part of 'livelink_bloc.dart';

enum LivelinkStatus{initial,serviceunavailable, working, undefined, normal}

class LivelinkBlocState extends Equatable {
  const LivelinkBlocState({
    this.status = LivelinkStatus.initial,
    this.livelinks = const <Livelink>[],
  });

  final LivelinkStatus status;
  final List<Livelink> livelinks;

  LivelinkBlocState copyWith({
    LivelinkStatus? status,
    List<Livelink>? livelinks,
  }) {
    return LivelinkBlocState(
      status: status ?? this.status,
      livelinks: livelinks ?? this.livelinks,
    );
  }

  @override
  String toString() {
    return '''LivelinkBlocState { status: $status, bookings: $livelinks }''';
  }

  @override
  List<Object> get props => [status, livelinks];
}