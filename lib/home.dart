import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/rendering.dart';
import 'package:flutter/rendering.dart' as prefix1;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:frailty_project_2019/Question.dart';

class HomeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xFF009688)),
      home: HomePage(),
    );
  }
}

class HomeRoute extends PageRoute<void> {
  HomeRoute({
    @required this.builder,
    RouteSettings settings,
  })  : assert(builder != null),
        super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    //dialog = new ProgressDialog(context, ProgressDialogType.Normal);
    //dialog.setMessage('กำลังโหลด...');

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
/*
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );*/
  }
}

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _homePage createState() => _homePage();
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

class TabOne extends StatelessWidget {
  TabOne();
  final List<String> _tabList = ["ชุดหลัก", "ชุดรอง"];

  Future<List<Questionnaire>> fetchPosts() async {
    http.Response response = await http.get(
        'https://melondev-frailty-project.herokuapp.com/api/question/showAllQuestionnaire');
    List responseJson = json.decode(response.body);
    return responseJson.map((m) => new Questionnaire.fromJson(m)).toList();
  }

  void a() async {
    String url =
        'https://melondev-frailty-project.herokuapp.com/api/question/showAllQuestionnaire';

    var response = await http.get(url);
    print(response.body);
    List responseJson = json.decode(response.body);

    //Map map = {"id": "", "oauth": value.uid.toString()};
    //var response = await http.post(url, body: map);

    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    //Account account = Account.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Questionnaire>>(
      future: fetchPosts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation(Color(0xFF009688)),
                strokeWidth: 6.0,
              ),
            ),
          );
        }
        List<Questionnaire> questionnaires = snapshot.data;

        return Stack(
          children: <Widget>[
            Container(
              color: Color(0xFFE0E0E0),
              child: ListView.builder(
                itemCount: _tabList.length + questionnaires.length,
                itemBuilder: (context, position) {
                  if (position == 0 || position == 2) {
                    return Container(
                        padding: position == 0
                            ? EdgeInsets.fromLTRB(16, 20, 0, 6)
                            : EdgeInsets.fromLTRB(16, 0, 0, 6),
                        child: Stack(
                          children: <Widget>[
                            Text(
                              position == 0 ? _tabList[0] : _tabList[1],
                              style: TextStyle(
                                color: Colors.black.withAlpha(150),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SukhumvitSet',
                                fontSize: 18.0,
                              ),
                            )
                          ],
                        ));
                  } else {
                    return GestureDetector(
                      onTap: () => {
                            Navigator.push(
                                context,
                                //MaterialPageRoute(builder: (context) => SecondRoute()),
                                QuestionRoute(
                                    builder: (BuildContext context) =>
                              
                                        QuestionPage(position == 1
                                            ? questionnaires[0].id
                                            : questionnaires[position - 2].id)))
                          },
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.white),
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        child: Text(
                                            position == 1
                                                ? questionnaires[0].name
                                                : questionnaires[position - 2]
                                                    .name,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'SukhumvitSet',
                                            )),
                                      ),
                                    ),
                                    Text(
                                        position == 1
                                            ? questionnaires[0].description
                                            : questionnaires[position - 2]
                                                .description,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 17.0,
                                          fontFamily: 'SukhumvitSet',
                                        )),
                                  ],
                                )),
                          )),
                    );
                  }
                },
              ),
            ),
          ],
        );

/*
        return new ListView(
          children: questionnaires
              .map((questionnaire) => Text(questionnaire.name))
              .toList(),
        );
        */
      },
    );
  }
}

class _homePage extends State<HomePage> {
  final List<String> _tabList = ["แบบทดสอบ", "ยังทำไม่เสร็จ", "ทำเสร็จแล้ว"];

  String _titleText = "แบบทดสอบ";

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _tabChildren = [
    TabOne(),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green)
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _titleText = _tabList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Don't show the leading button
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

        /*title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.transparent,
                child: Text('ลงชื่อเข้าใช้ด้วย ชื่อ-นามสกุล',
                    style: TextStyle(
                        fontFamily: 'SukhumvitSet',
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),*/

        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.assignment),
            title: new Text(
              'แบบทดสอบ',
              style: TextStyle(fontFamily: 'SukhumvitSet', fontSize: 16),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.history),
            title: new Text(
              'ยังทำไม่เสร็จ',
              style: TextStyle(fontFamily: 'SukhumvitSet', fontSize: 16),
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.check),
              title: Text(
                'ทำเสร็จแล้ว',
                style: TextStyle(fontFamily: 'SukhumvitSet', fontSize: 16),
              ))
        ],
      ),
      body: _tabChildren[_currentIndex],
    );
  }
}

class Questionnaire {
  final String id;
  final String name;
  final String description;

  Questionnaire({this.id, this.name, this.description});

  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    return new Questionnaire(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
