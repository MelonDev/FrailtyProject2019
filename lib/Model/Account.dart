import 'package:intl/intl.dart';

class Account {
  final String id;
  final String firstName;
  final String lastName;
  final String subDistrict;
  final String district;
  final String province;
  final String department;
  String email;
  final String loginType;
  final String oAuthId;

  final DateTime birthDate;
  final bool personnel;

  Account({this.id, this.firstName, this.lastName, this.subDistrict,this.district, this.province, this.department, this.email,this.loginType, this.oAuthId, this.birthDate, this.personnel});

  Account.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        province = json['province'],
        birthDate =
            DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(json['birthDate']),
        department = json['department'],
        subDistrict = json['subDistrict'],
        oAuthId = json['oAuthId'],
        email = json['email'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        personnel = json['personnel'],
        loginType = json['loginType'],
        district = json['district'];



/*
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };
      */
}
