part of 'locations_bloc.dart';

enum LocationsStatus{initial,serviceunavailable, working, undefined, normal}

class LocationsBlocState extends Equatable {
  const LocationsBlocState({
    this.status = LocationsStatus.initial,
    this.locations = const <Locations>[],
  });

  final LocationsStatus status;
  final List<Locations> locations;

  LocationsBlocState copyWith({
    LocationsStatus? status,
    List<Locations>? events,
  }) {
    return LocationsBlocState(
      status: status ?? this.status,
      locations: events ?? this.locations,
    );
  }

  @override
  String toString() {
    return '''LocationsBlocState { status: $status, locations: $locations }''';
  }

  @override
  List<Object> get props => [status, locations];
}