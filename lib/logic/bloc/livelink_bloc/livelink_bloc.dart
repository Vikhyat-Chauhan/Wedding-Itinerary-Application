import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/constants/strings.dart';
import 'package:weddingitinerary/data/models/livelink/livelink.dart';
import 'package:weddingitinerary/data/repositories/mongodb/mongodb_crud.dart';
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/bloc/mongodb_bloc/mongodb_bloc.dart';

part 'livelink_bloc_event.dart';
part 'livelink_bloc_state.dart';

class LivelinkBloc extends Bloc<LivelinkBlocEvent, LivelinkBlocState> {
  final MongodbBloc MongoDbBloc;
  final AuthenticationBloc authBloc ;
  late final StreamSubscription authBlocSubscription;
  late final StreamSubscription _mongodbBlocSubscription;

  LivelinkBloc(this.MongoDbBloc, this.authBloc) : super(const LivelinkBlocState()) {
    on<LivelinkBlocEvent>(_livelinksEventHandler, transformer: droppable());
    _mongodbBlocSubscription = MongoDbBloc.stream.listen((state) async {
      if (state.status == MongodbStatus.connected) {
        emit(LivelinkBlocState().copyWith(status: LivelinkStatus.normal));
      }
      else if(state.status == MongodbStatus.serviceunavailable) {
        emit(LivelinkBlocState().copyWith(status: LivelinkStatus.serviceunavailable));
      }
    });

    authBlocSubscription = authBloc.stream.listen((state) async {
      if (state.status == AuthenticationStatus.authenticated) {
        add(LivelinkRefresh());
      }
    });
  }

  Future<void> _livelinksEventHandler(
      LivelinkBlocEvent event, Emitter<LivelinkBlocState> emit) async {
    if (await mongoDbWorking()) {
      emit(state.copyWith(status: LivelinkStatus.working));
      //EventRefresh Event
      if (event is LivelinkRefresh) {
        try {
          List<Livelink> onlinelivelinks = await LivelinkCrud.getmanybykey({"userid":Strings.ADMIN_USERID});
          emit(state.copyWith(
              status: LivelinkStatus.normal, livelinks: onlinelivelinks));
        } catch (_) {
          print(_);
          emit(state.copyWith(status: LivelinkStatus.undefined));
        }
      }
    } else {
      emit(state.copyWith(status: LivelinkStatus.serviceunavailable));
    }
  }

  @override
  Future<void> close() {
    _mongodbBlocSubscription.cancel();
    authBlocSubscription.cancel();
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
