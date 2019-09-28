import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frailty_project_2019/Model/Account.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

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
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AuthenticatingLogin) {
      yield* _mapAuthenticatingToState();
    } else if (event is FacebookLogin) {
    } else if (event is GoogleLogin) {
      yield* _mapGoogleLoginToState();
    }else if (event is UnAuthenticatingLogin){
      yield* _mapUnAuthenticatingToState();
    }
  }

  Stream<AuthenticationState> _mapUnAuthenticatingToState() async*{
    yield AuthenticatingState();
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

    yield AuthenticatingState();

    try {
      print("fakeskadk");
      Account _google = await _googleSignIn.signIn().catchError((onError) {
        //await _googleSignIn.signInSilently().catchError((onError) {
        print("Error $onError");
      }).whenComplete(() async*{
      }).then((onValue) async {
        if (onValue != null) {
          final GoogleSignInAuthentication googleAuth = await onValue.authentication;
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
            if(onValueAccount != null){
              print("signed in " + onValueAccount.user.displayName);
              String url =
                  'https://melondev-frailty-project.herokuapp.com/api/account/showDetailFromId';
              Map map = {"id": "", "oauth": onValueAccount.user.uid.toString()};
              var response = await http.post(url, body: map);
              //print('Response status: ${response.statusCode}');
              //print('Response body: ${response.body}');

              Account account = Account.fromJson(jsonDecode(response.body));
              return account;
            }else {
              return null;
            }
          });
          return firebase;
        }else {
          return null;
          print("asdka[qq");
        }
      }).catchError((onError){
        return null;
      });

      if(_google != null){
        yield AuthenticatedState(_google);
      }else {
        yield UnAuthenticationState();
      }

/*
      if (_googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await _googleUser.authentication;

        final FirebaseUser user = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.getCredential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken))
            .whenComplete(() {
          //page?._callback();
          print("T2");
        }).catchError((onError) {
          print("error $onError");
        }).then((onValue) {
          print("T4");

          //page._hideProgressDialog();
        });


        if (user != null) {
          print("T6");

          print("signed in " + user.displayName);


          return user;
        }
      }*/

    } catch (error) {
      yield ErrorAuthenticationState(error.toString());
    }

  }

  Stream<AuthenticationState> _mapAuthenticatingToState() async* {
    try {
      yield AuthenticatingState();
      var _auth = await _firebaseAuth.currentUser().then((onValue) async {
        if (onValue != null) {
          String url =
              'https://melondev-frailty-project.herokuapp.com/api/account/showDetailFromId';
          Map map = {"id": "", "oauth": onValue.uid.toString()};
          var response = await http.post(url, body: map);
          //print('Response status: ${response.statusCode}');
          //print('Response body: ${response.body}');

          Account account = Account.fromJson(jsonDecode(response.body));
          return account;
        } else {
          return null;
        }
      });
      if(_auth != null){
        yield AuthenticatedState(_auth);
      }else {
        yield UnAuthenticationState();
      }
    } catch (error) {
      yield ErrorAuthenticationState(error.toString());
    }
  }
}
