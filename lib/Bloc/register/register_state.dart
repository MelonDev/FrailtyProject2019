part of 'register_bloc.dart';

@immutable
abstract class RegisterState {
  final AccountRegister account;


  RegisterState(this.account);
}

class NoRegisterState extends RegisterState {
  NoRegisterState() : super(null);

  @override
  String toString() {
    return "NoRegisterState";
  }
}

class MainLoginRegisterState extends RegisterState {
  MainLoginRegisterState() : super(null);

  @override
  String toString() {
    return "MainLoginRegisterState";
  }
}

class LoginRegisterState extends RegisterState {

  final bool isUpgrade;
  final Account mAccount;

  LoginRegisterState(this.isUpgrade,{this.mAccount})  : super(null);

  @override
  String toString() {
    return "LoginRegisterState";
  }
}

class PinRegisterState extends RegisterState {
  PinRegisterState()  : super(null);

  @override
  String toString() {
    return "PinRegisterState";
  }
}

class InsertInfoRegisterState extends RegisterState {
  final String firstName;
  final String lastName;
  final DateTime dateTime;

  InsertInfoRegisterState(AccountRegister account,{this.firstName, this.lastName, this.dateTime}) : super(account);

  @override
  String toString() {
    return "InsertInfoRegisterState";
  }
}

class UpgradeRegisterState extends RegisterState {
  final String firstName;
  final String lastName;
  final DateTime dateTime;

  UpgradeRegisterState(AccountRegister account,{this.firstName, this.lastName, this.dateTime}) : super(account);

  @override
  String toString() {
    return "UpgradeRegisterState";
  }
}

class LoadingRegisterState extends RegisterState {
  LoadingRegisterState() : super(null);

  @override
  String toString() {
    return "LoadingRegisterState";
  }
}

class RegisterSuccessState extends RegisterState {
  RegisterSuccessState() : super(null);

  @override
  String toString() {
    return "RegisterSuccessState";
  }
}

class RegisterErrorState extends RegisterState {

  final String message;
  final int id;
  final AccountRegister account;

  RegisterErrorState(this.message,{this.id,this.account}) : super(null);

  @override
  String toString() {
    return "RegisterErrorState";
  }
}

class AddressRegisterState extends RegisterState {
  final List<AddressDao> listAddress;
  final String firstName;
  final String lastName;
  final DateTime dateTime;

  AddressRegisterState(AccountRegister account,
      {this.listAddress, this.firstName, this.lastName, this.dateTime}) : super(account);

  @override
  String toString() {
    return "AddressRegisterState";
  }
}
