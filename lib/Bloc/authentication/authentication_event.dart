part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

abstract class AuthenticationDelegate {
  void onSuccess(String message);

  void onError(String message);
}

class GoogleLoginEvent extends AuthenticationEvent {
  final BuildContext context;
  final bool personnel;
  final String pin;
  final bool isUpgrade;

  final Account account;

  GoogleLoginEvent(this.context,this.personnel,{this.pin,this.account,this.isUpgrade});
}
class AppleLoginEvent extends AuthenticationEvent {
  final BuildContext context;
  final bool personnel;
  final String pin;
  final Account account;
  final bool isUpgrade;


  AppleLoginEvent(this.context,this.personnel,{this.pin,this.account,this.isUpgrade});


}
class IdentifyLoginEvent extends AuthenticationEvent {}

class DatabaseRefreshEvent extends AuthenticationEvent {
  final Account account;

  DatabaseRefreshEvent(this.account);
}

class DeleteHistoryDatabase extends AuthenticationEvent {
  final Account account;

  DeleteHistoryDatabase(this.account);
}

class ResumeGoogleAuthenticationEvent extends AuthenticationEvent {
  final Account account;

  ResumeGoogleAuthenticationEvent(this.account);
}

class AuthenticatingLoginEvent extends AuthenticationEvent {
  final String message;
  final BuildContext context;

  AuthenticatingLoginEvent(this.message,this.context);
}

class UnAuthenticatingLoginEvent extends AuthenticationEvent {}

class TestEvent extends AuthenticationEvent {
  final BuildContext context;

  TestEvent(this.context);
}
