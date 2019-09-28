part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

abstract class AuthenticationDelegate {
  void onSuccess(String message);
  void onError(String message);
}

class FacebookLogin extends AuthenticationEvent {

}

class GoogleLogin extends AuthenticationEvent {

}

class AuthenticatingLogin extends AuthenticationEvent {

}

class UnAuthenticatingLogin extends AuthenticationEvent {

}