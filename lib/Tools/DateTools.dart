import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTools {

  String getName(int month){
    String strMonth = "";
    switch(month){
      case 1 : {
        strMonth = "มกราคม";
        break;
      }
      case 2 : {
        strMonth = "กุมภาพันธ์";
        break;
      }
      case 3 : {
        strMonth = "มีนาคม";
        break;
      }
      case 4 : {
        strMonth = "เมษายน";
        break;
      }
      case 5 : {
        strMonth = "พฤษภาคม";
        break;
      }
      case 6 : {
        strMonth = "มิถุนายน";
        break;
      }
      case 7 : {
        strMonth = "กรกฏาคม";
        break;
      }
      case 8 : {
        strMonth = "สิงหาคม";
        break;
      }
      case 9 : {
        strMonth = "กันยายน";
        break;
      }
      case 10 : {
        strMonth = "ตุลาคม";
        break;
      }
      case 11 : {
        strMonth = "พฤศจิกายน";
        break;
      }
      case 12 : {
        strMonth = "ธันวาคม";
        break;
      }


    }
    return strMonth;
  }

 /*String dateToString(DateTime dateTime){
    print(dateTime);
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(dateTime);
    print(formatted);
    return formatted;
  }

  */

  String stringDateToString(String dateTime){
    var parsedDate = DateTime.parse(dateTime);
    print(dateTime);
    print(parsedDate);
    //print(dateTime);
    //var formatter = new DateFormat('yyyy-MM-dd');
    //String formatted = formatter.format(dateTime);
    //print(formatted);
    //return formatted;
    return "";
  }

}