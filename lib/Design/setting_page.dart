import 'dart:ui';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  SettingPage();

  @override
  _settingPage createState() => _settingPage();
}

class _settingPage extends State<SettingPage> {
  String _titleText = "ตั้งค่า";

  var _switchDarkMode = false;
  SharedPreferences _preferences;
  bool _customDarkMode = false;

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
                      height: double.infinity,
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
              height: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      _titleText,
                      style: Theme.of(context).appBarTheme.textTheme.title,
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

        brightness: Brightness.light,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1,
      ),
      body: Container(
        child: CupertinoSettings(
          backgroudColor: Theme.of(context).backgroundColor,
          items: _preferences == null ? null : _loadDarkSetting(),
        ),
      ),
    );
  }

  List<Widget> _loadDarkSetting() {
    return [
      CSHeader(
        'ธีม',
        textColor: Theme.of(context).primaryTextTheme.subtitle.color,
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
              if(value == false){
                DynamicTheme.of(context).setBrightness(MediaQuery.of(context).platformBrightness == Brightness.dark ? Brightness.dark : Brightness.light);
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
          textColor: Theme.of(context).appBarTheme.textTheme.title.color,
          backgroudColor: Theme.of(context).primaryColor,
        ),
        backgroudColor: Theme.of(context).primaryColor,
      ),
      _customDarkMode
          ? CSHeader(
              'โหมดธีมสี',
              textColor: Theme.of(context).primaryTextTheme.subtitle.color,
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
              fontColor: Theme.of(context).primaryTextTheme.subtitle.color,
              fontFamiry:
                  Theme.of(context).primaryTextTheme.subtitle.fontFamily,
              fontSize: 20,
              checkActiveColor:
                  DynamicTheme.of(context).brightness == Brightness.light
                      ? Theme.of(context).accentColor
                      : Colors.white,
              checkSize: 20,
            )
          : Container()
    ];
  }
}
