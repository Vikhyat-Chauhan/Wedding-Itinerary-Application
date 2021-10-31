
//palette.dart
import 'package:flutter/material.dart';
class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xffae626d, //0xfff88c9c 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50:  Color(0xffdf7e8c),//10%
      100: Color(0xffc6707d),//20%
      200: Color(0xffae626d),//30%
      300: Color(0xff95545e),//40%
      400: Color(0xff7c464e),//50%
      500: Color(0xff63383e),//60%
      600: Color(0xff4a2a2f),//70%
      700: Color(0xff321c1f),//80%
      800: Color(0xff190e10),//90%
      900: Color(0xff000000),//100%
    },
  );
}