import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/data/repositories/mongodb/mongodb_crud.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:weddingitinerary/data/models/event/event.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/bloc/mongodb_bloc/mongodb_bloc.dart';
import 'package:weddingitinerary/logic/bloc/user_bloc/user_bloc.dart';

part 'event_bloc_event.dart';
part 'event_bloc_state.dart';

class EventBloc extends Bloc<EventBlocEvent, EventBlocState> {
  final MongodbBloc MongoDbBloc;
  final AuthenticationBloc authBloc ;
  late final StreamSubscription authBlocSubscription;
  EventBloc(this.MongoDbBloc, this.authBloc) : super(const EventBlocState()) {
    on<EventBlocEvent>(_eventEventHandler, transformer: droppable());

    authBlocSubscription = authBloc.stream.listen((state) async {
      if (state.status == AuthenticationStatus.authenticated) {
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
          print(authBloc.state.profile);
          List<Event> onlineevents = await EventCrud.getmanybykey({"userid":authBloc.state.profile["sub"]});
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
    //MongoDbBlocSubscription.cancel();
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
