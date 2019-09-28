part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}


class InitialAuthenticationState extends AuthenticationState {
  @override
  String toString() {
    return "InitialAuthenticationState";
  }
}

class AuthenticatedState extends AuthenticationState {

  final Account account;

  AuthenticatedState(this.account);

  @override
  String toString() {
    return "AuthenticatedState";
  }
}

class UnAuthenticationState extends AuthenticationState {
  @override
  String toString() {
    return "UnAuthenticationState";
  }
}

class AuthenticatingState extends AuthenticationState {
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