part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

abstract class AuthenticationDelegate {
  void onSuccess(String message);

  void onError(String message);
}

class FacebookLoginEvent extends AuthenticationEvent {}

class GoogleLoginEvent extends AuthenticationEvent {}

class AuthenticatingLoginEvent extends AuthenticationEvent {
  String message;
  AuthenticatingLoginEvent(this.message);
}

class AppleLoginEvent extends AuthenticationEvent {}

class UnAuthenticatingLoginEvent extends AuthenticationEvent {}

class TestEvent extends AuthenticationEvent {
  BuildContext context;

  TestEvent(this.context);
}
