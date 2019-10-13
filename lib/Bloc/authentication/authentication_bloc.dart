import 'dart:async';
import 'dart:convert';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:bloc/bloc.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frailty_project_2019/Model/Account.dart';
import 'package:frailty_project_2019/Model/Version.dart';
import 'package:frailty_project_2019/Tools/frailty_route.dart';
import 'package:frailty_project_2019/database/OfflineStaticDatabase.dart';
import 'package:frailty_project_2019/database/OnDeviceQuestionnaires.dart';
import 'package:frailty_project_2019/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  var _firebaseAuth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  AuthenticationState get initialState => InitialAuthenticationState();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticatingLoginEvent) {
      yield* _mapAuthenticatingToState(event);
    } else if (event is AppleLoginEvent) {
    } else if (event is FacebookLoginEvent) {
    } else if (event is GoogleLoginEvent) {
      yield* _mapGoogleLoginToState();
    } else if (event is UnAuthenticatingLoginEvent) {
      yield* _mapUnAuthenticatingToState();
    } else if (event is TestEvent) {
      goToQuestion(event.context);
    }
  }

  Stream<AuthenticationState> _mapUnAuthenticatingToState() async* {
    yield AuthenticatingState("กำลังชื่อออก");
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      print("SignOut Successful");
      yield UnAuthenticationState();
    } catch (error) {
      print(error);
    }
  }

  Stream<AuthenticationState> _mapGoogleLoginToState() async* {
    yield AuthenticatingState("กำลังล็อคอิน..");

    try {
      Account _google = await _googleSignIn
          .signIn()
          .catchError((onError) {})
          .whenComplete(() async* {})
          .then((onValue) async {
        if (onValue != null) {
          final GoogleSignInAuthentication googleAuth =
              await onValue.authentication;
          var firebase = await _firebaseAuth
              .signInWithCredential(GoogleAuthProvider.getCredential(
                  idToken: googleAuth.idToken,
                  accessToken: googleAuth.accessToken))
              .whenComplete(() {
            print("T2");
          }).catchError((onError) {
            print("error $onError");
            return null;
          }).then((onValueAccount) async {
            print("T4");
            if (onValueAccount != null) {
              return loadAccountFromHeroku(onValueAccount.user);
            } else {
              return null;
            }
          });
          return firebase;
        } else {
          return null;
        }
      }).catchError((onError) {
        return null;
      });

      if (_google != null) {
        yield AuthenticatingState("กำลังโหลดฐานข้อมูล..");
        await OnDeviceQuestionnaires().afterLogin();
        yield AuthenticatedState(_google);
      } else {
        yield UnAuthenticationState();
      }
    } catch (error) {
      yield ErrorAuthenticationState(error.toString());
    }
  }

  Stream<AuthenticationState> _mapAuthenticatingToState(
      AuthenticatingLoginEvent event) async* {
    try {
      if (event.message == null) {
        yield AuthenticatingState("กำลังล็อคอิน..");
      } else {
        yield AuthenticatingState(event.message);
      }
      var _auth = await _firebaseAuth.currentUser().then((onValue) async {
        if (onValue != null) {
          return loadAccountFromHeroku(onValue);
        } else {
          return null;
        }
      });

      yield AuthenticatingState("กำลังตรวจสอบฐานข้อมูล..");
      //Database database = await OfflineStaticDatabase().initDatabase();

      //await OfflineStaticDatabase().onVersionProcess();
      /*
      List<Version> list = await OfflineStaticDatabase().getVersionDatabase();
      for (var i in list){
        print(i.id);
        print(i.version);
      }
      if(list != null){
        print(list.length);
      }else {
        print("sdkaskdk");

      }

       */

      if (_auth != null) {
        yield AuthenticatedState(_auth);
      } else {
        yield UnAuthenticationState();
      }
    } catch (error) {
      yield ErrorAuthenticationState(error.toString());
    }
  }

  Stream<AuthenticationState> _mapDownloadingToState() async* {
    try {
      yield AuthenticatingState("กำลังล็อคอิน..");
      var _auth = await _firebaseAuth.currentUser().then((onValue) async {
        if (onValue != null) {
          return loadAccountFromHeroku(onValue);
        } else {
          return null;
        }
      });
      if (_auth != null) {
        yield AuthenticatedState(_auth);
      } else {
        yield UnAuthenticationState();
      }
    } catch (error) {
      yield ErrorAuthenticationState(error.toString());
    }
  }

  Future<Account> loadAccountFromHeroku(FirebaseUser user) async {
    String url =
        'https://melondev-frailty-project.herokuapp.com/api/account/showDetailFromId';
    Map map = {"id": "", "oauth": user.uid.toString()};
    var response = await http.post(url, body: map);
    Account account = Account.fromJson(jsonDecode(response.body));
    return account;
  }

  void goToQuestion(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
          context, FrailtyRoute(builder: (BuildContext context) => HomePage()));
    });
    //Navigator.push(
    //    context, FrailtyRoute(builder: (BuildContext context) => HomePage()));
  }
}
