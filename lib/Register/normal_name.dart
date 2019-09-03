import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix1;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' as prefix0;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:frailty_project_2019/Model/Account.dart';
import 'dart:io';
import 'dart:async';
import 'dart:ui';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class RegisterApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF009688)),
      home: MyHomePage(title: 'ระบบวิเคราะห์ภาวะเปราะบาง'),
    );
  }
}

class RegisterRoute extends PageRoute<void> {
  RegisterRoute({
    @required this.builder,
    RouteSettings settings,
  })  : assert(builder != null),
        super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    //dialog = new ProgressDialog(context, ProgressDialogType.Normal);
    //dialog.setMessage('กำลังโหลด...');

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
/*
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );*/
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class NormalNameRegisterRoute extends StatefulWidget {
  NormalNameRegisterRoute();

  @override
  _normalNameRegisterRoute createState() => _normalNameRegisterRoute();
}

class _normalNameRegisterRoute extends State<NormalNameRegisterRoute> {
  Color _firstNameColor = Color(0xFF009688);
  Color _firstNameContainerColor = Colors.black12;
  Color _lastNameColor = Color(0xFF009688);
  Color _lastNameContainerColor = Colors.black12;

  String _firstNameText = "";
  String _lastNameText = "";

  String _dateTime;

  void setDateVar(DateTime date) {
    var formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(date) + "T00:00:00Z";
    _dateTime = formatted;
  }

  void checkName() async {
    setState(() {
      if (_firstNameText.length == 0 || _lastNameText.length == 0) {
        if (_firstNameText.length == 0) {
          _firstNameColor = Color(0xFFFFFFFF);
          _firstNameContainerColor = Color(0xFFe53935);
        } else {
          _firstNameColor = Color(0xFF009688);
          _firstNameContainerColor = Colors.black12;
        }
        if (_lastNameText.length == 0) {
          _lastNameColor = Color(0xFFFFFFFF);
          _lastNameContainerColor = Color(0xFFe53935);
        } else {
          _lastNameColor = Color(0xFF009688);
          _lastNameContainerColor = Colors.black12;
        }
      } else {
        _firstNameColor = Color(0xFF009688);
        _firstNameContainerColor = Colors.black12;
        _lastNameColor = Color(0xFF009688);
        _lastNameContainerColor = Colors.black12;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setDateVar(DateTime.now());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0.0,
        automaticallyImplyLeading: false, // Don't show the leading button
        title: Stack(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.transparent,
                  child: Text('ยกเลิก',
                      style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: RaisedButton(
                    elevation: 0,
                    onPressed: () {
                      checkName();
                      //Navigator.pop(context);
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    color: Color(0xFF009688),
                    child: Text('ยืนยัน',
                        style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            )
          ],
        ),

        /*title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.transparent,
                child: Text('ลงชื่อเข้าใช้ด้วย ชื่อ-นามสกุล',
                    style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),*/

        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
          color: Colors.white,
          child: Container(
              margin: EdgeInsets.only(left: 25, right: 25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.black26,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text('ลงใช้งานด้วยชื่อและนามสกุล',
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              color: Colors.black,
                              fontSize: 26,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text('ชื่อจริง',
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                        decoration: new BoxDecoration(
                            color: _firstNameContainerColor,
                            borderRadius:
                                new BorderRadius.all(Radius.circular(10))),
                        height: 42,
                        margin: EdgeInsets.only(top: 4),
                        child: Container(
                          margin: EdgeInsets.only(top: 7, left: 14, right: 14),
                          child: TextField(
                            maxLines: 1,
                            onChanged: (str) {
                              _firstNameText = str;
                              /* if (str.length == 0) {
                                checkName();
                              }
                              */
                            },
                            cursorColor: _firstNameColor,
                            style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                color: _firstNameColor,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                            decoration: InputDecoration.collapsed(
                                hintText: '', border: InputBorder.none),
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Text('นามสกุล',
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                        decoration: new BoxDecoration(
                            color: _lastNameContainerColor,
                            borderRadius:
                                new BorderRadius.all(Radius.circular(10))),
                        height: 42,
                        margin: EdgeInsets.only(top: 4),
                        child: Container(
                          margin: EdgeInsets.only(top: 7, left: 14, right: 14),
                          child: TextField(
                            onChanged: (str) {
                              _lastNameText = str;
                              /* if (str.length == 0) {
                                checkName();
                              }
                              */
                            },
                            maxLines: 1,
                            cursorColor: _lastNameColor,
                            style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                color: _lastNameColor,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                            decoration: InputDecoration.collapsed(
                                hintText: '', border: InputBorder.none),
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Text('เลือกวันเดือนปีเกิด',
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                        height: 256,
                        child: DatePickerWidget(
                          onChange: (dateTime, selectedIndex) {
                            setDateVar(dateTime);
                          },
                          locale: DateTimePickerLocale.en_us,
                          //th
                          dateFormat: 'dd MMMM yyyy',
                          pickerTheme: DateTimePickerTheme(
                            backgroundColor: Colors.white,
                            itemHeight: 30.0,
                            titleHeight: 0.0,
                          ),
                        ))
                  ],
                ),
              ))),
    );
  }
}
