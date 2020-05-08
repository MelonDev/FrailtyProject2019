import 'dart:ui';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frailty_project_2019/Bloc/authentication/authentication_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  SettingPage();

  @override
  _settingPage createState() => _settingPage();
}

class _settingPage extends State<SettingPage> {
  String _titleText = "ตั้งค่า";

  ThemeData _theme;

  var _switchDarkMode = false;
  SharedPreferences _preferences;
  bool _customDarkMode = false;

  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    await SharedPreferences.getInstance().then((onValue) {
      setState(() {
        _preferences = onValue;
        _customDarkMode = _preferences.getBool("CUSTOM_DARKMODE");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //var brightness = MediaQuery.of(context).platformBrightness;
    var brightness = DynamicTheme.of(context).brightness;
    if (brightness == Brightness.dark) {
      _switchDarkMode = true;
    } else {
      _switchDarkMode = false;
    }

    _theme = Theme.of(context);

    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, _state) {
      if (_state is DatabaseRefreshingState) {
        return Material(
          child: Container(
              color: _theme.accentColor,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: SpinKitThreeBounce(
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Text(_state.message,
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
      } else {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
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
                                  Navigator.pop(context);
                                },
                                color: Colors.transparent,
                                child: Icon(
                                  Icons.close,
                                  size: constraint.biggest.height - 26,
                                  //color: Colors.black.withAlpha(150),
                                  color: Theme.of(context).iconTheme.color,
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
                          _titleText,
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
                  children: <Widget>[Container()],
                )
              ],
            ),

            //brightness: brightness,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 1,
          ),
          body: Container(
            child: CupertinoSettings(
              backgroudColor: Theme.of(context).backgroundColor,
              items: _preferences == null ? null : _mergeListSetting(_state),
            ),
          ),
        );
      }
    });
  }

  List<Widget> _mergeListSetting(MyAuthenticationState state) {
    return state is AuthenticatedState
        ? [
            ..._loadDarkSetting(),
            //..._loadLoginSetting(state),
            ..._loadDatabaseSetting(state)
          ]
        : [..._loadDarkSetting()];

    return [..._loadDarkSetting(), ..._loadDatabaseSetting(state)];
  }

  List<Widget> _loadDatabaseSetting(AuthenticatedState state) {
    return [
      CSHeader(
        "ฐานข้อมูล",
        textColor: Theme.of(context).primaryTextTheme.bodyText1.color,
      ),
      CSButton(
        CSButtonType.DEFAULT,
        "อัปเดตฐานข้อมูลทั้งหมด",
        () {
          _authenticationBloc.add(DatabaseRefreshEvent(state.account));
        },
        fontSize: 18,
        backgroudColor: _theme.cardColor,
      ),
      CSButton(
        CSButtonType.DEFAULT_DESTRUCTIVE,
        "ลบประวัติ",
        () {
          _authenticationBloc.add(DeleteHistoryDatabase(state.account));
        },
        fontSize: 18,
        backgroudColor: _theme.cardColor,
      )
    ];
  }

  List<Widget> _loadDarkSetting() {
    return [
      CSHeader(
        'ธีม',
        textColor: Theme.of(context).primaryTextTheme.bodyText1.color,
      ),
      CSWidget(
        CSControl(
          'ปรับแต่งโหมดธีมสีเอง',
          CupertinoSwitch(
            activeColor: Colors.teal,
            value: _customDarkMode,
            onChanged: (bool value) {
              _preferences.setBool("CUSTOM_DARKMODE", value);
              setState(() {
                _customDarkMode = value;
              });
              if (value == false) {
                DynamicTheme.of(context).setBrightness(
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? Brightness.dark
                        : Brightness.light);
              }
            },
          ),
          fontSize: 18,
          style: CSWidgetStyle(
            icon: Icon(
              CupertinoIcons.brightness,
              size: 35,
            ),
          ),
          textColor: Theme.of(context).appBarTheme.textTheme.subtitle1.color,
          backgroudColor: Theme.of(context).primaryColor,
        ),
        backgroudColor: Theme.of(context).primaryColor,
      ),
      _customDarkMode
          ? CSHeader(
              'โหมดธีมสี',
              textColor: Theme.of(context).primaryTextTheme.bodyText1.color,
            )
          : Container(),
      _customDarkMode
          ? CSSelection(
              ['สว่าง', 'มืด'],
              (index) {
                index == 0
                    ? DynamicTheme.of(context).setBrightness(Brightness.light)
                    : DynamicTheme.of(context).setBrightness(Brightness.dark);
              },
              currentSelection:
                  DynamicTheme.of(context).brightness == Brightness.light
                      ? 0
                      : 1,
              backgroudColor: Theme.of(context).primaryColor,
              fontColor: Theme.of(context).primaryTextTheme.bodyText1.color,
              fontFamiry:
                  Theme.of(context).primaryTextTheme.bodyText1.fontFamily,
              fontSize: 20,
              checkActiveColor:
                  DynamicTheme.of(context).brightness == Brightness.light
                      ? Theme.of(context).accentColor
                      : Colors.white,
              checkSize: 20,
            )
          : Container(),
    ];
  }

  /*
  List<Widget> _loadLoginSetting(AuthenticatedState state) {
    return [
      CSHeader(
        "ลงชื่อเข้าใช้",
        textColor: Theme.of(context).primaryTextTheme.bodyText1.color,
      ),
      CSSelection(
        ['ชื่อ-นามสกุล', 'Google','AppleID'],
        (index) {},
        currentSelection: 0,
        backgroudColor: Theme.of(context).primaryColor,
        fontColor: Theme.of(context).primaryTextTheme.bodyText1.color,
        fontFamiry: Theme.of(context).primaryTextTheme.bodyText1.fontFamily,
        fontSize: 16,
        checkActiveColor:
            DynamicTheme.of(context).brightness == Brightness.light
                ? Theme.of(context).accentColor
                : Colors.white,
        checkSize: 20,
      )
    ];
  }

   */
}
