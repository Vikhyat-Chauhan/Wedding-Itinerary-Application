part of 'bookings_bloc.dart';

abstract class BookingsBlocEvent extends Equatable {
  const BookingsBlocEvent();

  @override
  List<Object> get props => [];
}

class BookingsRefresh extends BookingsBlocEvent {
}
