part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

abstract class AuthenticationDelegate {
  void onSuccess(String message);

  void onError(String message);
}

class FacebookLoginEvent extends AuthenticationEvent {}

class GoogleLoginEvent extends AuthenticationEvent {}

class DatabaseRefreshEvent extends AuthenticationEvent {
  final Account account;

  DatabaseRefreshEvent(this.account);
}

class DeleteHistoryDatabase extends AuthenticationEvent {
  final Account account;

  DeleteHistoryDatabase(this.account);
}



class AuthenticatingLoginEvent extends AuthenticationEvent {
  String message;
  BuildContext context;

  AuthenticatingLoginEvent(this.message,this.context);
}

class AppleLoginEvent extends AuthenticationEvent {}

class UnAuthenticatingLoginEvent extends AuthenticationEvent {}

class TestEvent extends AuthenticationEvent {
  BuildContext context;

  TestEvent(this.context);
}
