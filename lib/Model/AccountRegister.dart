import 'package:firebase_auth/firebase_auth.dart';
import 'package:frailty_project_2019/Model/Account.dart';

class AccountRegister {

  final int id;

  final FirebaseUser fbUser;
  final Account account;
  final String loginType;

  AccountRegister(this.fbUser, this.account,this.loginType,{this.id});


}