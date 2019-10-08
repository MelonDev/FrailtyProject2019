import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';

class SettingPage extends StatefulWidget {
  SettingPage();

  @override
  _settingPage createState() => _settingPage();
}

class _settingPage extends State<SettingPage> {
  String _titleText = "ตั้งค่า";

  var _switch = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
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
                              color: Colors.black.withAlpha(150),
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
                      style: TextStyle(
                          color: Colors.black.withAlpha(200),
                          fontFamily: 'SukhumvitSet',
                          //fontSize: 20,
                          fontWeight: FontWeight.bold),
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
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        child: CupertinoSettings(
          items: <Widget>[
            CSHeader('ธีม'),
            CSWidget(
              CSControl(
                'โหมดมืด',
                CupertinoSwitch(
                  activeColor: Colors.teal,
                  value: _switch,
                  onChanged: (bool value) {
                    setState(() {
                      _switch = value;
                    });
                  },
                ),
                fontSize: 18,
                style: CSWidgetStyle(
                  icon: Icon(
                    CupertinoIcons.brightness,
                    size: 35,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
