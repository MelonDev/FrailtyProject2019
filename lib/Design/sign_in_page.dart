import 'package:dots_indicator/dots_indicator.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_thailand_provinces/dao/address_dao.dart';
import 'package:frailty_project_2019/Bloc/authentication/authentication_bloc.dart';
import 'package:frailty_project_2019/Bloc/register/register_bloc.dart';
import 'package:frailty_project_2019/Model/Account.dart';
import 'package:frailty_project_2019/Model/AccountRegister.dart';
import 'dart:io' show Platform;
import 'package:frailty_project_2019/ThemeData/BasicDarkThemeData.dart';
import 'package:frailty_project_2019/ThemeData/BasicLightThemeData.dart';
import 'package:frailty_project_2019/Tools/DateTools.dart';
import 'package:frailty_project_2019/Tools/UpperCaseTextFormatter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignInPage extends StatefulWidget {
  bool isUpgrade;

  SignInPage({Key key, this.isUpgrade = false}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  AuthenticationBloc _authenticationBloc;
  RegisterBloc _registerBloc;
  ThemeData _theme;

  String _firstName;
  String _lastName;
  String _department;

  DateTime _dateTime = DateTime.now();
  AddressDao _addressDao;

  bool _personnel = false;

  int _pageCounter = 0;
  String _pageTitle = "";
  int _pageCounterTotal = 2;

  final _controllerFirst = TextEditingController();
  final _controllerLast = TextEditingController();
  final _controllerDepart = TextEditingController();

  bool _isPinConfirm = false;
  String _pin = "";

  bool _isUpgrade = false;

  Account _account;

  void nextPage(AccountRegister account) {
    //goToPage(firstName,lastName,birthDate);
    if (_firstName == null || _lastName == null) {
      showAlertDialog();
    } else {
      if (_firstName.length == 0 || _lastName.length == 0) {
        showAlertDialog();
      } else {
        _pageCounter += 1;
        goToPage(account);
      }
    }
  }

  void showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => _theme.brightness == Brightness.dark
            ? new CupertinoAlertDialog(
                title: new Text(
                  "ข้อมูลไม่ครบ",
                  style: TextStyle(
                      fontFamily: _theme.primaryTextTheme.bodyText1.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withAlpha(200)),
                ),
                content: new Text("กรุณาตรวจสอบช่องกรอกข้อมูลว่าครบถ้วน",
                    style: TextStyle(
                        fontFamily:
                            _theme.primaryTextTheme.bodyText1.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white.withAlpha(200).withAlpha(150))),
                actions: [
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: new Text("รับทราบ",
                        style: TextStyle(
                            fontFamily:
                                _theme.primaryTextTheme.bodyText1.fontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.red)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            : new CupertinoAlertDialog(
                title: new Text(
                  "ข้อมูลไม่ครบ",
                  style: TextStyle(
                      fontFamily: _theme.primaryTextTheme.bodyText1.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withAlpha(180)),
                ),
                content: new Text("กรุณาตรวจสอบช่องกรอกข้อมูลว่าครบถ้วน",
                    style: TextStyle(
                        fontFamily:
                            _theme.primaryTextTheme.bodyText1.fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.black.withAlpha(180).withAlpha(150))),
                actions: [
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: new Text("รับทราบ",
                        style: TextStyle(
                            fontFamily:
                                _theme.primaryTextTheme.bodyText1.fontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.red)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
  }

  void previousPage(AccountRegister account) {
    _pageCounter -= 1;
    //goToPage(firstName,lastName,birthDate);

    if (_pageCounter == 0) {
      _controllerFirst.text = _firstName;
      _controllerLast.text = _lastName;
      _controllerDepart.text = _department;
    }

    goToPage(account);
  }

  void goToPage(AccountRegister account) {
    switch (_pageCounter) {
      case 0:
        {
          //_pageTitle = "กรอกข้อมูลส่วนตัว";
          _registerBloc.add(InputInfoEvent(context, account));
          break;
        }
      case 1:
        {
          //_pageTitle = "เลือกที่อยู่";
          _registerBloc.add(AddressEvent(account,
              firstName: _firstName,
              lastName: _lastName,
              birthDate: _dateTime,
              context: context));
          break;
        }
      default:
        {
          _pageCounter -= 1;
        }
    }
  }

  void _searching(String message, AccountRegister account) {
    _registerBloc
        .add(SearchingEvent(account, context: context, searchMessage: message));
  }

  void loadAndSetTitle(RegisterState _state) {
    if (_state is InsertInfoRegisterState) {
      _pageTitle = "กรอกข้อมูลส่วนตัว";
    } else if (_state is MainLoginRegisterState ||
        _state is LoginRegisterState) {
      _pageTitle = "วิธีการเข้าสู่ระบบ";
    } else if (_state is AddressRegisterState) {
      _pageTitle = "เลือกที่อยู่";
    } else if (_state is PinRegisterState) {
      _pageTitle = "กรอกรหัสยืนยันตัวตน";
    } else if (_state is UpgradeRegisterState) {
      _pageTitle = "กรอกข้อมูลเพิ่มเติม";
    } else {
      _pageTitle = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    var brightness = DynamicTheme.of(context).brightness;

    _theme = Theme.of(context);

    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _registerBloc = BlocProvider.of<RegisterBloc>(context);

    _isUpgrade = widget.isUpgrade;

    //_pageTitle = _pageTitle.length == 0 ? "กรอกข้อมูลส่วนตัว" : _pageTitle;

    //_authenticationBloc.add(LoginPageEvent());

    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, _state) {
      loadAndSetTitle(_state);

      return Scaffold(
        backgroundColor: _state is RegisterErrorState
            ? Colors.red
            : Theme.of(context).primaryColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          titleSpacing: 0.0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          // Don't show the leading button
          title: Stack(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: 60,
                        height: 56,
                        child: LayoutBuilder(builder: (context, constraint) {
                          return FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                if (_isUpgrade) {
                                  if (_state is RegisterErrorState) {
                                    if (_state.id != null) {
                                      if (_state.id == 0) {
                                        _authenticationBloc
                                            .add(UnAuthenticatingLoginEvent());
                                        Future.delayed(
                                            const Duration(milliseconds: 500),
                                                () {
                                              _registerBloc.add(NoRegisterEvent());
                                            });
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    Navigator.pop(context);
                                  }
                                } else {
                                  if (_state is RegisterErrorState) {
                                    if (_state.id != null) {
                                      if (_state.id == 1) {
                                        print(_pageCounter);
                                        _pageCounter = 0;
                                        goToPage(_state.account);
                                      } else if (_state.id == 2) {
                                        _registerBloc
                                            .add(PinEvent(this.context));
                                      } else {
                                        _authenticationBloc
                                            .add(UnAuthenticatingLoginEvent());
                                        Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () {
                                          _registerBloc.add(NoRegisterEvent());
                                        });
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      _authenticationBloc
                                          .add(UnAuthenticatingLoginEvent());
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        _registerBloc.add(NoRegisterEvent());
                                      });
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    if (!(_authenticationBloc.state
                                        is AuthenticatedState)) {
                                      _authenticationBloc
                                          .add(UnAuthenticatingLoginEvent());
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        _registerBloc.add(NoRegisterEvent());
                                      });
                                    }
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              color: Colors.transparent,
                              child: Icon(
                                Icons.close,
                                size: constraint.biggest.height - 26,
                                //color: Colors.black.withAlpha(150),
                                color: _state is RegisterErrorState
                                    ? Colors.white
                                    : Theme.of(context).iconTheme.color,
                              ));
                        }),
                      )),
                ],
              ),
              SizedBox(
                height: 56,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        _pageTitle,
                        style:
                            Theme.of(context).appBarTheme.textTheme.subtitle1,
                      ),
                    )
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container()
                  /*Container(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: 60,
                        height: 56,
                        child: LayoutBuilder(builder: (context, constraint) {
                          return FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                _authenticationBloc
                                    .add(UnAuthenticatingLoginEvent());
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  _registerBloc.add(NoRegisterEvent());
                                });
                                Navigator.pop(context);
                              },
                              color: Colors.transparent,
                              child: Icon(
                                Icons.check,
                                size: constraint.biggest.height - 26,
                                //color: Colors.black.withAlpha(150),
                                color: Theme.of(context).iconTheme.color,
                              ));
                        }),
                      ))*/
                  ,
                ],
              )
            ],
          ),

          brightness:
              _state is RegisterErrorState ? Brightness.dark : brightness,
          backgroundColor: _state is RegisterErrorState
              ? Colors.red
              : Theme.of(context).primaryColor,
          elevation: _state is RegisterErrorState ||
                  _state is PinRegisterState ||
                  _state is LoadingRegisterState
              ? 0
              : 1,
        ),
        body: SafeArea(
          bottom: true,
          top: false,
          left: true,
          right: true,
          child: _pageController(_state),
        ),
      );
    });
  }

  Widget _pageController(RegisterState _state) {
    if (_state is MainLoginRegisterState) {
      return Container(
        color: Theme.of(context).backgroundColor,
        child: ListView(
          children: <Widget>[
            _temporarySigninBtn(),
            _identifySigninBtn(),
            _googleSigninBtn(),
            Platform.isIOS ? _appleSigninBtn() : Container()
          ],
        ),
      );
    } else if (_state is LoginRegisterState) {
      _personnel = true;
      return Container(
        color: Theme.of(context).backgroundColor,
        child: ListView(
          children: <Widget>[
            _googleSigninBtn(),
            Platform.isIOS ? _appleSigninBtn() : Container()
          ],
        ),
      );
    } else if (_state is NoRegisterState) {
      return Container(
        color: _theme.backgroundColor,
      );
    } else if (_state is InsertInfoRegisterState) {
      return _insertInfoPage(_state);
    } else if (_state is LoadingRegisterState) {
      return _loadingRegister();
    } else if (_state is AddressRegisterState) {
      return _insertAddressPage(_state);
    } else if (_state is RegisterErrorState) {
      return Container(
        color: Colors.red,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.only(bottom: 60),
                alignment: Alignment.center,
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _state.message,
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold),
                    ),
                    /*SizedBox(
                      height: 40,
                    ),
                    _buttonTemplete(
                        "รับทราบ",
                        null,
                        null,
                        _theme.cardColor,
                        _theme.primaryTextTheme.subtitle1.color,
                        Colors.red,
                        center: true,
                        bold: true,
                        marginSide: 80)

                     */
                  ],
                ),
              ),
            )
          ],
        ),
      );
    } else if (_state is RegisterSuccessState) {
      return Container(
        color: _theme.backgroundColor,
      );
    } else if (_state is PinRegisterState) {
      return Container(
        width: MediaQuery.of(context).size.width,
        color: _theme.bottomAppBarColor,
        child: _pinPage(),
      );
    } else if (_state is UpgradeRegisterState) {
      return Container(
        width: MediaQuery.of(context).size.width,
        color: _theme.bottomAppBarColor,
        child: _upgradePage(_state),
      );
    }
  }

  Widget _upgradePage(UpgradeRegisterState _state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 40),
          child: _generateTextField("หน่วยงานสังกัด", _state,
              id: 5, size: 44, marginTop: 3, marginBottom: 0, fontSize: 19),
        ),
        Container(
          child: _buttonTemplete(
              "ยืนยัน",
              null,
              _continueToUpgrade,
              _isPinConfirm
                  ? Colors.blueAccent.withAlpha(250)
                  : _theme.backgroundColor
                      .withBlue(80)
                      .withGreen(80)
                      .withRed(80)
                      .withAlpha(50),
              Colors.white,
              _theme.primaryTextTheme.subtitle1.color,
              height: 56,
              marginSide: 50,
              center: true,
              bold: true),
        )
      ],
    );
  }

  void _continueToUpgrade() {
    if (_department.length > 0) {
      _registerBloc.add(StartUpgradeEvent(
          this.context, _registerBloc.state.account, _department));
    } else {
      showAlertDialog();
    }
  }

  Widget _pinPage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          width: 260,
          margin: EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 40),
          child: PinCodeTextField(
            length: 4,
            inputFormatters: [UpperCaseTextFormatter()],
            inactiveColor: Colors.redAccent,
            obsecureText: false,
            animationType: AnimationType.fade,
            shape: PinCodeFieldShape.box,
            animationDuration: Duration(milliseconds: 200),
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 60,
            fieldWidth: 50,
            autoFocus: true,
            backgroundColor: _theme.bottomAppBarColor,
            textStyle: TextStyle(
              fontSize: 32,
              fontFamily: "SukhumvitSet",
              color: _theme.primaryTextTheme.subtitle1.color,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (value) {
              setState(() {
                _pin = value.toUpperCase();
                if (value.length == 4) {
                  _isPinConfirm = true;
                } else {
                  _isPinConfirm = false;
                }
              });
            },
          ),
        ),
        Container(
          child: IgnorePointer(
            ignoring: !_isPinConfirm,
            child: _buttonTemplete(
                "ตรวจสอบ",
                null,
                _checkPin,
                _isPinConfirm
                    ? Colors.blueAccent.withAlpha(250)
                    : _theme.backgroundColor
                        .withBlue(80)
                        .withGreen(80)
                        .withRed(80)
                        .withAlpha(50),
                Colors.white,
                _theme.primaryTextTheme.subtitle1.color,
                height: 56,
                marginSide: 50,
                center: true,
                bold: true),
          ),
        )
      ],
    );
  }

  void _checkPin() {
    _registerBloc.add(CheckPinEvent(this.context, _pin,
        isUpgrade: (_isUpgrade != null ? (_isUpgrade ? true : null) : null),
        account: (_isUpgrade != null
            ? (_isUpgrade
                ? (_authenticationBloc.state as AuthenticatedState).account
                : null)
            : null)));
  }

  Widget _insertAddressPage(AddressRegisterState _state) {
    return Stack(
      children: [
        Container(
          color: _theme.backgroundColor,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                color: _theme.bottomAppBarColor,
                child: _generateTextField("ค้นหา", _state,
                    id: 1,
                    size: 44,
                    marginTop: 3,
                    marginBottom: 0,
                    fontSize: 19),
              ),
              Container(
                margin: EdgeInsets.only(top: 60, bottom: 50),
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _state.listAddress != null
                        ? (_state.listAddress.length)
                        : 0,
                    itemBuilder: (context, position) {
                      return FlatButton(
                        onPressed: () {
                          _registerBloc.add(StartRegisterEvent(
                              _state.account,
                              _firstName,
                              _lastName,
                              _dateTime,
                              _state.listAddress[position],
                              context: this.context,
                              department: _personnel ? _department : null,
                              pin: _personnel ? _pin : null,
                              personnel: _personnel));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 16, right: 16),
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${_state.listAddress[position].province.nameTh.contains("กรุงเทพมหานคร") ? "แขวง" : "ตำบล"}${_state.listAddress[position].district.nameTh}",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'SukhumvitSet',
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                  "${_state.listAddress[position].province.nameTh.contains("กรุงเทพมหานคร") ? "" : "อำเภอ"}${_state.listAddress[position].amphure.nameTh}, จังหวัด${_state.listAddress[position].province.nameTh}, ${_state.listAddress[position].district.zipCode}",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'SukhumvitSet',
                                      fontWeight: FontWeight.normal)),
                              position != (_state.listAddress.length - 1)
                                  ? Container(
                                      color: _theme.dividerColor.withAlpha(100),
                                      margin: EdgeInsets.only(top: 10),
                                      width: MediaQuery.of(context).size.width,
                                      height: 1,
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _bottomBar(_state),
        )
      ],
    );
  }

  Widget _insertInfoPage(RegisterState _state) {
    return Stack(
      children: [
        Container(
          color: _theme.backgroundColor,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              _generateTextField("ชื่อจริง", _state, id: 2),
              _generateTextField("นามสกุล", _state, id: 3),
              (_personnel
                  ? _generateTextField("หน่วยงานสังกัด", _state, id: 4)
                  : Container()),
              Container(
                margin:
                    EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 0),
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: _theme.dividerColor,
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 20, right: 20),
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: Text(
                  "${_dateTime.day} ${DateTools().getName(_dateTime.month)} ${_dateTime.year + 543}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'SukhumvitSet', fontSize: 24),
                ),
              ),
              _thaiAddressBtn()
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _bottomBar(_state),
        )
      ],
    );
  }

  Widget _bottomBar(RegisterState _state) {
    return Container(
      color: _theme.bottomAppBarColor,
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 120,
              height: 50,
              child: _pageCounter > 0
                  ? FlatButton(
                      onPressed: () {
                        previousPage(_state.account);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'ก่อนหน้า',
                            style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                color: _theme.textTheme.subtitle1.color,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    )
                  : SizedBox(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              child: DotsIndicator(
                dotsCount: _pageCounterTotal,
                position: _pageCounter.toDouble(),
                decorator: DotsDecorator(
                  size: const Size.square(9.0),
                  activeSize: const Size(28.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 50,
              width: 100,
              child: _pageCounter == _pageCounterTotal - 1
                  ? SizedBox()
                  : FlatButton(
                      onPressed: () {
                        nextPage(_state.account);
                      },
                      child: Row(
                        children: [
                          Text(
                            'ต่อไป',
                            style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                color: _theme.textTheme.subtitle1.color,
                                fontSize: 18,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  void _showDateDialog() {
    CupertinoRoundedDatePicker.show(
      context,
      fontFamily: "SukhumvitSet",
      textColor: _theme.primaryTextTheme.subtitle1.color,
      era: EraMode.BUDDHIST_YEAR,
      background: _theme.bottomAppBarColor,
      borderRadius: 0,
      initialDatePickerMode: CupertinoDatePickerMode.date,
      minimumYear: DateTime.now().year - 80,
      maximumYear: DateTime.now().year,
      maximumDate: DateTime.now(),
      onDateTimeChanged: (newDateTime) {
        setState(() {
          _dateTime = newDateTime;
        });
      },
    );
  }

  Widget _oldBottomBar() {
    return Container(
      color: _theme.bottomAppBarColor,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _pageCounter > 0
                ? FlatButton(
                    onPressed: () {
                      previousPage(null);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'ก่อนหน้า',
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              color: _theme.textTheme.subtitle1.color,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  )
                : SizedBox(),
            FlatButton(
              onPressed: () {
                nextPage(null);
              },
              child: Row(
                children: [
                  Text(
                    'ต่อไป',
                    style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        color: _theme.textTheme.subtitle1.color,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  Widget _thaiAddressBtn() {
    return _buttonTemplete(
        "เลือกวันเดือนปีเกิด",
        "images/cake.png",
        _showDateDialog,
        Colors.blueGrey,
        Colors.white,
        _theme.primaryTextTheme.subtitle1.color,
        height: 56,
        marginSide: 40,
        center: true,
        bold: true);
  }

  Widget _temporarySigninBtn() {
    return _buttonTemplete(
        "รหัสยืนยันตัวตน",
        _theme.brightness == Brightness.light
            ? "images/password.png"
            : "images/password_light.png",
        _temporarySignin,
        _theme.cardColor,
        _theme.primaryTextTheme.subtitle1.color,
        _theme.primaryTextTheme.subtitle1.color);
  }

  Widget _appleSigninBtn() {
    return _buttonTemplete(
        "Apple ID",
        _theme.brightness == Brightness.light
            ? "images/company.png"
            : "images/company-dark.png",
        _appleSignin,
        _theme.appBarTheme.textTheme.subtitle1.color,
        _theme.bottomAppBarColor,
        Colors.white12);
  }

  void _temporarySignin() {
    _registerBloc.add(PinEvent(context));
    //_authenticationBloc.add(AppleLoginEvent(context));
  }

  void _appleSignin() {
    //_registerBloc.add(InputInfoEvent(context, null));
    _authenticationBloc.add(AppleLoginEvent(context, _personnel,
        pin: (_personnel ? _pin : null),
        isUpgrade: (_isUpgrade != null ? (_isUpgrade ? true : null) : null),
        account: (_isUpgrade != null
            ? (_isUpgrade
                ? (_authenticationBloc.state as AuthenticatedState).account
                : null)
            : null)));
  }

  Widget _googleSigninBtn() {
    return _buttonTemplete("บัญชี Google", "images/google.png", _googleSignin,
        Colors.blueAccent, Colors.white, Colors.white12);
  }

  void _googleSignin() {
    _authenticationBloc.add(GoogleLoginEvent(context, _personnel,
        pin: (_personnel ? _pin : null),
        isUpgrade: (_isUpgrade != null ? (_isUpgrade ? true : null) : null),
        account: (_isUpgrade != null
            ? (_isUpgrade
                ? (_authenticationBloc.state as AuthenticatedState).account
                : null)
            : null)));
  }

  Widget _identifySigninBtn() {
    return _buttonTemplete(
        "บัญชี ชื่อ-นามสกุล",
        _theme.brightness == Brightness.light
            ? "images/user.png"
            : "images/user_light.png",
        _identifySignin,
        _theme.cardColor,
        _theme.primaryTextTheme.subtitle1.color,
        _theme.primaryTextTheme.subtitle1.color);
  }

  void _identifySignin() {
    _registerBloc
        .add(InputInfoEvent(context, AccountRegister(null, null, "NAME")));
  }

  Widget _generateTextField(String message, RegisterState _state,
      {int id = 0,
      double size = 50,
      double marginTop = 16,
      double marginBottom = 0,
      double fontSize = 20}) {
    TextEditingController controller;

    switch (id) {
      case 2:
        {
          controller = _controllerFirst;
          break;
        }
      case 3:
        {
          controller = _controllerLast;
          break;
        }
      case 4:
        {
          controller = _controllerDepart;
          break;
        }
      case 5:
        {
          controller = _controllerDepart;
          break;
        }
    }

    return Align(
      alignment: Alignment.center,
      child: Container(
        height: size,
        margin: EdgeInsets.fromLTRB(20, marginTop, 20, marginBottom),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            //color: Colors.black.withAlpha(30)
            color: _theme.primaryTextTheme.subtitle1.color.withAlpha(30)),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(
              controller: controller,
              keyboardAppearance: _theme.brightness,
              keyboardType: TextInputType.text,
              onTap: () {
                //_actionBtn = true;
              },
              onChanged: (value) {
                //str = value;
                switch (id) {
                  case 1:
                    {
                      _searching(value, _state.account);
                      break;
                    }
                  case 2:
                    {
                      setState(() {
                        _firstName = value;
                      });
                      break;
                    }
                  case 3:
                    {
                      setState(() {
                        _lastName = value;
                      });
                      break;
                    }
                  case 4:
                    {
                      setState(() {
                        _department = value;
                      });
                      break;
                    }
                  case 5:
                    {
                      setState(() {
                        _department = value;
                      });
                      break;
                    }
                }
              },
              onSubmitted: (str) {
                //_actionBtn = false;
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              style: TextStyle(
                  fontFamily: 'SukhumvitSet',
                  //color: Colors.black,
                  color: _theme.primaryTextTheme.bodyText1.color,
                  fontSize: fontSize += 1,
                  fontWeight: FontWeight.normal),
              cursorColor: _theme.cursorColor,
              decoration: InputDecoration.collapsed(
                  hintText: message,
                  hintStyle: TextStyle(
                      fontFamily: 'SukhumvitSet',
                      //color: Colors.black.withAlpha(120),
                      color: _theme.primaryTextTheme.subtitle1.color
                          .withAlpha(160),
                      fontSize: fontSize,
                      fontWeight: FontWeight.normal),
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadingRegister() {
    return Material(
      child: Container(
          color: _theme.primaryColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: SpinKitThreeBounce(
                    color: _theme.primaryTextTheme.subtitle1.color,
                    size: 50.0,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Text("ลงทะเบียน",
                      style: TextStyle(
                          color: Colors.white.withAlpha(220),
                          fontSize: 18,
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.normal)),
                )
              ],
            ),
          )),
    );
  }

  Widget _buttonTemplete(String text, String image, Function function,
      Color bgColor, Color textColor, Color splashColor,
      {double minWidth = 256,
      double height = 60,
      double marginSide = 15,
      bool center = false,
      bool bold = false}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: marginSide, right: marginSide, top: 16),
      child: MaterialButton(
        minWidth: minWidth,
        height: height,
        color: bgColor,
        elevation: 0,
        highlightElevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        splashColor: splashColor,
        child: Container(
          margin: EdgeInsets.only(left: center ? 0 : 10, right: 0, top: 0),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment:
                center ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              image != null
                  ? Image.asset(
                      image,
                      fit: BoxFit.contain,
                      width: 22,
                      height: 22,
                    )
                  : Container(),
              image != null
                  ? SizedBox(
                      width: image != null ? 15 : (center ? 0 : 15),
                    )
                  : Container(),
              Text(
                text,
                textAlign: TextAlign.center,
                //center ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                    color: textColor,
                    fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                    fontSize: 20,
                    fontFamily: 'SukhumvitSet'),
              ),
              image != null
                  ? SizedBox(
                      width: image != null ? 15 : (center ? 0 : 15),
                    )
                  : Container(),
            ],
          ),
        ),
        onPressed: () {
          function();
        },
      ),
    );
  }
}
