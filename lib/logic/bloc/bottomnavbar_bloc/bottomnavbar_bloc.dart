import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/constants/strings.dart';
import 'package:weddingitinerary/data/models/bookings/bookings.dart';
import 'package:weddingitinerary/data/repositories/mongodb/mongodb_crud.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:weddingitinerary/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:weddingitinerary/logic/bloc/mongodb_bloc/mongodb_bloc.dart';

part 'bottomnavbar_bloc_event.dart';
part 'bottomnavbar_bloc_state.dart';

class BottomnavbarBloc extends Bloc<BottomnavbarBlocEvent, BottomnavbarBlocState> {
  BottomnavbarBloc() : super(const BottomnavbarBlocState()) {
    on<BottomnavbarBlocEvent>(_bottomnavbarEventHandler, transformer: droppable());
  }

  Future<void> _bottomnavbarEventHandler(
      BottomnavbarBlocEvent event, Emitter<BottomnavbarBlocState> emit) async {
      //page index set  Event
      if (event is Bottomnavbarsetindex) {
          emit(state.copyWith(pageindex: event.pageindex));
      }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
