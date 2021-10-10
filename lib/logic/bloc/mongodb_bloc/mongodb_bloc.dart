import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/data/repositories/mongodb/mongodb_crud.dart';

part 'mongodb_bloc_event.dart';
part 'mongodb_bloc_state.dart';

class MongodbBloc extends Bloc<MongodbBlocEvent, MongodbBlocState> {
  //final MongoDbCubit MongoDbBloc;
  //late final StreamSubscription MongoDbBlocSubscription;
  MongodbBloc(/*this.MongoDbBloc*/) : super(const MongodbBlocState()) {
    on<MongodbBlocEvent>(_mongodbEventHandler, transformer: droppable());
  }

  Future<void> _mongodbEventHandler(
      MongodbBlocEvent event, Emitter<MongodbBlocState> emit) async {
    //if (await internetWorking()) {
    emit(state.copyWith(status: MongodbStatus.working));
    //CONNECT EVENT
    if (event is Connect) { print("Connect event");
      if (state.status != MongodbStatus.connected) {
        try {
          emit(state.copyWith(status: MongodbStatus.connecting));
          await MongoDatabase.connect();
          emit(state.copyWith(status: MongodbStatus.connected));
        } catch (_) {
          print(_);
          emit(state.copyWith(status: MongodbStatus.undefined));
        }
      }
    }
    //DISCONNECT EVENT
    if (event is Disconnect) {
      if (state.status != MongodbStatus.disconnected) {
        try {
          emit(state.copyWith(status: MongodbStatus.disconnecting));
          await MongoDatabase.disconnect();
          emit(state.copyWith(status: MongodbStatus.disconnected));
        } catch (_) {
          print(_);
          emit(state.copyWith(status: MongodbStatus.undefined));
        }
      }
    }
    //} else {
    //  emit(state.copyWith(status: MongodbStatus.serviceunavailable));
    //}
  }

  @override
  Future<void> close() {
    //MongoDbBlocSubscription.cancel();
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
