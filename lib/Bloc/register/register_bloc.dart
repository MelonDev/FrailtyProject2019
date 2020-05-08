import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_thailand_provinces/dao/address_dao.dart';
import 'package:flutter_thailand_provinces/provider/address_provider.dart';
import 'package:frailty_project_2019/Bloc/authentication/authentication_bloc.dart';
import 'package:frailty_project_2019/Model/Account.dart';
import 'package:frailty_project_2019/Model/AccountRegister.dart';
import 'package:frailty_project_2019/Model/OnBool.dart';
import 'package:frailty_project_2019/Model/ReturnHTTP.dart';
import 'package:frailty_project_2019/Model/Value.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  @override
  RegisterState get initialState => NoRegisterState();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is NoRegisterEvent) {
      //var list = await AddressProvider.search(keyword: "17140");
      /*print(list.length);
      list.forEach((element) {
        print(element.province.nameTh);
        print(element.province.nameEn);
        print(element.province.code);
        print(element.district.nameTh);
        print(element.district.nameEn);
        print(element.district.zipCode);
        print(element.amphure.nameTh);
        print(element.amphure.nameEn);
        print(element.amphure.code);
        print("--------");

      });

       */

      yield NoRegisterState();
    } else if (event is MainLoginEvent) {
      yield MainLoginRegisterState();
    } else if (event is MiniLoginEvent) {
      //yield _mapGoogleLoginToState();
    } else if (event is PinEvent) {
      yield* _mapPinToState(event);
    } else if (event is LoadingEvent) {
      yield LoadingRegisterState();
    } else if (event is InputInfoEvent) {
      yield* _mapInsertInfoToState(event);
    } else if (event is AddressEvent) {
      yield* _mapInsertAddressToState(event);
    } else if (event is SearchingEvent) {
      yield* _mapSearchAddressToState(event);
    } else if (event is StartRegisterEvent) {
      yield* _mapStartRegisterToState(event);
    } else if (event is CheckPinEvent) {
      yield* _mapCheckPinToState(event);
    } else if(event is UpgradeToPersonnelEvent){
      yield* _mapUpgradingToState(event);
    }
    else if(event is StartUpgradeEvent){
      yield* _mapStartUpgradeToState(event);
    }
  }

  Stream<RegisterState> _mapCheckPinToState(CheckPinEvent event) async* {

    yield LoadingRegisterState();

    String urlForCheck =
        'https://melondev-frailty-project.herokuapp.com/api/temporary-code/isAvailableFromPin';

    Map mapForCheck = {
      "pin": event.pin.toUpperCase()
    };

    var responseForCheck = await http.post(urlForCheck,
        headers: {"Content-Type": "application/json"},
        body: json.encode(mapForCheck));

    OnBool onBool = OnBool.fromJson(jsonDecode(responseForCheck.body));

    if(onBool.value){


      if(event.account!= null){
        if(event.account.oAuthId != null){
          if(event.account.oAuthId.length > 0 ){
            this.add(UpgradeToPersonnelEvent(event.context, AccountRegister(null, event.account,event.account.loginType)));
          }else {
            yield (LoginRegisterState(event.isUpgrade));
          }
        }else {
          yield (LoginRegisterState(event.isUpgrade));
        }
      }else {
        yield (LoginRegisterState(event.isUpgrade));
      }

    }else {
      
      String message = "";

      if(onBool.message.contains("NOT AVAILABLE")){
        message = "รหัสนี้หมดอายุแล้ว";
      }else if(onBool.message.contains("NOT FOUND")){
        message = "ไม่พบรหัสในฐานข้อมูล";
      } else {
        message = "รหัสนี้ไม่สามารถใช้ได้";
      }

      yield RegisterErrorState(message,id: 2);

    }

  }

  Stream<RegisterState> _mapStartRegisterToState(
      StartRegisterEvent event) async* {
    yield LoadingRegisterState();

    AuthenticationBloc _authenticationBloc =
    BlocProvider.of<AuthenticationBloc>(event.context);

    String urlForCheck =
        'https://melondev-frailty-project.herokuapp.com/api/account/checkAccount';

    DateFormat formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    String rawBirthDate = formatter.format(event.birthDate);

    int t = rawBirthDate.indexOf("T");
    String birthDate = rawBirthDate.substring(0, t) + "T00:00:00Z";

    //print(event.firstName);
    //print(event.lastName);
    //print(birthDate);
    //print(event.account.fbUser.uid.toString());

    Map mapForCheck = {
      "firstName": event.firstName,
      "lastName": event.lastName,
      "birthDate": birthDate,
      "oAuth": "",
    };

    var responseForCheck = await http.post(urlForCheck,
        headers: {"Content-Type": "application/json"},
        body: json.encode(mapForCheck));
    ReturnHttp returnHttp =
    ReturnHttp.fromJson(jsonDecode(responseForCheck.body));

    print("CHECK : ${responseForCheck.body}");

    if (returnHttp.httpStatus == 200) {
      if (event.account.loginType.contains("NAME")) {
        print("RSP1");
      } else {
        yield RegisterErrorState("บัญชีผู้ใช้ซ้ำ");
      }
    } else {
      String urlForRegister =
          'https://melondev-frailty-project.herokuapp.com/api/account/register/registerNormalAccountWithOAuth';

      if (event.account.account != null) {

        if(event.personnel){

          String urlForRegisterPersonnel =
              'https://melondev-frailty-project.herokuapp.com/api/account/register/registerPersonnelAccount';

          Map mapForRegister = {
            "firstName": event.firstName,
            "lastName": event.lastName,
            "birthDate": birthDate,
            "subDistrict": event.addressDao.district.nameTh,
            "district": event.addressDao.amphure.nameTh,
            "province": event.addressDao.province.nameTh,
            "oAuth": event.account.fbUser != null
                ? event.account.fbUser.uid.toString()
                : "",
            "loginType": event.account.loginType,
            "email": event.account.account.email != null ? event.account.account.email : "",
            "department": event.department,
            "pin": event.pin.toUpperCase(),
          };

          var responseForRegister = await http.post(urlForRegisterPersonnel,
              headers: {"Content-Type": "application/json"},
              body: json.encode(mapForRegister));
          print(responseForRegister.body);
          Value value = Value.fromJson(jsonDecode(responseForRegister.body));

          _authenticationBloc.add(ResumeGoogleAuthenticationEvent(value.value));
          Navigator.pop(event.context);

        }else {
          Map mapForRegister = {
            "firstName": event.firstName,
            "lastName": event.lastName,
            "birthDate": birthDate,
            "subDistrict": event.addressDao.district.nameTh,
            "district": event.addressDao.amphure.nameTh,
            "province": event.addressDao.province.nameTh,
            "oAuth": event.account.fbUser != null
                ? event.account.fbUser.uid.toString()
                : "",
            "loginType": event.account.loginType
          };

          var responseForRegister = await http.post(urlForRegister,
              headers: {"Content-Type": "application/json"},
              body: json.encode(mapForRegister));
          print(responseForRegister.body);
          Value value = Value.fromJson(jsonDecode(responseForRegister.body));

          _authenticationBloc.add(ResumeGoogleAuthenticationEvent(value.value));
          Navigator.pop(event.context);
        }
      } else {
        String urlForRegisterNoOAuth =
            'https://melondev-frailty-project.herokuapp.com/api/account/register/normalAccountWithOAuth';

        Map mapForRegisterNoOAuth = {
          "firstName": event.firstName,
          "lastName": event.lastName,
          "birthDate": birthDate,
          "subDistrict": event.addressDao.district.nameTh,
          "district": event.addressDao.amphure.nameTh,
          "province": event.addressDao.province.nameTh,
        };

        var responseForRegister = await http.post(urlForRegisterNoOAuth,
            headers: {"Content-Type": "application/json"},
            body: json.encode(mapForRegisterNoOAuth));
        print(responseForRegister.body);
        Value value = Value.fromJson(jsonDecode(responseForRegister.body));

        _authenticationBloc.add(ResumeGoogleAuthenticationEvent(value.value));
        Navigator.pop(event.context);
      }

      //yield NoRegisterState();
    }

    //yield RegisterSuccessState();
  }

  Stream<RegisterState> _mapStartUpgradeToState(
      StartUpgradeEvent event) async* {
    yield LoadingRegisterState();

    AuthenticationBloc _authenticationBloc =
    BlocProvider.of<AuthenticationBloc>(event.context);

    String urlForUpgrade =
        'https://melondev-frailty-project.herokuapp.com/api/account/upgradeToPersonnel';



    Map mapForUpgrade = {
      "id": event.account.account.id,
      "oAuth": event.account.fbUser.uid.toString(),
      "email": event.account.fbUser.email,
      "department": event.department,
      "loginType": event.account.loginType
    };

    var responseForRegister = await http.post(urlForUpgrade,
        headers: {"Content-Type": "application/json"},
        body: json.encode(mapForUpgrade));
    print(responseForRegister.body);
    Value value = Value.fromJson(jsonDecode(responseForRegister.body));

    if(value.status.contains("UPDATED")){
      _authenticationBloc.add(ResumeGoogleAuthenticationEvent(value.value));
      Navigator.pop(event.context);
    }else if(value.status.contains("DUPLICATE")){
      yield RegisterErrorState("บัญชีนี้ถูกใช้แล้ว",
           id:0,account: event.account);
    }else {
      yield RegisterErrorState("เกิดข้อผิดพลาด",
          id:0, account: event.account);
    }


  }

  Stream<RegisterState> _mapPinToState(PinEvent event) async* {
    yield PinRegisterState();
  }

  Stream<RegisterState> _mapInsertInfoToState(InputInfoEvent event) async* {
    yield InsertInfoRegisterState(event.account);
  }

  Stream<RegisterState> _mapUpgradingToState(UpgradeToPersonnelEvent event) async* {
    yield UpgradeRegisterState(event.account);
  }

  Stream<RegisterState> _mapInsertAddressToState(AddressEvent event) async* {
    // ignore: close_sinks
    AuthenticationBloc _authenticationBloc =
    BlocProvider.of<AuthenticationBloc>(event.context);

    if (event.account.loginType.contains("NAME")) {
      yield LoadingRegisterState();

      String urlForCheck =
          'https://melondev-frailty-project.herokuapp.com/api/account/register/loginNormalAccount';

      DateFormat formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      String rawBirthDate = formatter.format(event.birthDate);

      int t = rawBirthDate.indexOf("T");
      String birthDate = rawBirthDate.substring(0, t) + "T00:00:00Z";

      Map mapForCheck = {
        "firstName": event.firstName,
        "lastName": event.lastName,
        "birthDate": birthDate
      };

      var responseForCheck = await http.post(urlForCheck,
          headers: {"Content-Type": "application/json"},
          body: json.encode(mapForCheck));
      Value value = Value.fromJson(jsonDecode(responseForCheck.body));

      print(responseForCheck.body);

      if (value.status.contains("NOT FOUND")) {
        //yield RegisterErrorState("บัญชีผู้ใช้ซ้ำ");
        List<AddressDao> list = await AddressProvider.search(keyword: "");
        yield AddressRegisterState(event.account,
            listAddress: _filterZeroAddress(list));
      } else if (value.status.contains("WRONG DATE")) {
        yield RegisterErrorState("วันเดือนปีไม่ตรงกับข้อมูล",
            id: 1, account: event.account);
      } else {
        _authenticationBloc.add(ResumeGoogleAuthenticationEvent(value.value));
        Navigator.pop(event.context);
      }
    } else {
      List<AddressDao> list = await AddressProvider.search(keyword: "");
      yield AddressRegisterState(event.account,
          listAddress: _filterZeroAddress(list));
    }
  }

  Stream<RegisterState> _mapSearchAddressToState(SearchingEvent event) async* {
    List<AddressDao> list =
    await AddressProvider.search(keyword: event.searchMessage);
    yield AddressRegisterState(event.account,
        listAddress: _filterZeroAddress(list));
  }

  List<AddressDao> _filterZeroAddress(List<AddressDao> list) {
    return list.where((i) => i.district.zipCode.length != 1).toList();
  }
}
