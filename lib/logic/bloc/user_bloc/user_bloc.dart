import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:weddingitinerary/data/models/user/user.dart';
import 'package:weddingitinerary/data/repositories/mongodb/mongodb_crud.dart';
import 'package:weddingitinerary/logic/bloc/mongodb_bloc/mongodb_bloc.dart';

part 'user_bloc_event.dart';
part 'user_bloc_state.dart';

class UserBloc extends Bloc<UserBlocEvent, UserBlocState> {
  final MongodbBloc MongoDbBloc;
  late final StreamSubscription MongoDbBlocSubscription;
  UserBloc(this.MongoDbBloc) : super(const UserBlocState()) {
    on<UserBlocEvent>(_userEventHandler, transformer: droppable());
  }

  Future<void> _userEventHandler(
      UserBlocEvent event, Emitter<UserBlocState> emit) async {
    if (await mongoDbWorking()) {
      emit(state.copyWith(status: UserStatus.working));
      //ADD USER EVENT
      if (event is UserAdd) {
        User eventUser = event.getuser;
        List<User> userlist = List.from(
            state.users); //Create a local copy of state.userlist to work on
        if (state.status != UserStatus.useralreadyexists) {
          if (userlist.isEmpty ? true : false) {
            //the state is empty of users
            userlist.add(eventUser);
            try {
              await UserCrud.insert(eventUser); //put user on the internet
              emit(state.copyWith(
                  status: UserStatus.authenticated, users: userlist));
            } catch (_) {
              print(_);
              emit(state.copyWith(status: UserStatus.useralreadyexists));
            }
          } else {
            //the state has users, lets replace the current selected index one
            userlist.add(
                eventUser); //Add it to the local array to be pushed as new state
            try {
              await UserCrud.insert(eventUser); //put user on the internet
              emit(state.copyWith(
                  status: UserStatus.authenticated, users: userlist));
            } catch (_) {
              print(_);
              emit(state.copyWith(status: UserStatus.useralreadyexists));
            }
          }
        }
      }
      //REMOVE USER EVENT
      else if (event is UserRemove) {
        User eventUser = event.getuser;
        List<User> userlist = List.from(
            state.users); //Create a local copy of state.userlist to work on
        if (state.status != UserStatus.userdoesnotexists) {
          if (userlist.isEmpty ? true : false) {
            //the state is empty of users
            try {
              await UserCrud.delete(eventUser.id); //put user on the internet
              emit(state.copyWith(
                  status: UserStatus.unauthenticated, users: userlist));
            } catch (_) {
              print(_);
              emit(state.copyWith(status: UserStatus.userdoesnotexists));
            }
          } else {
            //the state has users, lets replace the current selected index one
            for (int i = 0; i < userlist.length; i++) {
              if ((userlist[i].id) == (eventUser.id)) {
                userlist.removeAt(i);
              }
            } //Add it to the local array to be pushed as new state
            try {
              await UserCrud.delete(eventUser.id); //put user on the internet
              emit(state.copyWith(
                  status: UserStatus.unauthenticated, users: userlist));
            } catch (_) {
              print(_);
              emit(state.copyWith(status: UserStatus.userdoesnotexists));
            }
          }
        }
      }
      //UPDATE USER EVENT
      else if (event is UserUpdate) {
        User eventUser = event.getuser;
        List<User> userlist = List.from(
            state.users); //Create a local copy of state.userlist to work on
        if (state.status != UserStatus.userdoesnotexists) {
          if (userlist.isEmpty ? true : false) {
            //the state is empty of users
            userlist.add(eventUser);
            try {
              await UserCrud.update(eventUser); //put user on the internet
              emit(state.copyWith(
                  status: UserStatus.authenticated, users: userlist));
            } catch (_) {
              print(_);
              emit(state.copyWith(status: UserStatus.userdoesnotexists));
            }
          } else {
            //the state has users, lets replace the current selected index one
            if (userlist[state.selecteduserindex] != eventUser) {
              userlist[state.selecteduserindex] =
                  eventUser; //Add it to the local array to be pushed as new state
              try {
                await UserCrud.update(eventUser); //put user on the internet
                emit(state.copyWith(
                    status: UserStatus.authenticated, users: userlist));
              } catch (_) {
                print(_);
                emit(state.copyWith(status: UserStatus.userdoesnotexists));
              }
            }
          }
        }
      }
      //UserRefresh Event
      else if (event is UserRefresh) {
        try {
          List<User> onlineusers = await UserCrud.getDocuments();
          emit(state.copyWith(
              status: UserStatus.authenticated, users: onlineusers));
        } catch (_) {
          print(_);
          emit(state.copyWith(status: UserStatus.undefined));
        }
      }
    } else {
      emit(state.copyWith(status: UserStatus.serviceunavailable));
    }
  }

  @override
  Future<void> close() {
    MongoDbBlocSubscription.cancel();
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
