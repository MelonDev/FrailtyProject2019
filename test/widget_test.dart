// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frailty_project_2019/Design/catalogue_page.dart';
import 'package:frailty_project_2019/Design/new_main.dart';

import 'package:frailty_project_2019/main.dart';

void main() {

  NewMain newMain;
  var n;

  setUp((){
    newMain = new NewMain();
    var n = newMain.createState();

  });

  test('Hello', (){

  });
  
}
