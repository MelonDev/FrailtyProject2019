import 'dart:core' as prefix2;
import 'dart:core';
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'dart:convert';

//import 'package:permission_handler/permission_handler.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix4;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/rendering.dart';
import 'package:flutter/rendering.dart' as prefix1;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart' as prefix3;
import 'package:frailty_project_2019/main.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

class QuestionApp extends StatelessWidget {
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
      home: QuestionPage(""),
    );
  }
}

class QuestionRoute extends PageRoute<void> {
  QuestionRoute({
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

var futureBuilder = FutureBuilderBloc();
var titleBuilder = TitleBloc();

class QuestionPage extends StatefulWidget {
  String _keys;

  QuestionPage(this._keys);

  @override
  _questionPage createState() => _questionPage();
}

var _appbarTitle = "";

class _questionPage extends State<QuestionPage> {
  @override
  void setState(fn) {
    super.setState(fn);
  }

  nextQuestion() {
    //_key = "5c942947-12ef-4f31-a7ed-6793ad85f609";
    //builder = null;
    //builder = loadFirstQuestion();
    setState(() {
      builder =
          loadTitleQuestion("", "", "5c942947-12ef-4f31-a7ed-6793ad85f609");
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(_key);
    _key = widget._keys;
    //print(_key);

    futureBuilder.create();
    builder = loadFirstQuestion();
    futureBuilder.updateBuilder(loadFirstQuestion());

    titleBuilder.create();
    titleBuilder.updateBuilder("");

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            titleSpacing: 0.0,
            centerTitle: true,
            automaticallyImplyLeading: false, // Don't show the leading button
            title: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 62, 0),
                    color: Colors.transparent,
                    height: double.infinity,
                    width: 62,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          minWidth: 0,
                          height: double.infinity,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.low_priority,
                                  color: Colors.black.withAlpha(180),
                                  size: 30,
                                ),
                              ],
                            ),
                            width: 30,
                            margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Colors.black.withAlpha(0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    color: Colors.transparent,
                    height: double.infinity,
                    width: 62,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        MaterialButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          minWidth: 0,
                          height: double.infinity,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.close,
                                  color: Colors.black.withAlpha(180),
                                  size: 30,
                                ),
                              ],
                            ),
                            width: 30,
                            margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Colors.black.withAlpha(0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: 280,
                          height: 100,
                          child: LayoutBuilder(builder: (context, constraint) {
                            return Container(
                                color: Colors.transparent,
                                width: prefix2.double.infinity,
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 8, 0, 0),
                                                margin: EdgeInsets.fromLTRB(
                                                    16, 0, 20, 0),
                                                child: StreamBuilder(
                                                  stream:
                                                      titleBuilder.titleStream,
                                                  builder: (context, snapshot) {
                                                    String string =
                                                        snapshot.data;
                                                    return Text(
                                                      "${string}",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withAlpha(200),
                                                          fontFamily:
                                                              'SukhumvitSet',
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    );
                                                  },
                                                ))),
                                      ],
                                    ),
                                  ],
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
                          "",
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
            elevation: 0,
          ),
        ),
        body: //builder
            StreamBuilder(
          stream: futureBuilder.questionStream,
          builder: (context, snapshot) {
            FutureBuilder futureBuilder = snapshot.data;
            return futureBuilder;
          },
        ));
  }
}

void nextQuestionss() {
  //_key = "5c942947-12ef-4f31-a7ed-6793ad85f609";
  //builder = null;
  //builder = loadFirstQuestion();
  builder = loadTitleQuestion("", "", "5c942947-12ef-4f31-a7ed-6793ad85f609");
}

FutureBuilder<QuestionSet> builder;

FutureBuilder<QuestionSet> loadFirstQuestion() {
  return FutureBuilder<QuestionSet>(
    future: loadQuestion("", "", _key),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        titleBuilder.updateBuilder("");

        return new Container(
            color: Colors.white,
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(Color(0xFF009688)),
                  strokeWidth: 6.0,
                ),
              ),
            ));
      } else {
        QuestionSet ques = snapshot.data;

        titleBuilder
            .updateBuilder("ข้อที่ ${ques.question.position.toString()}");

        if (ques.question.type.contains("title")) {
          _page = new TitlePage(ques);
        } else if (ques.question.type.contains("number_multiply")) {
          _page = new NumberMultiplyPage(ques);
        } else if (ques.question.type.contains("location_multiply")) {
          _page = new LocationPage(ques);
        } else if (ques.question.type.contains("multiply")) {
          _page = new MultiplyPage(ques);
        } else if (ques.question.type.contains("number")) {
          _page = new NumberPage(ques);
        } else if (ques.question.type.contains("textinput")) {
          _page = new TextInputPage(ques);
        }

        return _page;
      }
    },
  );
}

FutureBuilder<QuestionSet> loadTitleQuestion(
    String questionKey, String choiceKey, String questionnaireKey) {
  bool initss = true;

  return FutureBuilder<QuestionSet>(
    future: loadQuestion(questionKey, choiceKey, questionnaireKey),
    builder: (context, snapshot) {
      if (initss) {
        initss = !snapshot.hasData;
        return new Container(
            color: Colors.white,
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(Color(0xFF009688)),
                  strokeWidth: 6.0,
                ),
              ),
            ));
      } else {
        QuestionSet ques = snapshot.data;

        if (ques.question.type.contains("title")) {
          _page = new TitlePage(ques);
        } else if (ques.question.type.contains("multiply")) {
          _page = new MultiplyPage(ques);
        } else if (ques.question.type.contains("number_multiply")) {
          _page = new NumberMultiplyPage(ques);
        } else if (ques.question.type.contains("location_multiply")) {
          _page = new LocationPage(ques);
        } else if (ques.question.type.contains("number")) {
          _page = new NumberPage(ques);
        } else if (ques.question.type.contains("textinput")) {
          _page = new TextInputPage(ques);
        }
        return _page;
      }
    },
  );
}

Future<QuestionSet> loadQuestion(
    String questionKey, String choiceKey, String questionnaireKey) async {
  //print(questionnaireKey);

  String url =
      'https://melondev-frailty-project.herokuapp.com/api/question/nextQuestion';
  Map map = {
    "currentKey": questionKey,
    "choiceYouChoose": choiceKey,
    "questionnaire": questionnaireKey
  };
  var response = await http.post(url, body: map);
  //print(response.body);
  var responseJson = json.decode(response.body);
  //print(responseJson["question"]);

  Question question = Question.fromJson(responseJson["question"]);
  var choicePath = responseJson["choice"];
  List choice = choicePath.map((m) {
    return Choice.fromJson(m);
  }).toList();

  var set = QuestionSet(question: question, choice: choice);

  return set;
  //print(question.message);
}

Future<QuestionSet> loadData(
    String questionKey, String choiceKey, String questionnaireKey) async {
  //print(questionnaireKey);

  //questionKey = "6f5ef2cb-bd30-4a67-b84c-64912f2d09f1";

  //print(questionKey);
  //print(choiceKey);

  String url =
      'https://melondev-frailty-project.herokuapp.com/api/question/nextQuestionWithFromQuestion';

  //print("currentKey :$questionKey");
  //print("choiceYouChoose :$choiceKey");
  //print("questionnaire :$questionnaireKey");

  Map map = {
    "currentKey": questionKey,
    "choiceYouChoose": choiceKey,
    "questionnaire": questionnaireKey
  };
  var response = await http.post(url, body: map);
  //print("");
  //print(response.body);

  var responseJson = json.decode(response.body);
  //print(responseJson["question"]);

  Question question = Question.fromJson(responseJson["question"]);
  Question fromQuestion = Question.fromJson(responseJson["fromQuestion"]);

  var choicePath = responseJson["choice"];
  List choice = choicePath.map((m) {
    return Choice.fromJson(m);
  }).toList();

  var set = QuestionSet(
      fromQuestion: fromQuestion, question: question, choice: choice);

  if (question.category.length > 1) {
    titleBuilder.updateBuilder(
        "ข้อที่ ${fromQuestion.position.toString()}.${question.position.toString()}");
  } else {
    titleBuilder.updateBuilder("ข้อที่ ${question.position.toString()}");
  }

  return set;
  //print(question.message);
}

FutureBuilder<QuestionSet> nextQuestionProcess(
    String questionKey, String choiceKey, String questionnaireKey) {
  bool initss = true;

  return FutureBuilder<QuestionSet>(
    future: loadData(questionKey, choiceKey, questionnaireKey),
    builder: (context, snapshot) {
      if (initss) {
        initss = !snapshot.hasData;
        titleBuilder.updateBuilder("");
        return new Container(
            color: Colors.white,
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 60,
                width: 60,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation(Color(0xFF009688)),
                  strokeWidth: 6.0,
                ),
              ),
            ));
      } else {
        QuestionSet ques = snapshot.data;

        if (ques.question.type.contains("title")) {
          _page = new TitlePage(ques);
        } else if (ques.question.type.contains("number_multiply")) {
          _page = new NumberMultiplyPage(ques);
        } else if (ques.question.type.contains("location_multiply")) {
          _page = new LocationPage(ques);
        } else if (ques.question.type.contains("multiply")) {
          _page = new MultiplyPage(ques);
        } else if (ques.question.type.contains("number")) {
          _page = new NumberPage(ques);
        } else if (ques.question.type.contains("textinput")) {
          _page = new TextInputPage(ques);
        }

        return _page;
      }
    },
  );
}

nextQuestion(String questionKey, String choiceKey, String questionnaireKey) {
  futureBuilder.updateBuilder(
      nextQuestionProcess(questionKey, choiceKey, questionnaireKey));
}

var _title = "";
var _key = "";
var _page;

class TitlePage extends StatefulWidget {
  QuestionSet ques;

  TitlePage(this.ques);

  @override
  _titleWidget createState() => _titleWidget(ques);
}

class _titleWidget extends State<TitlePage> {
  QuestionSet ques;

  _titleWidget(this.ques);

  void nextQuestionsss() {
    //_key = "5c942947-12ef-4f31-a7ed-6793ad85f609";
    //builder = null;
    //builder = loadFirstQuestion();
    setState(() {
      loadTitleQuestion("", "", "5c942947-12ef-4f31-a7ed-6793ad85f609");
    });
  }

  @override
  Widget build(BuildContext context) {
    //loadQuestion("", "", this.keys);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          //color: Color(0xFF009688),
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 200),
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.transparent,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              color: Colors.white,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: AutoSizeText(
                                ques.question.message,
                                minFontSize: 16,
                                maxFontSize: 30,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.black.withAlpha(200),
                                  fontWeight: FontWeight.bold,
                                  //color: Colors.white.withAlpha(230),
                                  fontFamily: 'SukhumvitSet',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
                              width: double.infinity,
                              height: 200,
                              color: Colors.white,
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.center,
                                      child: FlatButton(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onPressed: () {
                                          nextQuestion(ques.question.id, "",
                                              ques.question.questionnaireId);
                                          /*futureBuilder.updateBuilder(nextQuestion(
                                        ques.question.id,
                                        "",
                                        ques.question.questionnaireId));*/
                                        },
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 30,
                                            color: Colors.black.withAlpha(180),
                                          ),
                                          decoration: BoxDecoration(
                                              border: new Border.all(
                                                  color: Colors.black
                                                      .withAlpha(180),
                                                  width: 2.0),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                              color: Colors.white),
                                        ),
                                      ))
                                ],
                              )),
                        )
                      ],
                    )))
          ]),
        ),
      ),
    );
  }
}

class MultiplyPage extends StatefulWidget {
  QuestionSet ques;

  MultiplyPage(this.ques);

  @override
  _multiplyWidget createState() => _multiplyWidget(ques);
}

class _multiplyWidget extends State<MultiplyPage> {
  QuestionSet ques;

  _multiplyWidget(this.ques);

  double _listHeight = 0;

  var count = 2;

  int calListHeight() {
    //var count = ques.choice.length;
    var count = 1;
    //40+(count*80);
    setState(() {
      _listHeight = 40 + (count * 80).toDouble();
    });
    return count;
  }

  double calDesHeight() {
    //return 440;
    //return 350;
    if (MediaQuery.of(context).size.height > 880) {
      return (40 + (ques.choice.length * 80) + 30).toDouble();
    } else {
      return (40 +
              ((ques.choice.length > 4 ? 4 : ques.choice.length) * 80) +
              (ques.choice.length <= 4 ? 30 : 0))
          .toDouble();
    }
    //return (40 + (ques.choice.length * 80) + 30).toDouble();
    /*return (40 +
            ((ques.choice.length > 4 ? 4 : ques.choice.length) * 80) +
            (ques.choice.length <= 4 ? 30 : 0))
        .toDouble();*/
  }

  double calChoiceAreaHeight() {
    if (MediaQuery.of(context).size.height > 880) {
      return (40 + (ques.choice.length * 80) + 30).toDouble();
    } else {
      return (40 +
              ((ques.choice.length > 4 ? 4 : ques.choice.length) * 80) +
              (ques.choice.length <= 4 ? 30 : 0))
          .toDouble();
    }
    //return (40 + (ques.choice.length * 80) + 30).toDouble();
    /*return (40 +
            ((ques.choice.length > 4 ? 4 : ques.choice.length) * 80) +
            (ques.choice.length <= 4 ? 30 : 0))
        .toDouble();*/
  }

  double calChoiceAreaMarginTop() {
    if (MediaQuery.of(context).size.height > 880) {
      return (550 - (ques.choice.length * 80) - 30).toDouble();
    } else {
      return (550 -
              ((ques.choice.length > 4 ? 4 : ques.choice.length) * 80) -
              (ques.choice.length <= 4 ? 30 : 0))
          .toDouble();
    }
    //return (550 - (ques.choice.length * 80) - 30).toDouble();
    /*return (550 -
            ((ques.choice.length > 4 ? 4 : ques.choice.length) * 80) -
            (ques.choice.length <= 4 ? 30 : 0))
        .toDouble();*/
  }

  @override
  Widget build(BuildContext context) {
    //loadQuestion("", "", this.keys);

    print(MediaQuery.of(context).size.height);

    print(MediaQuery.of(context).size.height - calChoiceAreaMarginTop());

    print(calDesHeight());
    print(calChoiceAreaHeight());
    print(calChoiceAreaMarginTop());

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          color: Colors.black.withAlpha(30),
          //color: Color(0xFF009688),
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            //margin: EdgeInsets.fromLTRB(0, 0, 0, (20+(80*count)).toDouble()),
                            margin:
                                EdgeInsets.fromLTRB(0, 0, 0, calDesHeight()),
                            height: double.infinity,
                            width: double.infinity,
                            color: Colors.transparent,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: AutoSizeText(
                                  ques.question.message,
                                  minFontSize: 16,
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.black.withAlpha(160),
                                    fontWeight: FontWeight.w700,
                                    //color: Colors.white.withAlpha(230),
                                    fontFamily: 'SukhumvitSet',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              //margin: EdgeInsets.fromLTRB(0, 580, 0, 0),
                              /*
                            margin: EdgeInsets.fromLTRB(
                                0,
                                (560 - ((count > 5 ? 5 : count) * 80))
                                    .toDouble(),
                                0,
                                0),
                                */

                              margin: EdgeInsets.fromLTRB(
                                  0, calChoiceAreaMarginTop(), 0, 0),
                              width: double.infinity,
                              height: calChoiceAreaHeight(),
                              //height: (50 + (count * 80)).toDouble(),
                              //height: 200,
                              color: Colors.white,
                              child: Stack(
                                children: <Widget>[
                                  ListView.builder(
                                      itemCount: ques.choice.length + 1,
                                      //itemCount: count,
                                      itemBuilder: (context, position) {
                                        if (position == 0) {
                                          return Container(
                                            margin: EdgeInsets.fromLTRB(
                                                20, 20, 20, 0),
                                            color: Colors.transparent,
                                            height: 30,
                                            width: double.infinity,
                                            child: Text(
                                              "ตัวเลือก ${ques.choice.length} ข้อ",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                    Colors.teal.withAlpha(255),
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'SukhumvitSet',
                                              ),
                                            ),
                                          );
                                        } else {
                                          return GestureDetector(
                                              onTap: () {
                                                nextQuestion(
                                                    ques.question.id,
                                                    (ques.choice[position - 1]
                                                            as Choice)
                                                        .id,
                                                    ques.question
                                                        .questionnaireId);
                                              },
                                              child: Container(
                                                margin: position == 0
                                                    ? EdgeInsets.fromLTRB(
                                                        20, 30, 20, 10)
                                                    : EdgeInsets.fromLTRB(
                                                        20, 10, 20, 10),
                                                width: double.infinity,
                                                height: 60,
                                                child: Align(
                                                  child: Text(
                                                    (ques.choice[position - 1]
                                                            as Choice)
                                                        .message,
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.white
                                                          .withAlpha(255),
                                                      //color: Color(0xFF42A898),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      //color: Colors.white.withAlpha(230),
                                                      fontFamily:
                                                          'SukhumvitSet',
                                                    ),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    /*border: new Border.all(
                                                        color:
                                                            Color(0xFF42A898),
                                                        width: 3.0),*/
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                16)),
                                                    //color: Colors.black.withAlpha(50)
                                                    color: Color(0xFF009688)),
                                                //color: Colors.white)
                                              ));
                                        }
                                      })
                                ],
                              )),
                        )
                      ],
                    )))
          ]),
        ),
      ),
    );
  }
}

class NumberMultiplyPage extends StatefulWidget {
  QuestionSet ques;

  NumberMultiplyPage(this.ques);

  @override
  _numberMultiplyWidget createState() => _numberMultiplyWidget(ques);
}

class _numberMultiplyWidget extends State<NumberMultiplyPage> {
  QuestionSet ques;

  _numberMultiplyWidget(this.ques);

  bool _actionBtn = false;

  List<int> arr = <int>[];

  generateNumber() {
    arr.clear();
    var count = 0;
    while (count <= 300) {
      arr.add(count);
      count++;
    }
  }

  @override
  Widget build(BuildContext context) {
    //loadQuestion("", "", this.keys);

    generateNumber();

    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Stack(
        children: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 311),
              height: double.infinity,
              width: double.infinity,
              color: Color(0xFFEDEDED),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: AutoSizeText(
                    ques.question.message,
                    minFontSize: 16,
                    maxFontSize: 28,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black.withAlpha(200),
                      fontWeight: FontWeight.bold,
                      //color: Colors.white.withAlpha(230),
                      fontFamily: 'SukhumvitSet',
                    ),
                  ),
                ),
              )),
          Container(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            height: 215,
                            width: (MediaQuery.of(context).size.width - 41) / 2,
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    (ques.choice[0] as Choice).message,
                                    style: TextStyle(
                                        fontFamily: 'SukhumvitSet',
                                        fontSize: 22,
                                        color: Colors.black.withAlpha(150),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width:
                                      (MediaQuery.of(context).size.width - 41) /
                                          2,
                                  height: 160,
                                  child: CupertinoPicker(
                                    offAxisFraction: 0.0,
                                    magnification: 1.5,
                                    backgroundColor: Colors.white,
                                    children: List<Widget>.generate(arr.length,
                                        (int index) {
                                      return Center(
                                        child: Text(
                                          arr[index].toString(),
                                          style: TextStyle(
                                              fontFamily: 'SukhumvitSet',
                                              fontSize: 22,
                                              color:
                                                  Colors.black.withAlpha(200),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }),
                                    itemExtent: 30,
                                    onSelectedItemChanged: (int value) {},
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          width: 1,
                          height: 160,
                          color: Colors.black.withAlpha(30),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            height: 215,
                            width: (MediaQuery.of(context).size.width - 41) / 2,
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    (ques.choice[1] as Choice).message,
                                    style: TextStyle(
                                        fontFamily: 'SukhumvitSet',
                                        fontSize: 22,
                                        color: Colors.black.withAlpha(150),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width:
                                      (MediaQuery.of(context).size.width - 41) /
                                          2,
                                  height: 160,
                                  child: CupertinoPicker(
                                    offAxisFraction: 0.0,
                                    magnification: 1.5,
                                    backgroundColor: Colors.white,
                                    children: List<Widget>.generate(arr.length,
                                        (int index) {
                                      return Center(
                                        child: Text(
                                          arr[index].toString(),
                                          style: TextStyle(
                                              fontFamily: 'SukhumvitSet',
                                              fontSize: 22,
                                              color:
                                                  Colors.black.withAlpha(200),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      );
                                    }),
                                    itemExtent: 30,
                                    onSelectedItemChanged: (int value) {},
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 20, 30, 26),
                      width: double.infinity,
                      height: 96,
                      color: Colors.white,
                      child: MaterialButton(
                        minWidth: 256,
                        height: 40,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        splashColor: Colors.white12,
                        color: Colors.teal,
                        elevation: 0,
                        highlightElevation: 0,
                        child: Text(
                          "ยืนยัน",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (_actionBtn) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            _actionBtn = false;
                          } else {
                            nextQuestion(ques.question.id, "",
                                ques.question.questionnaireId);
                          }
                        },
                      ),
                    )
                  ],
                )),
          ),
        ],
      )),
    );
  }
}

class LocationPage extends StatefulWidget {
  QuestionSet ques;

  LocationPage(this.ques);

  @override
  _locationWidget createState() => _locationWidget(ques);
}

class _locationWidget extends State<LocationPage> {
  QuestionSet ques;

  QuestionSet qFix;

  _locationWidget(this.ques);

  double _listHeight = 0;

  var count = 2;

  int calListHeight() {
    //var count = ques.choice.length;
    var count = 1;
    //40+(count*80);
    setState(() {
      _listHeight = 40 + (count * 80).toDouble();
    });
    return count;
  }

  double calDesHeight() {
    //return 440;
    //return 350;
    if (MediaQuery.of(context).size.height > 880) {
      return (40 + (ques.choice.length * 80) + 30).toDouble();
    } else {
      return (40 +
              ((ques.choice.length > 4 ? 4 : ques.choice.length) * 80) +
              (ques.choice.length <= 4 ? 30 : 0))
          .toDouble();
    }
    //return (40 + (ques.choice.length * 80) + 30).toDouble();
    /*return (40 +
            ((ques.choice.length > 4 ? 4 : ques.choice.length) * 80) +
            (ques.choice.length <= 4 ? 30 : 0))
        .toDouble();*/
  }

  double calChoiceAreaHeight() {
    if (MediaQuery.of(context).size.height > 880) {
      return (40 + (ques.choice.length * 80) + 30).toDouble();
    } else {
      return (40 +
              ((ques.choice.length > 4 ? 4 : ques.choice.length) * 80) +
              (ques.choice.length <= 4 ? 30 : 0))
          .toDouble();
    }
    //return (40 + (ques.choice.length * 80) + 30).toDouble();
    /*return (40 +
            ((ques.choice.length > 4 ? 4 : ques.choice.length) * 80) +
            (ques.choice.length <= 4 ? 30 : 0))
        .toDouble();*/
  }

  double calChoiceAreaMarginTop() {
    if (MediaQuery.of(context).size.height > 880) {
      return (550 - (ques.choice.length * 80) - 30).toDouble();
    } else {
      return (550 -
              ((ques.choice.length > 4 ? 4 : ques.choice.length) * 80) -
              (ques.choice.length <= 4 ? 30 : 0))
          .toDouble();
    }
    //return (550 - (ques.choice.length * 80) - 30).toDouble();
    /*return (550 -
            ((ques.choice.length > 4 ? 4 : ques.choice.length) * 80) -
            (ques.choice.length <= 4 ? 30 : 0))
        .toDouble();*/
  }

  void _showDialog(String title, String message) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            title,
            style: TextStyle(
              fontFamily: 'SukhumvitSet',
            ),
          ),
          content: new Text(
            message,
            style: TextStyle(
              fontFamily: 'SukhumvitSet',
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /*
  PermissionStatus permissionStatus;

  @override
  void initState() {
    super.initState();

    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse)
        .then(_update);
  }

  void _update(PermissionStatus status) {
    if (status != permissionStatus) {
      setState(() {
        permissionStatus = status;
      });
      if (permissionStatus == PermissionStatus.unknown ||
          permissionStatus == PermissionStatus.denied) {
        _askPermission();
      }
    }
  }

  void _askPermission() {
    prefix2.print("Hello");
    PermissionHandler()
        .requestPermissions([PermissionGroup.locationWhenInUse]).then(_request);
  }

  void _request(Map<PermissionGroup, PermissionStatus> status) {
    prefix2.print("_request");
    final statuss = status[PermissionGroup.locationWhenInUse];
    _update(statuss);
  }


   */
  /*
  void getLocation() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    prefix2.print(geolocationStatus.toString());
    prefix2.print(geolocationStatus.value);

    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse);
    print(permission.value);

    //bool a = await _requestPermission(PermissionGroup.location);
    //prefix2.print(a);

    if (permission == PermissionStatus.granted) {
      var lo = await Geolocator().getCurrentPosition();
      _showDialog("Your Location","Lat: ${lo.latitude}\nLong: ${lo.longitude}\nTimeStamp: ${lo.timestamp}\nSpeed: ${lo.speed}\nSpeedAccuracy: ${lo.speedAccuracy}" );
    }
  }

   */

  /*
  Future<bool> _requestPermission(PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

*/

  @override
  Widget build(BuildContext context) {
    //prefix2.print(permissionStatus);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          color: Colors.black.withAlpha(30),
          //color: Color(0xFF009688),
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            //margin: EdgeInsets.fromLTRB(0, 0, 0, (20+(80*count)).toDouble()),
                            margin:
                                EdgeInsets.fromLTRB(0, 0, 0, calDesHeight()),
                            height: double.infinity,
                            width: double.infinity,
                            color: Colors.transparent,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: AutoSizeText(
                                  ques.question.message,
                                  minFontSize: 16,
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.black.withAlpha(160),
                                    fontWeight: FontWeight.w700,
                                    //color: Colors.white.withAlpha(230),
                                    fontFamily: 'SukhumvitSet',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              //margin: EdgeInsets.fromLTRB(0, 580, 0, 0),
                              /*
                            margin: EdgeInsets.fromLTRB(
                                0,
                                (560 - ((count > 5 ? 5 : count) * 80))
                                    .toDouble(),
                                0,
                                0),
                                */

                              margin: EdgeInsets.fromLTRB(
                                  0, calChoiceAreaMarginTop(), 0, 0),
                              width: double.infinity,
                              height: calChoiceAreaHeight(),
                              //height: (50 + (count * 80)).toDouble(),
                              //height: 200,
                              color: Colors.white,
                              child: Stack(
                                children: <Widget>[
                                  ListView.builder(
                                      itemCount: ques.choice.length + 1,
                                      //itemCount: count,
                                      itemBuilder: (context, position) {
                                        if (position == 0) {
                                          return Container(
                                            margin: EdgeInsets.fromLTRB(
                                                20, 20, 20, 0),
                                            color: Colors.transparent,
                                            height: 30,
                                            width: double.infinity,
                                            child: Text(
                                              "ตัวเลือก ${ques.choice.length} ข้อ",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                    Colors.teal.withAlpha(255),
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'SukhumvitSet',
                                              ),
                                            ),
                                          );
                                        } else {
                                          return GestureDetector(
                                              onTap: () {
                                                /*nextQuestion(
                                                    ques.question.id,
                                                    (ques.choice[position - 1]
                                                            as Choice)
                                                        .id,
                                                    ques.question
                                                        .questionnaireId);*/
                                                //getLocation();
                                              },
                                              child: Container(
                                                margin: position == 0
                                                    ? EdgeInsets.fromLTRB(
                                                        20, 30, 20, 10)
                                                    : EdgeInsets.fromLTRB(
                                                        20, 10, 20, 10),
                                                width: double.infinity,
                                                height: 60,
                                                child: Align(
                                                  child: Text(
                                                    (ques.choice[position - 1]
                                                            as Choice)
                                                        .message,
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      color: Colors.white
                                                          .withAlpha(255),
                                                      //color: Color(0xFF42A898),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      //color: Colors.white.withAlpha(230),
                                                      fontFamily:
                                                          'SukhumvitSet',
                                                    ),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                    /*border: new Border.all(
                                                        color:
                                                            Color(0xFF42A898),
                                                        width: 3.0),*/
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                16)),
                                                    //color: Colors.black.withAlpha(50)
                                                    color: Color(0xFF009688)),
                                                //color: Colors.white)
                                              ));
                                        }
                                      })
                                ],
                              )),
                        )
                      ],
                    )))
          ]),
        ),
      ),
    );
  }


}

class TextInputPage extends StatefulWidget {
  QuestionSet ques;

  TextInputPage(this.ques);

  @override
  _textInputWidget createState() => _textInputWidget(ques);
}

class _textInputWidget extends State<TextInputPage> {
  QuestionSet ques;

  _textInputWidget(this.ques);

  bool _actionBtn = false;

  @override
  Widget build(BuildContext context) {
    //loadQuestion("", "", this.keys);

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          //color: Color(0xFF009688),
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0, 0, 0, _actionBtn ? 180 : 240),
                          height: double.infinity,
                          width: double.infinity,
                          color: Colors.black.withAlpha(30),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: AutoSizeText(
                                ques.question.message,
                                minFontSize: 16,
                                maxFontSize: 34,
                                style: prefix1.TextStyle(
                                  fontSize: 34,
                                  color: Colors.black.withAlpha(200),
                                  fontWeight: FontWeight.bold,
                                  //color: Colors.white.withAlpha(230),
                                  fontFamily: 'SukhumvitSet',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              margin: EdgeInsets.fromLTRB(0, 00, 0, 0),
                              width: double.infinity,
                              height: _actionBtn ? 150 : 220,
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(20, 0, 20, 0),
                                          child: Text(
                                            "กรุณาใส่คำตอบ",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontFamily: 'SukhumvitSet',
                                                color:
                                                    Colors.black.withAlpha(150),
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        height: 50,
                                        margin:
                                            EdgeInsets.fromLTRB(20, 16, 20, 0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.black.withAlpha(30)),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                20, 0, 20, 0),
                                            child: TextField(
                                                keyboardAppearance: Brightness
                                                    .light,
                                                keyboardType: TextInputType
                                                    .text,
                                                onTap: () {
                                                  _actionBtn = true;
                                                },
                                                onSubmitted: (str) {
                                                  _actionBtn = false;
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          new FocusNode());
                                                },
                                                style: TextStyle(
                                                    fontFamily: 'SukhumvitSet',
                                                    color: Colors.black,
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.normal),
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration
                                                    .collapsed(
                                                        hintText: 'พิมพ์ที่นี่',
                                                        hintStyle: TextStyle(
                                                            fontFamily:
                                                                'SukhumvitSet',
                                                            color: Colors.black
                                                                .withAlpha(120),
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                        border:
                                                            InputBorder.none)),
                                          ),
                                        )),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(20, 30, 20, 0),
                                        child: Visibility(
                                          visible: !_actionBtn,
                                          child: MaterialButton(
                                            minWidth: 258,
                                            height: 56,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        16.0)),
                                            splashColor: Colors.white12,
                                            color: Colors.teal,
                                            elevation: 0,
                                            highlightElevation: 0,
                                            child: Text(
                                              "ยืนยัน",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontFamily: 'SukhumvitSet',
                                                  fontSize: 22,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () {
                                              if (_actionBtn) {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                                _actionBtn = false;
                                              } else {
                                                nextQuestion(
                                                    ques.question.id,
                                                    "",
                                                    ques.question
                                                        .questionnaireId);
                                              }
                                            },
                                          ),
                                        )),
                                  )
                                ],
                              )),
                        )
                      ],
                    )))
          ]),
        ),
      ),
    );
  }
}

class NumberPage extends StatefulWidget {
  QuestionSet ques;

  NumberPage(this.ques);

  @override
  _numbertWidget createState() => _numbertWidget(ques);
}

class _numbertWidget extends State<NumberPage> {
  QuestionSet ques;

  List<int> arr = <int>[];

  bool _actionBtn = false;

  _numbertWidget(this.ques);

  generateNumber() {
    arr.clear();
    var count = 0;
    while (count < 300) {
      count++;
      arr.add(count);
    }
  }

  @override
  Widget build(BuildContext context) {
    //loadQuestion("", "", this.keys);

    generateNumber();
    return Container(
      color: Colors.white,
      child: SafeArea(
          child: Container(
              child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 296),
                height: double.infinity,
                width: double.infinity,
                color: Color(0xFFEDEDED),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: AutoSizeText(
                      ques.question.message,
                      minFontSize: 16,
                      maxFontSize: 34,
                      style: prefix1.TextStyle(
                        fontSize: 34,
                        color: Colors.black.withAlpha(200),
                        fontWeight: FontWeight.bold,
                        //color: Colors.white.withAlpha(230),
                        fontFamily: 'SukhumvitSet',
                      ),
                    ),
                  ),
                )),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: CupertinoPicker(
                      useMagnifier: true,
                      offAxisFraction: 0.0,
                      magnification: 1.3,
                      backgroundColor: Colors.white,
                      children: List<Widget>.generate(arr.length, (int index) {
                        return Center(
                          child: Text(
                            arr[index].toString(),
                            style: TextStyle(
                                fontFamily: 'SukhumvitSet',
                                fontSize: 22,
                                color: Colors.black.withAlpha(200),
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }),
                      itemExtent: 30,
                      onSelectedItemChanged: (int value) {},
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 6, 30, 36),
                    width: double.infinity,
                    height: 96,
                    color: Colors.white,
                    child: MaterialButton(
                      minWidth: 256,
                      height: 40,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                      splashColor: Colors.white12,
                      color: Colors.teal,
                      elevation: 0,
                      highlightElevation: 0,
                      child: Text(
                        "ยืนยัน",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'SukhumvitSet',
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (_actionBtn) {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          _actionBtn = false;
                        } else {
                          nextQuestion(ques.question.id, "",
                              ques.question.questionnaireId);
                        }
                      },
                    ),
                  )
                ],
              )),
        ],
      ))),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: SafeArea(
        child: Container(
          color: Colors.cyan,
        ),
      ),
    );
  }
}

class Choice {
  String id;
  String message;
  String questionId;
  int position;
  String destinationId;

  Choice({
    this.id,
    this.message,
    this.questionId,
    this.position,
    this.destinationId,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return new Choice(
      id: json['id'],
      message: json['message'],
      questionId: json['questionId'],
      position: json['position'],
      destinationId: json['destinationId'],
    );
  }
}

class Question {
  final String id;
  final String message;
  final String type;
  final int position;
  final String questionnaireId;
  final String category;

  Question(
      {this.id,
      this.message,
      this.type,
      this.position,
      this.questionnaireId,
      this.category});

  factory Question.fromJson(Map<String, dynamic> json) {
    return new Question(
      id: json['id'],
      message: json['message'],
      type: json['type'],
      position: json['position'],
      questionnaireId: json['questionnaireId'],
      category: json['category'],
    );
  }
}

class QuestionSet {
  Question fromQuestion;
  Question question;
  List choice;

  QuestionSet({
    this.fromQuestion,
    this.question,
    this.choice,
  });

  factory QuestionSet.fromJson(Map<String, dynamic> json) {
    return new QuestionSet(
      fromQuestion: json['fromQuestion'],
      question: json['question'],
      choice: json['choice'],
    );
  }
}

class FutureBuilderBloc {
  StreamController _questionStreamController =
      StreamController<FutureBuilder>();

  Stream get questionStream => _questionStreamController.stream;

  Stream create() {
    _questionStreamController = StreamController<FutureBuilder>();
    return _questionStreamController.stream;
  }

  dispose() {
    _questionStreamController.close();
  }

  updateBuilder(FutureBuilder builder) {
    _questionStreamController.sink.add(builder);
  }
}

class TitleBloc {
  StreamController _titleStreamController = StreamController<String>();

  Stream get titleStream => _titleStreamController.stream;

  Stream create() {
    _titleStreamController = StreamController<String>();
    return _titleStreamController.stream;
  }

  dispose() {
    _titleStreamController.close();
  }

  updateBuilder(String string) {
    _titleStreamController.sink.add(string);
  }
}
