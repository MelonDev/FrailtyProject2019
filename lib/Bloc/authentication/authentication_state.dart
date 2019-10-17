part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class MyAuthenticationState extends AuthenticationState {
  final bool isOffline;

  MyAuthenticationState(this.isOffline);
}


class InitialAuthenticationState extends AuthenticationState {

  @override
  String toString() {
    return "InitialAuthenticationState";
  }
}

class AuthenticatedState extends MyAuthenticationState {

  final Account account;

  AuthenticatedState({@required this.account,isOffline}) : super(isOffline);

  @override
  String toString() {
    return "AuthenticatedState";
  }
}

class UnAuthenticationState extends MyAuthenticationState {

  UnAuthenticationState({isOffline}) : super(isOffline);

  @override
  String toString() {
    return "UnAuthenticationState";
  }
}

class AuthenticatingState extends AuthenticationState {

  final String message;

  AuthenticatingState({@required this.message});

  @override
  String toString() {
    return "AuthenticatingState";
  }
}

class ErrorAuthenticationState extends AuthenticationState {

  final String error;


  ErrorAuthenticationState(this.error);

  @override
  String toString() {
    return "ErrorAuthenticationState: $error";
  }

}