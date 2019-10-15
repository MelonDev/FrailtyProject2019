import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' as prefix2;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart' as prefix1;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frailty_project_2019/Bloc/authentication/authentication_bloc.dart';
import 'package:frailty_project_2019/Bloc/catalogue/catalogue_bloc.dart';
import 'package:frailty_project_2019/Bloc/questionnaire/questionnaire_bloc.dart';
import 'package:frailty_project_2019/Model/Account.dart';
import 'package:frailty_project_2019/Model/TemporaryCode.dart';
import 'package:frailty_project_2019/ThemeData/BasicDarkThemeData.dart';
import 'package:frailty_project_2019/ThemeData/BasicLightThemeData.dart';
import 'package:frailty_project_2019/popup_dialog.dart' as prefix0;
import 'package:frailty_project_2019/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:frailty_project_2019/Design/new_main.dart';
import 'dart:io';
import 'dart:ui';
import 'Bloc/flow_bloc_delegate.dart';
import 'popup_dialog.dart';
import 'package:http/http.dart' as http;
import 'api.dart';

import 'dart:async';
import 'package:flutter/foundation.dart';

void main() {
  BlocSupervisor.delegate = FlowBlocDelegate();
  return runApp(MyApp());
}

//void main() => runApp(MyApp());
/*void main() => runApp(MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF009688)),
      home: MyHomePage(title: 'ระบบวิเคราะห์ภาวะเปราะบาง'),
    ));
*/
var firebase = FirebaseAuth.instance;
ProgressDialog pr;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
            builder: (context) =>
                AuthenticationBloc()..dispatch(AuthenticatingLoginEvent(null,null))),
        BlocProvider<CatalogueBloc>(
          builder: (context) =>
              CatalogueBloc()..dispatch(QuestionnaireSelectedEvent()),
        ),
        BlocProvider<QuestionnaireBloc>(
          builder: (context) =>
              QuestionnaireBloc()..dispatch(InitialQuestionnaireEvent()),
        )
      ],
      child: DynamicTheme(
          defaultBrightness:Brightness.light,
              //MediaQuery.of(context).platformBrightness == Brightness.light
                  //? Brightness.light
                  //: Brightness.dark,
          data: (brightness) {
            return brightness == Brightness.light ? BasicLightThemeData().getTheme() : BasicDarkThemeData().getTheme();
          },
          themedWidgetBuilder: (context, theme) {
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: theme,
              //darkTheme: BasicDarkThemeData().getTheme(),
              home: NewMain(),
            );
          }),

      /*
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: BasicLightThemeData().getTheme(),
        darkTheme: BasicDarkThemeData().getTheme(),
        home: NewMain(),

      ),

       */
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class IPhoneXPadding extends Container {
  final Widget child;

  IPhoneXPadding({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    if (!_isIPhoneX(mediaQueryData)) {
      // fallback for all non iPhone X
      return child;
    }

    var homeIndicatorHeight =
        mediaQueryData.orientation == Orientation.portrait ? 22.0 : 20.0;

    var outer = mediaQueryData.padding;
    var bottom = outer.bottom + homeIndicatorHeight;
    return new MediaQuery(
        data: new MediaQueryData(
            padding: new EdgeInsets.fromLTRB(
                outer.left, outer.top, outer.right, bottom)),
        child: child);
  }

  bool _isIPhoneX(MediaQueryData mediaQuery) {
    if (Platform.isIOS) {
      var size = mediaQuery.size;
      if ((size.height >= 812.0 && size.height < 1000.0) ||
          (size.width >= 812.0 && size.height < 1000.0)) {
        return true;
      }
    }
    return false;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _isSignIn = false;
  FirebaseUser _currentUser;
  String _mainBtn = "กำลังโหลด..";

  Account _account;

  String _firstName = "", _lastname = "", _userStatus = "";

  CupertinoAlertDialog alert;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    //_checkSignIn();
    loadTextBtn(false);
  }

  void initDialog(String message) async {
    //pr = ProgressDialog(context, ProgressDialogType.Normal);
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);
    //pr.setMessage(message);
    pr.style(message: message);
    pr.show();
  }

  void hideDialog() {
    pr.hide();
  }

  void _checkSignIn() async {
    print("IS");

    _currentUser = await firebase.currentUser();

    setState(() {
      //_currentUser = currentUser;
      _isSignIn = _currentUser != null;

      //print(_isSignIn);
      if (_isSignIn) {
        _mainBtn = "เริ่มทำแบบทดสอบ";
      } else {
        _mainBtn = "ลงชื่อเข้าใช้";
      }
    });
  }

  void _checkStatus() async {
    _currentUser = await firebase.currentUser();

    setState(() {
      //_currentUser = currentUser;
      _isSignIn = _currentUser != null;

      //print(_isSignIn);
      if (_isSignIn) {
        _mainBtn = "เริ่มทำแบบทดสอบ";
      } else {
        _mainBtn = "ลงชื่อเข้าใช้";
      }
    });

    return;
  }

  void _setStatus(bool b) {
    setState(() {
      //_currentUser = currentUser;
      _isSignIn = _currentUser != null;

      //print(b);
      if (_isSignIn) {
        _mainBtn = "เริ่มทำแบบทดสอบ";
      } else {
        _mainBtn = "ลงชื่อเข้าใช้";
      }
    });
  }

  void cupertinoDialog(
      BuildContext context, String title, String content, List<Widget> list) {
    //Navigator.pop(context);

    alert = CupertinoAlertDialog(
        title: Text(
          title,
          style: prefix2.TextStyle(
              fontFamily: 'SukhumvitSet',
              fontSize: 21,
              color: Colors.black87,
              fontWeight: FontWeight.bold),
        ),
        content: content != null
            ? Text(
                content,
                style:
                    prefix2.TextStyle(fontFamily: 'SukhumvitSet', fontSize: 18),
              )
            : null,
        actions: list);
    showDialog(context: context, child: alert);
  }

  CupertinoDialogAction getAction(
      String message, bool destructive, bool active, Function func) {
    return CupertinoDialogAction(
        child: Text(
          message,
          style: prefix1.TextStyle(fontFamily: 'SukhumvitSet', fontSize: 19),
        ),
        isDestructiveAction: destructive,
        isDefaultAction: active,
        onPressed: () {
          func();
        });
  }

  loadTextBtn(bool isDialog) async {
    //print("asdasdadasdadasd");

    //print("Processing");

    //initDialog("TEST");
    await firebase.currentUser().then((onValue) {
      ////print("UUID : "+onValue.uid.toString());
      //print("object");

      loadAccountApi(onValue, isDialog);

      //test(onValue != null, onValue);
    });

    ////print("HELLOssssss");
    /*
    setState(() {
      if (_currentUser != null) {
        _mainBtn = "เริ่มทำแบบทดสอบ";
      } else {
        _mainBtn = "ลงชื่อเข้าใช้";
      }
    });
    */
  }

  loadAccountApi(FirebaseUser value, bool isDialog) async {
    //print("object");
    if (value != null) {
      String url =
          'https://melondev-frailty-project.herokuapp.com/api/account/showDetailFromId';
      Map map = {"id": "", "oauth": value.uid.toString()};
      var response = await http.post(url, body: map);
      //print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');

      Account account = Account.fromJson(jsonDecode(response.body));
      _account = account;
      //print(account.id);

      //print(account.id.length);

      test(account.id.length > 0, value, account, isDialog);

      //TemporaryCode(id, pinCode, expiredDate, startDate)
      //TemporaryCode temporaryCode = TemporaryCode.fromJson(jsonDecode(response.body));
      //print(temporaryCode.id);

    } else {
      test(false, value, null, isDialog);
    }

/*
    await apiRequest(url, map).then((onValue) {
      print(onValue);
    });
    */
  }

  test(bool b, FirebaseUser user, Account value, bool isDialog) {
    //print("HELLOskdsafajkdsjsssss");

    //print(value);

    setState(() {
      _currentUser = user;

      if (b) {
        if (isDialog) {
          List<Widget> list = [];
          list.add(getAction("รับทราบ", false, true, () {
            Navigator.of(context).pop();
          }));

          cupertinoDialog(context, "ลงชื่อเข้าใช้เรียบร้อย", null, list);
        } else {
          //avigator.of(context).pop();
          //pr.hide();

        }
        _mainBtn = "เริ่มทำแบบทดสอบ";
        _firstName = value.firstName;
        _lastname = value.lastName;
        _userStatus = value.personnel ? "บุคลากร" : "ผู้ใช้ทั่วไป";
      } else {
        //print("1");
        _mainBtn = "ลงชื่อเข้าใช้";

        if (isDialog) {
          List<Widget> list = [];
          list.add(getAction("รับทราบ", false, true, () {
            Navigator.of(context).pop();
          }));

          cupertinoDialog(context, "ลงชื่อออกเรียบร้อย", null, list);
        } else {
          //Navigator.of(context).pop();
          //pr.hide();

        }
      }
    });
  }

  setTextBtn(bool b) {
    ////print("HELLO");
    setState(() {
      if (b) {
        _mainBtn = "เริ่มทำแบบทดสอบ";
      } else {
        _mainBtn = "ลงชื่อเข้าใช้";
      }
    });
  }

  bool _isIPhoneX(MediaQueryData mediaQuery) {
    if (Platform.isIOS) {
      var size = mediaQuery.size;
      if (size.height >= 812.0 &&
          size.height <
              1000.0) /*||
          (size.width >= 812.0 && size.width < 1000.0))*/
      {
        return true;
      }
    }
    return false;
  }

  bool _isIPad(MediaQueryData mediaQuery) {
    if (Platform.isIOS) {
      var size = mediaQuery.size;
      if (size.height > 1000.0 || size.width > 1000.0) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
//initDialog();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title,
            style: TextStyle(
                fontFamily: 'SukhumvitSet', fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF52c7b8),
                  Color(0xFFD9D9D9) /*Color(0xFF282a57)*/
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(17.5, 25.0, 17.5, 120.0),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.teal.withOpacity(0.5),
                                blurRadius: 10.0,
                              ),
                            ]),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              //width: MediaQuery.of(context).size.width > 1000 ? 1000 : MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24)),
                                  color: Colors.white),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 26,
                                        left: 30,
                                        right: 30,
                                        bottom: 20),
                                    color: Colors.transparent,
                                    child: Image.asset(
                                      'images/funny-elderly-couple-dancing-cartoon-vector-24002358.jpg',
                                      fit: BoxFit.contain,
                                      height: _isIPhoneX(MediaQuery.of(context))
                                          ? MediaQuery.of(context).size.width /
                                              1.7
                                          : MediaQuery.of(context).size.width /
                                              3.2,
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(24, 0, 20, 0),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'แบบทดสอบภาวะเปราะบาง',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontFamily: 'SukhumvitSet',
                                                    fontSize: _isIPad(
                                                            MediaQuery.of(
                                                                context))
                                                        ? 28
                                                        : 23,
                                                    color: Colors.teal[600]
                                                        .withOpacity(0.8),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                'ภาวะเปราะบาง คือ ภาวะหนึ่งของร่างกายซึ่งอยู่ระหว่าง ภาวะที่สามารถทำงานต่างๆได้ กับ ภาวะไร้ความสามารถ หรือก็คือ ระหว่างสุขภาพดี กับความเป็นโรค โดยในผู้สูงอายุ ช่วงเวลาดังกล่าวเป็นช่วงที่มีความสุ่มเสี่ยงจะเกิดการพลัดตกหรือหกล้ม',
                                                textAlign: TextAlign.left,
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: 'SukhumvitSet',
                                                    fontSize: _isIPad(
                                                            MediaQuery.of(
                                                                context))
                                                        ? 22
                                                        : 17,
                                                    color: Colors.black45,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              )
                                            ],
                                          ))),
                                  Container(
                                    height: 1,
                                    width: 180,
                                    margin:
                                        EdgeInsets.only(top: 15, bottom: 15),
                                    color: Colors.teal,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: MaterialButton(
                                      minWidth: 256,
                                      height: 56,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14.0)),
                                      splashColor: Colors.white12,
                                      color: Colors.teal,
                                      elevation: 0,
                                      highlightElevation: 0,
                                      child: Text(
                                        //_currentUser != null
                                        //    ? "เริ่มทำแบบทดสอบ"
                                        //    : "ลงชื่อเข้าใช้",
                                        '$_mainBtn',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'SukhumvitSet',
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        if (_mainBtn.contains("กำลังโหลด..")) {
                                        } else if (_currentUser == null) {
                                          final result = Navigator.push(
                                              context,
                                              TransparentRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      prefix0.PopupRoute(
                                                          setTextBtn,
                                                          loadTextBtn,
                                                          cupertinoDialog,
                                                          getAction,
                                                          initDialog,
                                                          hideDialog,
                                                          _currentUser,
                                                          _account
                                                          /*callback: () {
                                                    _checkSignIn();
                                                  },*/
                                                          )));
                                        } else {
                                          Navigator.push(
                                              context,
                                              //MaterialPageRoute(builder: (context) => SecondRoute()),
                                              HomeRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          HomePage()));
                                        }

                                        //print(result.toString());
                                        //if (result.toString().contains("RELOAD")) {
                                        //  _checkSignIn();
                                        //}
                                        /*Navigator.of(context).push(TransparentRoute(

                                        builder: (BuildContext context) =>
                                            SecondRoute()));
*/
                                        /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SecondRoute()),
                                    );*/
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              height: _isIPhoneX(MediaQuery.of(context))
                                  ? 116.00 + 22.00
                                  : 116.00,
                              color: Colors.transparent,
                              width: MediaQuery.of(context).size.width - 35,
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Opacity(
                                    opacity: _isIPhoneX(MediaQuery.of(context))
                                        ? 1.0
                                        : 0.0,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        height: 6,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3)),
                                            color: Colors.white),
                                        child: Container(),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: Stack(
                                      children: <Widget>[
                                        Hero(
                                            tag: "BottomCard",
                                            child: Stack(
                                              children: <Widget>[
                                                //ACTIVE
                                                Opacity(
                                                    opacity:
                                                        _currentUser != null
                                                            ? 1.0
                                                            : 0.0,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 0.0,
                                                      ),
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft:
                                                                      const Radius
                                                                              .circular(
                                                                          24.0),
                                                                  topRight:
                                                                      const Radius
                                                                              .circular(
                                                                          24.0)),
                                                              color:
                                                                  Colors.white),
                                                          child: FlatButton(
                                                            splashColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onPressed: () {
                                                              if (_mainBtn.contains(
                                                                  "กำลังโหลด..")) {
                                                              } else {
                                                                Navigator.push(
                                                                    context,
                                                                    TransparentRoute(
                                                                        builder: (BuildContext context) => prefix0.PopupRoute(
                                                                            setTextBtn,
                                                                            loadTextBtn,
                                                                            cupertinoDialog,
                                                                            getAction,
                                                                            initDialog,
                                                                            hideDialog,
                                                                            _currentUser,
                                                                            _account
                                                                            //callback:
                                                                            //    () {},
                                                                            )));
                                                              }
                                                            },
                                                            child: Container(
                                                                child: Padding(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            15.0,
                                                                            14.0,
                                                                            15.0,
                                                                            0.0),
                                                                    child:
                                                                        Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Text(
                                                                              //'ชัยวิวัฒน์ กกสันเทียะ',
                                                                              '$_firstName $_lastname',
                                                                              textAlign: TextAlign.left,
                                                                              style: TextStyle(fontFamily: 'SukhumvitSet', fontSize: 23, color: Colors.teal[600].withOpacity(0.8), fontWeight: FontWeight.bold),
                                                                            ),
                                                                            Text(
                                                                              'ประเภท: $_userStatus',
                                                                              textAlign: TextAlign.left,
                                                                              style: TextStyle(fontFamily: 'SukhumvitSet', fontSize: 17, color: Colors.black45, fontWeight: FontWeight.w700),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        Align(
                                                                            alignment:
                                                                                Alignment.topRight,
                                                                            child: Container(
                                                                              height: 60,
                                                                              width: 60,
                                                                              color: Colors.transparent,
                                                                              padding: EdgeInsets.all(9),
                                                                              child: FlatButton(
                                                                                  onPressed: null,
                                                                                  padding: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
                                                                                  child: Image.asset(
                                                                                    'images/settings.png',
                                                                                    color: Colors.black45,
                                                                                    fit: BoxFit.contain,
                                                                                  )),
                                                                            )),
                                                                      ],
                                                                    ))),
                                                          )),
                                                    )),

                                                //INACTIVE
                                                Opacity(
                                                    opacity:
                                                        _currentUser != null
                                                            ? 0.0
                                                            : 1.0,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 0.0,
                                                      ),
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft:
                                                                      const Radius
                                                                              .circular(
                                                                          24.0),
                                                                  topRight:
                                                                      const Radius
                                                                              .circular(
                                                                          24.0)),
                                                              color:
                                                                  Colors.white),
                                                          child: FlatButton(
                                                            splashColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onPressed: () {
                                                              if (_mainBtn.contains(
                                                                  "กำลังโหลด..")) {
                                                              } else {
                                                                Navigator.push(
                                                                    context,
                                                                    TransparentRoute(
                                                                        builder: (BuildContext context) => prefix0.PopupRoute(
                                                                            setTextBtn,
                                                                            loadTextBtn,
                                                                            cupertinoDialog,
                                                                            getAction,
                                                                            initDialog,
                                                                            hideDialog,
                                                                            _currentUser,
                                                                            _account
                                                                            //callback:
                                                                            //    () {},
                                                                            )));
                                                              }
                                                            },
                                                            child: Container(
                                                                child: Padding(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            15.0,
                                                                            14.0,
                                                                            15.0,
                                                                            0.0),
                                                                    child:
                                                                        Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                              alignment: Alignment.center,
                                                                              padding: EdgeInsets.only(top: 15),
                                                                              child: Text(
                                                                                'กรุณาลงชื่อเข้าใช้งาน',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(fontFamily: 'SukhumvitSet', fontSize: 21, color: Colors.black54.withOpacity(0.8), fontWeight: FontWeight.bold),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ))),
                                                          )),
                                                    )),
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        ),
                      )
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
