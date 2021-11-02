import 'package:flutter/material.dart';
import 'package:weddingitinerary/core/themes/palette.dart';

class AppTheme {
  const AppTheme._();
  static final lightTheme = ThemeData(
    primarySwatch: Palette.kToDark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.white,
    // Define the default font family.
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    fontFamily: 'Railway',
    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.black),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.black),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Railway', color: Colors.black),
      button: TextStyle(fontWeight: FontWeight.normal, fontFamily: 'Railway', color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent,elevation: 0.0,toolbarHeight: 0.0),
  );

  static final darkTheme = ThemeData(
    primarySwatch: Palette.kToDark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.black,
    // Define the default font family.
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
    fontFamily: 'Railway',
    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.white),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Railway', color: Colors.white),
      button: TextStyle(fontWeight: FontWeight.normal, fontFamily: "Railway",),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent,elevation: 0.0,toolbarHeight: 0.0),
  );

  static final advancedTheme = ThemeData(
    primarySwatch: Palette.kToDark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: Colors.transparent,
    // Define the default font family.
    fontFamily: 'Railway',
    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.white),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Railway', color: Colors.white),
      button: TextStyle(fontWeight: FontWeight.normal, fontFamily: "Railway",),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent,elevation: 0.0,toolbarHeight: 0.0),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: Palette.kToDark.shade50, ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Palette.kToDark.shade200),),),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Palette.kToDark.shade200),
    popupMenuTheme: PopupMenuThemeData(color: Palette.kToDark.shade200),
    cardTheme: CardTheme(color: Palette.kToDark.shade200),
  );
}
