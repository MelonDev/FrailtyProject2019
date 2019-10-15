import 'package:flutter/material.dart';

class BasicDarkThemeData {
  String _font = 'SukhumvitSet';

  ThemeData getTheme() {
    return ThemeData(
      brightness: Brightness.dark,
        primaryColor: Color(0xFF1A1A1A),
        bottomAppBarColor: Color(0xFF1A1A1A),
        accentColor: Colors.teal,
        cardColor: Color(0xFF212121),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        scaffoldBackgroundColor: Color(0xFF303030),
        dividerColor: Color(0xFF858585),
        cursorColor: Colors.white,
        secondaryHeaderColor: Color(0xFF3a9c8e),
        canvasColor: Colors.yellow,
        appBarTheme: AppBarTheme(
            color: Color(0xFF00665c),
            textTheme: TextTheme(
                title: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: _font,
                    fontWeight: FontWeight.bold))),
        primaryTextTheme: TextTheme(
          caption: TextStyle(color: Colors.white, fontSize: 20,fontFamily: _font),
            title: TextStyle(color: Colors.white, fontSize: 30,fontFamily: _font),
            subtitle: TextStyle(color: Colors.white.withAlpha(200),fontFamily: _font)));
  }
}
