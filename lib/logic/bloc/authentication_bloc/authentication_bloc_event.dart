part of 'authentication_bloc.dart';

abstract class AuthenticationBlocEvent{
  const AuthenticationBlocEvent();
}

class Login extends AuthenticationBlocEvent {
}

class Logout extends AuthenticationBlocEvent {
}