import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'internet_bloc_event.dart';
part 'internet_bloc_state.dart';

class InternetBloc extends Bloc<InternetBlocEvent, InternetBlocState> {
  late final StreamSubscription<InternetConnectionStatus> listener;
  InternetBloc(/*this.MongoDbBloc*/)
      : super(const InternetBlocState()
            .copyWith(status: InternetStatus.initial)) {
    _initAction();
  }

  @override
  Future<void> close() {
    listener.cancel();
    return super.close();
  }

  Future<void> _initAction()  async {
    // actively listen for status updates
    listener = InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            emit(InternetBlocState(status: InternetStatus.connected));
            break;
          case InternetConnectionStatus.disconnected:
            emit(InternetBlocState(status: InternetStatus.disconnected));
            break;
        }
      },
    );
  }
}
