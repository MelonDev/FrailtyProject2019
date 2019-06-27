import 'package:intl/intl.dart';

class TemporaryCode {
  final String id;
  final String pinCode;
  final DateTime expiredDate;
  final DateTime startDate;

  TemporaryCode(this.id, this.pinCode, this.expiredDate, this.startDate);

  TemporaryCode.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        pinCode = json['pinCode'],
        expiredDate =
            DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(json['expiredDate']),
        startDate =
            DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(json['startDate']);

/*
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };
      */
}
