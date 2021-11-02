import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/constants/strings.dart';
import 'package:weddingitinerary/data/repositories/mongodb/mongodb_crud.dart';
import 'package:weddingitinerary/data/models/event/event.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/bloc/mongodb_bloc/mongodb_bloc.dart';
import 'package:weddingitinerary/logic/cubit/internet_bloc/internet_bloc.dart';

part 'event_bloc_event.dart';
part 'event_bloc_state.dart';

class EventBloc extends Bloc<EventBlocEvent, EventBlocState> {
  final MongodbBloc MongoDbBloc;
  final AuthenticationBloc authBloc ;
  final InternetBloc _internetBloc;
  late final StreamSubscription authBlocSubscription;
  late final StreamSubscription _internetBlocSubscription;

  EventBloc(this.MongoDbBloc, this.authBloc, this._internetBloc) : super(const EventBlocState()) {
    on<EventBlocEvent>(_eventEventHandler, transformer: droppable());

    authBlocSubscription = authBloc.stream.listen((state) async {
      if (state.status == AuthenticationStatus.authenticated) {
        add(EventRefresh());
      }
    });

    _internetBlocSubscription = _internetBloc.stream.listen((state) async {
      if (state.status == InternetStatus.connected) {
        emit(EventBlocState(status: EventStatus.normal));
      }
      else if(state.status == InternetStatus.disconnected) {
        add(EventRefresh());
      }
    });
  }

  Future<void> _eventEventHandler(
      EventBlocEvent event, Emitter<EventBlocState> emit) async {
    if (await mongoDbWorking()) {
      emit(state.copyWith(status: EventStatus.working));
      //EventRefresh Event
      if (event is EventRefresh) {
        try {
          List<Event> onlineevents = await EventCrud.getmanybykey({"userid":Strings.ADMIN_USERID});
          onlineevents.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          emit(state.copyWith(
              status: EventStatus.normal, events: onlineevents));
        } catch (_) {
          print(_);
          emit(state.copyWith(status: EventStatus.undefined));
        }
      }
    } else {
      emit(state.copyWith(status: EventStatus.serviceunavailable));
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
