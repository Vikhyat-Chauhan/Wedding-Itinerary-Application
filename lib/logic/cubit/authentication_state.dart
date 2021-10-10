
part of 'authentication_cubit.dart';

abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class Authenticating extends AuthenticationState {}

class TokenExpired extends AuthenticationState {}

class Authenticated extends AuthenticationState {

  final Map<String, dynamic> profile;
  final Map<String, dynamic> authorization;

  Authenticated({required this.profile,required this.authorization});
}

class Unauthenticated extends AuthenticationState {
  final String? errorMessage;

  Unauthenticated(this.errorMessage);
}
