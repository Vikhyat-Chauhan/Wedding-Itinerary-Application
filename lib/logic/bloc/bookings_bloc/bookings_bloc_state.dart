part of 'bookings_bloc.dart';

enum BookingsStatus{initial,serviceunavailable, working, undefined, normal}

class BookingsBlocState extends Equatable {
  const BookingsBlocState({
    this.status = BookingsStatus.initial,
    this.bookings = const <Bookings>[],
  });

  final BookingsStatus status;
  final List<Bookings> bookings;

  BookingsBlocState copyWith({
    BookingsStatus? status,
    List<Bookings>? events,
  }) {
    return BookingsBlocState(
      status: status ?? this.status,
      bookings: events ?? this.bookings,
    );
  }

  @override
  String toString() {
    return '''BookingsBlocState { status: $status, bookings: $bookings }''';
  }

  @override
  List<Object> get props => [status, bookings];
}