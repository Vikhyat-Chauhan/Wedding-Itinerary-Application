part of 'user_bloc.dart';

enum UserStatus{initial, working, authenticated, unauthenticated, serviceunavailable, undefined, useralreadyexists, userdoesnotexists,}

class UserBlocState extends Equatable {
  const UserBlocState({
    this.status = UserStatus.initial,
    this.users = const <User>[],
    this.selecteduserindex = 0,
  });

  final UserStatus status;
  final List<User> users;
  final int selecteduserindex;

  UserBlocState copyWith({
    UserStatus? status,
    List<User>? users,
    int? selecteduserindex,
  }) {
    return UserBlocState(
      status: status ?? this.status,
      users: users ?? this.users,
      selecteduserindex: selecteduserindex ?? this.selecteduserindex,
    );
  }

  @override
  String toString() {
    return '''UserBlocState { status: $status, users: $users, selecteduserindex: $selecteduserindex }''';
  }

  @override
  List<Object> get props => [status, users, selecteduserindex];
}