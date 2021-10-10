part of 'authentication_bloc.dart';

enum AuthenticationStatus{initial, working, authenticated, unauthenticated, serviceunavailable}

class AuthenticationBlocState extends Equatable {
  const AuthenticationBlocState({
    this.status = AuthenticationStatus.initial,
    this.profile =  dummyprofile,
    this.authorization = dummyauthorization,
  });

  final AuthenticationStatus status;
  final Map<String, dynamic> profile;
  final Map<String, dynamic> authorization;

  AuthenticationBlocState copyWith({
    AuthenticationStatus? status,
    Map<String, dynamic>? profile,
    Map<String, dynamic>? authorization,
  }) {
    return AuthenticationBlocState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      authorization: authorization ?? this.authorization,
    );
  }

  @override
  String toString() {
    return '''AuthenticationBlocState { status: $status, profile: $profile, authorization: $authorization }''';
  }

  @override
  List<Object> get props => [status,];
}


const Map<String, dynamic> dummyprofile = {};
const Map<String, dynamic> dummyauthorization = {};