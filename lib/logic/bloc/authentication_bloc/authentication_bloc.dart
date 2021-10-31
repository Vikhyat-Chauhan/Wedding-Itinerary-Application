import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weddingitinerary/core/constants/strings.dart';
import 'package:weddingitinerary/data/dataproviders/token_storage.dart';
import 'package:weddingitinerary/data/models/user/user.dart';
import 'package:weddingitinerary/data/repositories/mongodb/mongodb_crud.dart';
import 'package:weddingitinerary/logic/bloc/mongodb_bloc/mongodb_bloc.dart';
import 'package:weddingitinerary/logic/bloc/user_bloc/user_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:weddingitinerary/logic/cubit/internet_bloc/internet_bloc.dart';

part 'authentication_bloc_event.dart';
part 'authentication_bloc_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationBlocEvent, AuthenticationBlocState> {
  final MongodbBloc mongodbBloc;
  final InternetBloc _internetBloc;
  final FlutterAppAuth appAuth = FlutterAppAuth();

  late final StreamSubscription UserBlocSubscription;
  late final StreamSubscription MongoDBSubscription;
  late final StreamSubscription _internetBlocSubscription;

  AuthenticationBloc(this._internetBloc,this.mongodbBloc)
      : super(const AuthenticationBlocState()) {
    on<AuthenticationBlocEvent>(_authenticationEventHandler,
        transformer: droppable());
    MongoDBSubscription = mongodbBloc.stream.listen((state) async {
      if (state.status == MongodbStatus.connected) {
        await _loginwithtoken();
      }
    });

    _internetBlocSubscription = _internetBloc.stream.listen((state) async {
      if (state.status == InternetStatus.connected) {
        //emit(AuthenticationBlocState(status: AuthenticationStatus.));
      }
      else if(state.status == InternetStatus.disconnected) {
        //emit(ImagesBlocState(status: ImagesStatus.serviceunavailable));
      }
    });
  }

  Future<void> _authenticationEventHandler(AuthenticationBlocEvent event,
      Emitter<AuthenticationBlocState> emit) async {
    if (await mongodbWorking()) {
      emit(state.copyWith(status: AuthenticationStatus.working));
      //Login EVENT
      if (event is Login) {
        if (state.status != AuthenticationStatus.authenticated) {
          try {
            print("Login action");
            await _loginAction();
          } catch (_) {
            print(" Login Failed");
            emit(state.copyWith(
              status: AuthenticationStatus.unauthenticated,
            ));
          }
        }
      }

      //LOGOUT EVENT
      else if (event is Logout) {
        emit(state.copyWith(
            status: AuthenticationStatus.unauthenticated,
            profile: null,
            authorization: null));
        await _logout();
      }
    } else {
      emit(state.copyWith(status: AuthenticationStatus.serviceunavailable));
    }
  }

  @override
  Future<void> close() {
    _internetBlocSubscription..cancel();
    return super.close();
  }

  Future<bool> mongodbWorking() async {
    bool working = false;
    if (mongodbBloc.state.status == MongodbStatus.initial) {
      working = false;
    } else if (mongodbBloc.state.status == MongodbStatus.working) {
      working = false;
    } else if (mongodbBloc.state.status == MongodbStatus.disconnected) {
      working = false;
    } else if (mongodbBloc.state.status == MongodbStatus.connected) {
      working = true;
    } else {
      working = false;
    }
    return working;
  }

  Future<void> _loginwithtoken() async {
    String? storedRefreshToken = await TokenStorage.getToken();
    if (storedRefreshToken == null) {
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
      return;
    }

    try {
      emit(state.copyWith(status: AuthenticationStatus.working));
      final TokenResponse? response = await appAuth.token(TokenRequest(
        Strings.AUTH0_CLIENT_ID,
        Strings.AUTH0_REDIRECT_URI,
        issuer: Strings.AUTH0_ISSUERHTTP,
        refreshToken: storedRefreshToken,
      ));

      final Map<String, dynamic> authorization = {
        "idToken": response!.idToken,
        "accessToken": response.accessToken,
        "refreshToken": response.refreshToken,
        "tokenType": response.tokenType,
        "accessTokenExpirationDateTime": response.accessTokenExpirationDateTime
      };

      final Map<String, dynamic> profile =
          await _getUserDetails(response.accessToken);

      await TokenStorage.setToken(response.refreshToken);
      emit(state.copyWith(
          status: AuthenticationStatus.authenticated,
          profile: profile,
          authorization: authorization));
      User user = userFromMap(state.profile);
      UserCrud.update(user);
      return;
    } on Exception catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      emit(state.copyWith(status: AuthenticationStatus.unauthenticated));
      await _logout();
      return;
    }
  }

  Future<void> _loginAction() async {
    final AuthorizationTokenResponse? result =
        await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        Strings.AUTH0_CLIENT_ID,
        Strings.AUTH0_REDIRECT_URI,
        issuer: Strings.AUTH0_DOMAIN,
        scopes: <String>['openid', 'profile', 'offline_access'],
      ),
    );

    final Map<String, dynamic> authorization = {
      "idToken": result!.idToken,
      "accessToken": result.accessToken,
      "refreshToken": result.refreshToken,
      "tokenType": result.tokenType,
      "accessTokenExpirationDateTime": result.accessTokenExpirationDateTime
    };

    final Map<String, dynamic> profile =
        await _getUserDetails(result.accessToken);

    await TokenStorage.setToken(result.refreshToken);

    emit(state.copyWith(
        status: AuthenticationStatus.authenticated,
        profile: profile,
        authorization: authorization));
    User user = userFromMap(state.profile);
    UserCrud.update(user);
  }

  Future<void> _logout() async {
    TokenStorage.dropToken();
  }

  Future<Map<String, dynamic>> _getUserDetails(String? accessToken) async {
    const String url = Strings.AUTH0_DOMAIN + '/userinfo';
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }
}
