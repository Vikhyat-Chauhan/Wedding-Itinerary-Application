import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/constants/strings.dart';
import 'package:weddingitinerary/data/models/bookings/bookings.dart';
import 'package:weddingitinerary/data/repositories/mongodb/mongodb_crud.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/bloc/mongodb_bloc/mongodb_bloc.dart';
import 'package:weddingitinerary/logic/cubit/internet_bloc/internet_bloc.dart';

part 'bookings_bloc_event.dart';
part 'bookings_bloc_state.dart';

class BookingsBloc extends Bloc<BookingsBlocEvent, BookingsBlocState> {
  final MongodbBloc MongoDbBloc;
  final AuthenticationBloc authBloc ;
  final InternetBloc _internetBloc;
  late final StreamSubscription authBlocSubscription;
  late final StreamSubscription _internetBlocSubscription;

  BookingsBloc(this._internetBloc,this.MongoDbBloc, this.authBloc) : super(const BookingsBlocState()) {
    on<BookingsBlocEvent>(_bookingsEventHandler, transformer: droppable());

    _internetBlocSubscription = _internetBloc.stream.listen((state) async {
      if (state.status == InternetStatus.connected) {
        emit(BookingsBlocState(status: BookingsStatus.working));
      }
      else if(state.status == InternetStatus.disconnected) {
        emit(BookingsBlocState(status: BookingsStatus.serviceunavailable));
      }
    });

    authBlocSubscription = authBloc.stream.listen((state) async {
      if (state.status == AuthenticationStatus.authenticated) {
        add(BookingsRefresh());
      }
    });

  }

  Future<void> _bookingsEventHandler(
      BookingsBlocEvent event, Emitter<BookingsBlocState> emit) async {
    if (await mongoDbWorking()) {
      emit(state.copyWith(status: BookingsStatus.working));
      //EventRefresh Event
      if (event is BookingsRefresh) {
        try {
          List<Bookings> onlinebookings = await BookingsCrud.getmanybykey({"userid":Strings.ADMIN_USERID});
          onlinebookings.sort((a, b) => a.roomNo.compareTo(b.roomNo));
          emit(state.copyWith(
              status: BookingsStatus.normal, events: onlinebookings));
        } catch (_) {
          print(_);
          emit(state.copyWith(status: BookingsStatus.undefined));
        }
      }
    } else {
      emit(state.copyWith(status: BookingsStatus.serviceunavailable));
    }
  }

  @override
  Future<void> close() {
    _internetBlocSubscription.cancel();
    return super.close();
  }

  Future<bool> mongoDbWorking() async {
    bool working = false;
    if (MongoDbBloc.state.status == MongodbStatus.initial) {
      working = false;
    } else if (MongoDbBloc.state.status == MongodbStatus.working) {
      working = false;
    } else if (MongoDbBloc.state.status == MongodbStatus.disconnected) {
      working = false;
    } else if (MongoDbBloc.state.status == MongodbStatus.connected) {
      working = true;
    } else {
      working = false;
    }
    return working;
  }
}
