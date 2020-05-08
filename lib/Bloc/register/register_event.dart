part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class NoRegisterEvent extends RegisterEvent {}
class MainLoginEvent extends RegisterEvent {}
class MiniLoginEvent extends RegisterEvent {}
class PinEvent extends RegisterEvent {
  final BuildContext context;

  PinEvent(this.context);


}
class InputInfoEvent extends RegisterEvent {
  final BuildContext context;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final AccountRegister account;

  InputInfoEvent(this.context,this.account,{this.firstName,this.lastName,this.birthDate});
}

class UpgradeToPersonnelEvent extends RegisterEvent {
  final BuildContext context;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final AccountRegister account;

  UpgradeToPersonnelEvent(this.context,this.account,{this.firstName,this.lastName,this.birthDate});
}

class CheckPinEvent extends RegisterEvent {
  final BuildContext context;

  final String pin;
  final bool isUpgrade;
  final Account account;

  CheckPinEvent(this.context,this.pin,{this.isUpgrade,this.account});

}


class LoadingEvent extends RegisterEvent {}

class AddressEvent extends RegisterEvent {

  final BuildContext context;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final AccountRegister account;

  AddressEvent(this.account,{this.context,this.firstName,this.lastName,this.birthDate});

}

class UpgradeEvent extends RegisterEvent {

  final BuildContext context;

  UpgradeEvent(this.context);

}

class SearchingEvent extends RegisterEvent {

  final BuildContext context;

  final String searchMessage;
  final AccountRegister account;


  SearchingEvent(this.account,{this.context,this.searchMessage});

}

class StartRegisterEvent extends RegisterEvent {

  final BuildContext context;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final AccountRegister account;
  final AddressDao addressDao;
  final String department;
  final String pin;
  final bool personnel;

  StartRegisterEvent(this.account,this.firstName,this.lastName,this.birthDate,this.addressDao,{this.context,this.department,this.pin,this.personnel});

}

class StartUpgradeEvent extends RegisterEvent {

  final BuildContext context;
  final AccountRegister account;
  final String department;

  StartUpgradeEvent(this.context,this.account,this.department);

}




