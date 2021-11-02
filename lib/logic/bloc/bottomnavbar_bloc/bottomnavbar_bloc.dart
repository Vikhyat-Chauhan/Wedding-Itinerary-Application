import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
