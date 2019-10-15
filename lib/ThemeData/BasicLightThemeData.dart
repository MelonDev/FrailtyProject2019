import 'package:flutter/material.dart';

class BasicLightThemeData {

  String _font = 'SukhumvitSet';

  ThemeData getTheme() {
    return ThemeData(
        brightness: Brightness.light,

        primaryColor: Colors.white,
        bottomAppBarColor: Colors.white,
        accentColor: Colors.teal,
        cardColor: Colors.white,
        cursorColor: Colors.teal,
        backgroundColor: Color(0xFFE0E0E0),
        iconTheme: IconThemeData(color: Colors.black87),
        scaffoldBackgroundColor: Color(0xFFD9D9D9),
        dividerColor: Color(0xFF858585),
        canvasColor: Colors.teal,

        secondaryHeaderColor: Color(0xFF52c7b8),
        appBarTheme: AppBarTheme(
            color: Colors.teal,
            textTheme: TextTheme(
                title: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontFamily: _font,
                    fontWeight: FontWeight.bold))),
        primaryTextTheme: TextTheme(
            caption: TextStyle(color: Colors.white, fontSize: 20,fontFamily: _font),
            title: TextStyle(color: Colors.black.withAlpha(150), fontSize: 30,fontFamily: _font,),
            subtitle: TextStyle(fontFamily: _font,color: Colors.black.withAlpha(180))));
  }
}
