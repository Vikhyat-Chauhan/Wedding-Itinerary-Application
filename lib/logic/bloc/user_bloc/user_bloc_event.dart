part of 'user_bloc.dart';

abstract class UserBlocEvent extends Equatable {
  const UserBlocEvent();

  @override
  List<Object> get props => [];
}

class UserAdd extends UserBlocEvent {
  const UserAdd({required this.user});
  final User user;

  User get getuser{
    return user;
  }
}

class UserRemove extends UserBlocEvent {
  const UserRemove({required this.user});
  final User user;

  User get getuser{
    return user;
  }
}

class UserUpdate extends UserBlocEvent {
  const UserUpdate({required this.user});
  final User user;

  User get getuser{
    return user;
  }
}

class UserRefresh extends UserBlocEvent{
  //refreshing the user list in the state.
}