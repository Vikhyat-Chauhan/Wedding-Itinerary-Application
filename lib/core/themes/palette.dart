
//palette.dart
import 'package:flutter/material.dart';
class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xff3e8588, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50:  Color(0xff519194),//10%
      100: Color(0xff659da0),//20%
      200: Color(0xff659da0),//30%
      300: Color(0xff8bb6b8),//40%
      400: Color(0xff9fc2c4),//50%
      500: Color(0xffb2cecf),//60%
      600: Color(0xffc5dadb),//70%
      700: Color(0xffd8e7e7),//80%
      800: Color(0xffecf3f3),//90%
      900: Color(0xffffffff),//100%
    },
  );
}