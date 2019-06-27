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
import 'main.dart';
import 'package:progress_dialog/progress_dialog.dart';
//import 'package:http/http.dart' as http;

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
FirebaseAuth _auth = FirebaseAuth.instance;

ProgressDialog dialog;

Future<FirebaseUser> handleSignIn(PopupRoute page, BuildContext context) async {
  try {
    GoogleSignInAccount googleUser;

    await _googleSignIn.signIn().catchError((onError) {
      //await _googleSignIn.signInSilently().catchError((onError) {
      print("Error $onError");
    }).whenComplete(() {
      //dialog.show();
      //dialog.update(message: "กรุณารอสักครู่..");
      //page._dialog(context, "กำลังโหลด..", null, List());
      //page._progressDialog("กำลังโหลด..");
      print("A0");
    }).then((onValue) {
      print("A1");
      if (onValue != null) {
        page._progressDialog("กำลังโหลด..");
        print(onValue);
        googleUser = onValue;
      }
    });

    print("T0");
    print(googleUser == null);
    if (googleUser != null) {
      print("T1");
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final FirebaseUser user = await _auth
          .signInWithCredential(GoogleAuthProvider.getCredential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken))
          .whenComplete(() {
        //page?._callback();
        print("T2");

        Navigator.of(context).pop();
        page.reload(true);
      }).catchError((onError) {
        print("error $onError");
        print("T3");

        //dialog.hide();
      }).then((onValue) {
        print("T4");

        //page._hideProgressDialog();
      });

      print("T5");

      //dialog.hide();
      print("A1");
      Navigator.of(context).pop();

      if (user != null) {
        print("T6");

        print("signed in " + user.displayName);
        //print(user.phoneNumber);
        //print(user.photoUrl);
        //print(user.uid);
        //print(user.email);
        //Navigator.of(context).pop();

        return user;
      }
    }
  } on PlatformException catch (error) {
    print(error);
  } catch (error) {
    print(error);
  }
  /* on PlatformException catch (error) {
    print(error);
  }*/

  return null;
}

void confirmSignOut(BuildContext context, PopupRoute page) async {
  List<Widget> list = [];
  list.add(page._dialogAction("ยกเลิก", false, true, () {
    Navigator.of(context).pop();
  }));
  list.add(page._dialogAction("ยืนยัน", true, true, () {
    signOut(context, page);
  }));

  page._dialog(context, "ยืนยันการลงชื่อออก", null, list);
}

Future signOut(BuildContext context, PopupRoute page) async {
  //var a = await isAuth();

  //page.callback(true);

  //page.reload();
  Navigator.of(context).pop();


  try {
    await _auth.signOut();
    await _googleSignIn.signOut();
    signOutFinish(page);
    print("SignOut Successful");
    Navigator.of(context).pop();
  } catch (error) {
    print(error);
  }
}

signOutFinish(PopupRoute page) {
  print("Finish");
  page.reload(true);
}

/*
void cupertinoDialog(BuildContext context) {
  //Navigator.pop(context);

  var alert = new CupertinoAlertDialog(
    title: new Text("Alert"),
    content: new Text("There was an error signing in. Please try again."),
    actions: <Widget>[
      /*new CupertinoDialogAction(
          child: const Text('Discard'),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          }),*/
      new CupertinoDialogAction(
          child: const Text('Cancel'),
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }),
    ],
  );
  showDialog(context: context, child: alert);
}
*/

void isAuth(PopupRoute page) async {
  var current = await FirebaseAuth.instance.currentUser();

  bool b = current != null;
  page.callback(b);
}

Future<bool> isAuths() async {
  bool isGoogleSigned = await _googleSignIn.isSignedIn();

  return isGoogleSigned;
}

class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
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

/*
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
*/
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
  }
}

class PopupRoute extends StatefulWidget {
  //final _callback; // callback reference holder
  //PopupRoute({@required bool callback()}) : _callback = callback;

  Function(bool) callback;
  Function(bool) reload;

  FirebaseUser _fUser;
  Account _account;

  Function(String) _progressDialog;
  Function() _hideProgressDialog;

  Function(BuildContext, String, String, List<Widget>) _dialog;
  Function(String, bool, bool, Function) _dialogAction;

  PopupRoute(
      this.callback,
      this.reload,
      this._dialog,
      this._dialogAction,
      this._progressDialog,
      this._hideProgressDialog,
      this._fUser,
      this._account);

  @override
  _popupRoute createState() => _popupRoute();
}

int calculatingDay(DateTime date) {
  final year1 = DateTime.now().year;
  final year2 = date.year;
  final difference = year1 - year2;
  if (date.month > DateTime.now().month) {
    return difference - 1;
  } else {
    return difference;
  }
}

Opacity getActive(BuildContext context, PopupRoute widget) {
  return
      //ACTIVE
      Opacity(
    opacity: widget._fUser != null ? 1.0 : 0.0,
    child: Stack(
      children: <Widget>[
        Container(
            height: 65,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 20, top: 10),
                    alignment: Alignment.topRight,
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Center(
                      child: Image.asset(
                        'images/settings.png',
                        fit: BoxFit.contain,
                        height: 25,
                        width: 25,
                        color: Colors.white,
                      ),
                    )),
              ],
            )),
        SingleChildScrollView(child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(top: 20, left: 25, right: 25),
              child: Text(
                  widget._account.firstName + " " + widget._account.lastName,
                  style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                      color: Colors.teal)),
            ),

            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: <Widget>[
                  Text(
                      widget._account.personnel
                          ? "ประเภท : บุคลากร"
                          : "ประเภท : ผู้ใช้งานทั่วไป",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black54)),
                ],
              ),
            ),

            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: <Widget>[
                  Text(
                      "ที่อยู่ : " +
                          "ต." +
                          widget._account.subDistrict +
                          " อ." +
                          widget._account.district +
                          " จ." +
                          widget._account.province,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black54)),
                ],
              ),
            ),

            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 25, right: 25),
              child: Column(
                children: <Widget>[
                  Text(
                      "อายุ : " +
                          calculatingDay(widget._account.birthDate).toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black54)),
                ],
              ),
            ),

            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 25, right: 25, bottom: 10),
              child: Column(
                children: <Widget>[
                  Text("หน่วยงานที่สังกัด : " + widget._account.department,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black54)),
                ],
              ),
            ),

            //แก้ไขชื่อ-นามสกุล
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: Colors.black38,
              margin: EdgeInsets.only(top: 4, left: 25, right: 25),
              child: null,
            ),
            Container(
              alignment: Alignment.center,
              child: Container(
                margin:
                    EdgeInsets.only(top: 16, left: 25, right: 25, bottom: 14),
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: FlatButton(
                  onPressed: () {},
                  child: Text("แก้ไขชื่อ-นามสกุล",
                      style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87)),
                ),
              ),
            ),

            //แก้ไขที่อยู่

            Container(
              alignment: Alignment.center,
              child: Container(
                margin:
                    EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: FlatButton(
                  onPressed: () {},
                  child: Text("แก้ไขที่อยู่",
                      style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87)),
                ),
              ),
            ),

            //อัปเกรดบัญชีผู้ใช้งาน

            Container(
              alignment: Alignment.center,
              child: Container(
                margin:
                    EdgeInsets.only(top: 4, left: 25, right: 25, bottom: 10),
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: FlatButton(
                  onPressed: () {},
                  child: Text("อัปเกรดบัญชีผู้ใช้งาน",
                      style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87)),
                ),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: Colors.black38,
              margin: EdgeInsets.only(top: 10, left: 75, right: 75),
              child: null,
            ),

            Container(
              alignment: Alignment.center,
              child: Container(
                margin:
                    EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 10),
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: FlatButton(
                  splashColor: Colors.white54,
                  onPressed: () {
                    confirmSignOut(context, widget);
                  },
                  child: Text("ลงชื่อออก",
                      style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white)),
                ),
              ),
            ),
          ],
        ),)
      ],
    ),
  );
}

Opacity getInActive(BuildContext context, PopupRoute widget) {
  return //INACTIVE
      Opacity(
    opacity: widget._fUser != null ? 0.0 : 1.0,
    child: SingleChildScrollView(child: Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(top: 20, left: 25, right: 25),
          child: Text("เลือกรูปแบบการเข้าใช้งาน",
              style: TextStyle(
                  fontFamily: 'SukhumvitSet',
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Colors.black87)),
        ),
        //ชื่อนามสกุล
        Container(
          width: MediaQuery.of(context).size.width,
          height: 1,
          color: Colors.black38,
          margin: EdgeInsets.only(top: 10, left: 25, right: 25),
          child: null,
        ),
        Container(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 20),
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: FlatButton(
              onPressed: () {},
              child: Text("ชื่อ-นามสกุล",
                  style: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black87)),
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 80,
              height: 1,
              color: Colors.black38,
              margin: EdgeInsets.only(top: 0, left: 0, right: 20),
              child: null,
            ),
            Container(
                alignment: Alignment.center,
                child: Text("หรือ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black87))),
            Container(
              width: 80,
              height: 1,
              color: Colors.black38,
              margin: EdgeInsets.only(left: 20),
              child: null,
            ),
          ],
        ),

        //google
        Container(
          child: Container(
            margin: EdgeInsets.only(top: 25, left: 25, right: 25),
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10.0,
                  ),
                ]),
            child: FlatButton(
                onPressed: () {
                  handleSignIn(widget, context);
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 6),
                      child: Image.asset(
                        'images/search-4.png',
                        fit: BoxFit.contain,
                        height: 30,
                        width: 30,
                      ),
                    ),
                    Center(
                      child: Text("กูเกิล",
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black87)),
                    )
                  ],
                )),
          ),
        ),

        //Facebook
        Container(
          child: Container(
            margin: EdgeInsets.only(top: 25, left: 25, right: 25),
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFF1465C3),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: FlatButton(
                splashColor: Colors.white30,
                onPressed: () {},
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 6),
                      child: Image.asset(
                        'images/facebook.png',
                        fit: BoxFit.contain,
                        height: 30,
                        width: 30,
                      ),
                    ),
                    Center(
                      child: Text("เฟสบุ๊ค",
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white)),
                    )
                  ],
                )),
          ),
        ),
      ],
    ),)
  );
}

class _popupRoute extends State<PopupRoute> {
  @override
  Widget build(BuildContext context) {
    //signOut(context, widget);
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.0),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 20.0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.3)),
                    child: Stack(
                      children: <Widget>[
                        FlatButton(
                          splashColor: Colors.transparent,
                          color: Colors.transparent,
                          child: Container(),
                          onPressed: () {
                            //Navigator.pop(context);
                            Navigator.of(context).pop();
                          },
                        ),
                        SafeArea(
                            child: Column(
                          children: <Widget>[
                            Center(
                                child: Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                'แตะเพื่อปิดหน้าต่าง',
                                style: TextStyle(
                                    fontFamily: 'SukhumvitSet',
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            )),
                            Expanded(
                              child: Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Hero(
                                      /*
                                    flightShuttleBuilder: (flightContext,
                                        animation,
                                        direction,
                                        fromContext,
                                        toContext) {
                                      final Hero toHero = toContext.widget;

                                      return FadeTransition(

                                        opacity: Tween<double>(begin: 0, end: 1)
                                            .animate(animation),
                                        child: Semantics(

                                          scopesRoute: true,
                                          explicitChildNodes: true,
                                          child: toHero,
                                        ),
                                      );
                                    },*/
                                      tag: "BottomCard",
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(24)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 10.0,
                                                ),
                                              ]),
                                          margin: EdgeInsets.only(bottom: 20),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              35,
                                          height:
                                              widget._fUser != null ? 530 : 410,
                                          child: Stack(
                                            children: <Widget>[
                                              widget._fUser != null
                                                  ? getActive(context, widget)
                                                  : getInActive(context, widget)
                                            ],
                                          )))),
                            )
                          ],
                        ))
                      ],
                    )),
              ),
            ),
          ),
        ));
  }
}
