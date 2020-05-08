import 'dart:io';

import 'package:device_info/device_info.dart';

class AppleSignInDetect {

  Future<bool> isSupport() async{
    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;
      var version = iosInfo.systemVersion;

      if (version.contains('13') == true) {
        return true;
      }
    }
    return false;
  }

}