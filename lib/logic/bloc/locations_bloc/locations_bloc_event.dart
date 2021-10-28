part of 'locations_bloc.dart';

abstract class LocationsBlocEvent extends Equatable {
  const LocationsBlocEvent();

  @override
  List<Object> get props => [];
}

class LocationsRefresh extends LocationsBlocEvent {
}
