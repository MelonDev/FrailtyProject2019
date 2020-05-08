
import 'package:frailty_project_2019/Model/Account.dart';

class Value {
  final Account value;
  final String status;

  Value({this.value, this.status});

  factory Value.fromJson(Map<String, dynamic> json) {
    return new Value(
        value: Account.fromJson(json['value']),
        status: json['status']
    );
  }

  /*
  factory Value.fromMap(Map map) {
    return new Value(
        id: map['id'] as String,
        fromId: map['fromId'] as String
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "fromId": fromId
  };
  
   */
}
