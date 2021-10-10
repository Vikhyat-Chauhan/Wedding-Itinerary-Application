import 'dart:async';

import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:weddingitinerary/data/dataproviders/token_storage.dart';
import '../../../core/constants/strings.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  final FlutterAppAuth appAuth = FlutterAppAuth();

  Future<void> authenticate() async {
    _loginAction();
  }

  Future<void> logout() async {
    //TokenSecureStorage.dropToken();
    TokenStorage.dropToken();
    emit(Unauthenticated("logging out"));
  }

  Future<void> loginwithtoken() async {
    emit(Authenticating());
    String? storedRefreshToken = await TokenStorage.getToken();

    if (storedRefreshToken == null) {
      emit(TokenExpired());
      return;
    }


    try {
      emit(Authenticating());
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

      emit(Authenticated(profile: profile, authorization: authorization));
      return;

    } on Exception catch (e, s) {
      print('error on refresh token: $e - stack: $s');
      emit(TokenExpired());
      await logout();
      return;
    }
  }

  Future<void> _loginAction() async {
    emit(Authenticating());

    try {
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

      emit(Authenticated(profile: profile, authorization: authorization));
    } on Exception catch (e, s) {
      print('login error: $e - stack: $s');

      emit(Unauthenticated(e.toString()));
    }
  }

  Map<String, dynamic> _parseIdToken(String idToken) {
    final List<String> parts = idToken.split('.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
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

  void _checktokenexipration() {
    const oneSec = Duration(seconds: 60);
    Timer.periodic(oneSec, (Timer t) {
      //print('checking authentication token');
    });
  }

  Future<void> _initAction() async {
    //Timer? timer;
    //const oneSec = Duration(seconds:1);
    //Timer.periodic(oneSec, (Timer t) {
    //print('checking authentication state');
    //});
    //logger("Trying to login with refresh token");
    //await _loginwithtoken();
  }
}
