import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frailty_project_2019/Model/Account.dart';
import 'package:frailty_project_2019/Model/Version.dart';
import 'package:frailty_project_2019/Tools/frailty_route.dart';
import 'package:frailty_project_2019/database/OfflineStaticDatabase.dart';
import 'package:frailty_project_2019/database/OnDeviceQuestionnaires.dart';
import 'package:frailty_project_2019/database/OnLocalDatabase.dart';
import 'package:frailty_project_2019/home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    } else if (event is DatabaseRefreshEvent) {
      yield* _mapDatabaseRefreshingToState(event);
    } else if (event is DeleteHistoryDatabase) {
      yield* _mapDatabaseHistoryToState(event);
    }
  }

  Stream<AuthenticationState> _mapUnAuthenticatingToState() async* {
    yield AuthenticatingState(message: "กำลังชื่อออก");
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.remove("ACCOUNT_USER_ID");
      preferences.remove("ACCOUNT_USER_FIRSTNAME");
      preferences.remove("ACCOUNT_USER_LASTNAME");
      preferences.remove("ACCOUNT_USER_PROVINCE");
      preferences.remove("ACCOUNT_USER_DISTRICT");
      preferences.remove("ACCOUNT_USER_SUBDISREICT");
      preferences.remove("ACCOUNT_USER_EMAIL");
      preferences.remove("ACCOUNT_USER_LOGINTYPE");
      preferences.remove("ACCOUNT_USER_OAUTHID");
      preferences.remove("ACCOUNT_USER_PERSONNEL");
      preferences.remove("ACCOUNT_USER_DEPARTMENT");
      preferences.remove("ACCOUNT_USER_BIRTHDATE");
      print("SignOut Successful");
      yield UnAuthenticationState();
    } catch (error) {
      print(error);
    }
  }

  Stream<AuthenticationState> _mapDatabaseRefreshingToState(DatabaseRefreshEvent event) async* {
    yield DatabaseRefreshingState(message: "กำลังลบฐานข้อมูล..");

    yield DatabaseRefreshingState(message: "กำลังโหลดฐานข้อมูล..");
    await OnDeviceQuestionnaires().afterLogin();

    yield AuthenticatedState(account: event.account);

  }

  Stream<AuthenticationState> _mapDatabaseHistoryToState(DeleteHistoryDatabase event) async* {
    yield DatabaseRefreshingState(message: "กำลังลบประวัติ..");

    await OnLocalDatabase().deleteHistory();

    await Future.delayed(Duration(seconds: 2));

    yield AuthenticatedState(account: event.account);
  }

  Stream<AuthenticationState> _mapGoogleLoginToState() async* {
    yield AuthenticatingState(message: "กำลังล็อคอิน..");

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
        var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("ACCOUNT_USER_ID", _google.id);
        preferences.setString("ACCOUNT_USER_FIRSTNAME", _google.firstName);
        preferences.setString("ACCOUNT_USER_LASTNAME", _google.lastName);
        preferences.setString("ACCOUNT_USER_PROVINCE", _google.province);
        preferences.setString("ACCOUNT_USER_DISTRICT", _google.district);
        preferences.setString("ACCOUNT_USER_SUBDISREICT", _google.subDistrict);
        preferences.setString("ACCOUNT_USER_EMAIL", _google.email);
        preferences.setString("ACCOUNT_USER_LOGINTYPE", _google.loginType);
        preferences.setString("ACCOUNT_USER_OAUTHID", _google.oAuthId);
        preferences.setBool("ACCOUNT_USER_PERSONNEL", _google.personnel);
        preferences.setString("ACCOUNT_USER_DEPARTMENT", _google.department);
        preferences.setString(
            "ACCOUNT_USER_BIRTHDATE", formatter.format(_google.birthDate));

        yield AuthenticatingState(message: "กำลังโหลดฐานข้อมูล..");
        await OnDeviceQuestionnaires().afterLogin();
        yield AuthenticatedState(account: _google);
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
      bool connected = await _checkInternetConnection() ?? false;

      if (connected) {
        if (event.context != null) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          final bool customDarkMode = preferences.getBool("CUSTOM_DARKMODE");

          if (customDarkMode == null) {
            preferences.setBool("CUSTOM_DARKMODE", false);
            DynamicTheme.of(event.context)
                .setBrightness(MediaQuery.of(event.context).platformBrightness);
          } else {
            if (!customDarkMode) {
              DynamicTheme.of(event.context).setBrightness(
                  MediaQuery.of(event.context).platformBrightness);
            }
          }
        }

        if (event.message == null) {
          yield AuthenticatingState(message: "กำลังล็อคอิน..");
        } else {
          yield AuthenticatingState(message: event.message);
        }

        var _auth = await _firebaseAuth.currentUser().then((onValue) async {
          if (onValue != null) {
            return loadAccountFromHeroku(onValue);
          } else {
            return null;
          }
        });

        yield AuthenticatingState(message: "กำลังตรวจสอบฐานข้อมูล..");

        if (_auth != null) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString("USER_ID", _auth.id.toUpperCase());

          yield AuthenticatedState(account: _auth);
        } else {
          yield UnAuthenticationState();
        }
      } else {
        var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");

        SharedPreferences preferences = await SharedPreferences.getInstance();
        print(preferences.getString("ACCOUNT_USER_BIRTHDATE"));
        Account account = Account(
            id: preferences.getString("ACCOUNT_USER_ID"),
            firstName: preferences.getString("ACCOUNT_USER_FIRSTNAME"),
            lastName: preferences.getString("ACCOUNT_USER_LASTNAME"),
            province: preferences.getString("ACCOUNT_USER_PROVINCE"),
            district: preferences.getString("ACCOUNT_USER_DISTRICT"),
            subDistrict: preferences.getString("ACCOUNT_USER_SUBDISREICT"),
            email: preferences.getString("ACCOUNT_USER_EMAIL"),
            loginType: preferences.getString("ACCOUNT_USER_LOGINTYPE"),
            oAuthId: preferences.getString("ACCOUNT_USER_OAUTHID"),
            personnel: preferences.getBool("ACCOUNT_USER_PERSONNEL"),
            department: preferences.getString("ACCOUNT_USER_DEPARTMENT"),
            birthDate: formatter
                .parse(preferences.getString("ACCOUNT_USER_BIRTHDATE")));

        yield AuthenticatedState(account: account, isOffline: true);
      }
    } catch (error) {
      print(error);
      yield ErrorAuthenticationState(error.toString());
    }
  }

  Stream<AuthenticationState> _mapDownloadingToState() async* {
    try {
      yield AuthenticatingState(message: "กำลังล็อคอิน..");
      var _auth = await _firebaseAuth.currentUser().then((onValue) async {
        if (onValue != null) {
          return loadAccountFromHeroku(onValue);
        } else {
          return null;
        }
      });
      if (_auth != null) {
        yield AuthenticatedState(account: _auth);
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

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      preferences.setBool("APP_IS_OFFLINE", true);

      return true;
    } else {
      preferences.setBool("APP_IS_OFFLINE", false);
      return false;
    }
  }
}
