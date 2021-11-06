import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/data/repositories/mongodb/mongodb_crud.dart';
import 'package:weddingitinerary/logic/cubit/internet_bloc/internet_bloc.dart';

part 'mongodb_bloc_event.dart';
part 'mongodb_bloc_state.dart';

class MongodbBloc extends Bloc<MongodbBlocEvent, MongodbBlocState> {
  final InternetBloc _internetBloc;
  late final StreamSubscription _internetBlocSubscription;
  MongodbBloc(this._internetBloc) : super(const MongodbBlocState()) {
    on<MongodbBlocEvent>(_mongodbEventHandler, transformer: droppable());

    _internetBlocSubscription = _internetBloc.stream.listen((state) async {
      if (state.status == InternetStatus.connected) {
        add(Connect());
      }
      else if(state.status == InternetStatus.disconnected) {
        emit(MongodbBlocState(status: MongodbStatus.serviceunavailable));
      }
    });
  }

  Future<void> _mongodbEventHandler(
      MongodbBlocEvent event, Emitter<MongodbBlocState> emit) async {
    //if (await internetWorking()) {
    emit(state.copyWith(status: MongodbStatus.working));
    //CONNECT EVENT
    if (event is Connect) {
      if (state.status != MongodbStatus.connected) {
        try {
          emit(state.copyWith(status: MongodbStatus.working));
          await MongoDatabase.connect();
          emit(state.copyWith(status: MongodbStatus.connected));
        } catch (_) {
          print(_);
          emit(state.copyWith(status: MongodbStatus.serviceunavailable));
        }
      }
    }
    //DISCONNECT EVENT
    if (event is Disconnect) {
      if (state.status != MongodbStatus.disconnected) {
        try {
          await MongoDatabase.disconnect();
          emit(state.copyWith(status: MongodbStatus.disconnected));
        } catch (_) {
          print(_);
          emit(state.copyWith(status: MongodbStatus.serviceunavailable));
        }
      }
    }
    //} else {
    //  emit(state.copyWith(status: MongodbStatus.serviceunavailable));
    //}
  }

  @override
  Future<void> close() {
    _internetBlocSubscription.cancel();
    return super.close();
  }
/*
  Future<bool> internetWorking() async {
    bool working = false;
    if (MongoDbBloc.state.status == MongoDBStatus.initial) {
      working = false;
    } else if (MongoDbBloc.state.status == MongoDBStatus.connecting) {
      working = false;
    } else if (MongoDbBloc.state.status == MongoDBStatus.disconnected) {
      working = false;
    } else if (MongoDbBloc.state.status == MongoDBStatus.connected) {
      working = true;
    } else {
      working = false;
    }
    return working;
  } */
}
