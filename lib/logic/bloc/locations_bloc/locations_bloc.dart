import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/constants/strings.dart';
import 'package:weddingitinerary/data/models/locations/locations.dart';
import 'package:weddingitinerary/data/repositories/mongodb/mongodb_crud.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/bloc/mongodb_bloc/mongodb_bloc.dart';
import 'package:weddingitinerary/logic/cubit/internet_bloc/internet_bloc.dart';

part 'locations_bloc_event.dart';
part 'locations_bloc_state.dart';

class LocationsBloc extends Bloc<LocationsBlocEvent, LocationsBlocState> {
  final MongodbBloc MongoDbBloc;
  final AuthenticationBloc authBloc;
  final InternetBloc _internetBloc;
  late final StreamSubscription authBlocSubscription;
  late final StreamSubscription _internetBlocSubscription;
  LocationsBloc(this._internetBloc,this.MongoDbBloc, this.authBloc)
      : super(const LocationsBlocState()) {
    on<LocationsBlocEvent>(_locationsEventHandler, transformer: droppable());

    authBlocSubscription = authBloc.stream.listen((state) async {
      if (state.status == AuthenticationStatus.authenticated) {
        add(LocationsRefresh());
      }
    });

    _internetBlocSubscription = _internetBloc.stream.listen((state) async {
      if (state.status == InternetStatus.connected) {
        emit(LocationsBlocState(status: LocationsStatus.normal));
      }
      else if(state.status == InternetStatus.disconnected) {
        add(LocationsRefresh());
      }
    });
  }

  Future<void> _locationsEventHandler(
      LocationsBlocEvent event, Emitter<LocationsBlocState> emit) async {
    if (await mongoDbWorking()) {
      emit(state.copyWith(status: LocationsStatus.working));
      //EventRefresh Event
      if (event is LocationsRefresh) {
        try {
          List<Locations> onlinelocations = await LocationsCrud.getmanybykey(
              {"userid": Strings.ADMIN_USERID});
          onlinelocations.sort((a, b) => a.nickname.compareTo(b.nickname));
          emit(state.copyWith(
              status: LocationsStatus.normal, events: onlinelocations));
        } catch (_) {
          print(_);
          emit(state.copyWith(status: LocationsStatus.undefined));
        }
      }
    } else {
      emit(state.copyWith(status: LocationsStatus.serviceunavailable));
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
