import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _keyToken = 'refresh_token';

  static Future<void> setToken(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(token == null){
      return;
    }
    prefs.setString(_keyToken, token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String? stringValue = prefs.getString(_keyToken);
    return stringValue;
  }

  static Future dropToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove String
    prefs.remove(_keyToken);
  }
}