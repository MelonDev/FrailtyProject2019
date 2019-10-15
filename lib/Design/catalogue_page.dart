import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frailty_project_2019/Bloc/catalogue/catalogue_bloc.dart';
import 'package:frailty_project_2019/Bloc/questionnaire/questionnaire_bloc.dart';
import 'package:frailty_project_2019/Design/question_page.dart';
import 'package:frailty_project_2019/Question.dart';
import 'package:frailty_project_2019/Tools/frailty_route.dart';
import 'package:frailty_project_2019/home.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CataloguePage extends StatefulWidget {
  CataloguePage();

  @override
  _cataloguePage createState() => _cataloguePage();
}

class _cataloguePage extends State<CataloguePage> {
  final List<String> _tabList = ["แบบทดสอบ", "ยังทำไม่เสร็จ", "ทำเสร็จแล้ว"];

  //CatalogueBloc _catalogueBloc; = CatalogueBloc();

  CatalogueBloc _catalogueBloc;

  String _titleText = "แบบทดสอบ";

  int _currentIndex = 0;

  ThemeData _themeData;

  @override
  void initState() {
    super.initState();
    _catalogueBloc = BlocProvider.of<CatalogueBloc>(this.context);

    _catalogueBloc.dispatch(QuestionnaireSelectedEvent());
  }

  List<Widget> _tabChildren = [
    QuestionnaireTab(null),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green)
  ];

  void onTabTapped(int index) {
    if (index == 0) {
      _catalogueBloc.dispatch(QuestionnaireSelectedEvent());
    } else if (index == 1) {
      _catalogueBloc.dispatch(UncompletedSelectedEvent());
    } else if (index == 2) {
      _catalogueBloc.dispatch(CompletedSelectedEvent());
    }
    setState(() {
      _currentIndex = index;
      _titleText = _tabList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);

    return BlocBuilder<CatalogueBloc, CatalogueState>(
        builder: (context, _state) {
      return mainLayout(context, _state);
    });
  }

  Widget mainLayout(BuildContext context, CatalogueState _state) {
    return Scaffold(
      backgroundColor: _themeData.backgroundColor,
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
                              color: _themeData.primaryTextTheme.title.color,
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
                          color: _themeData.primaryTextTheme.title.color,
                          //color: Colors.black.withAlpha(200),
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

        brightness: _themeData.brightness,
        backgroundColor: _themeData.primaryColor,
        elevation: 1,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: _themeData.accentColor,
        backgroundColor: _themeData.primaryColor,
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
      //body: _tabChildren[_currentIndex],
      body: _loadWidgetToLayout(_state),
    );
  }

  Widget _loadWidgetToLayout(CatalogueState _state) {
    if (_state is InitialCatalogueState) {
      _catalogueBloc.dispatch(QuestionnaireSelectedEvent());
      return PlaceholderWidget(Colors.yellow);
    } else if (_state is QuestionnaireCatalogueState) {
      return QuestionnaireTab(_state);
    } else if (_state is UncompletedCatalogueState) {
      return UncompletedTab(_state);
    } else if (_state is CompletedCatalogueState) {
      return PlaceholderWidget(_themeData.backgroundColor);
    } else if (_state is LoadingCatalogueState) {
      return loadingTab();
    } else {
      return Container();
    }
  }

  Widget loadingTab() {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SpinKitThreeBounce(
          color: Colors.black38,
          size: 50.0,
        ),
      ),
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
    );
  }
}

class UncompletedTab extends StatelessWidget {
  CatalogueBloc _catalogueBloc;

  UncompletedCatalogueState _state;

  UncompletedTab(this._state);

  ThemeData _themeData;

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);

    _catalogueBloc = BlocProvider.of<CatalogueBloc>(context);

    if (this._state == null) {
      return Container();
    } else {
      return Stack(
        children: <Widget>[
          Container(
            //color: Color(0xFFE0E0E0),
            color: _themeData.backgroundColor,
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              itemCount: _state.data.length,
              itemBuilder: (context, position) {
                return Slidable(
                  actionPane: SlidableBehindActionPane(),
                  actionExtentRatio: 0.25,
                  child: _cardWidget(context, position),
                  secondaryActions: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 16, 32),
                      child: IconSlideAction(
                        caption: 'ลบ',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          _catalogueBloc.dispatch(UncompletedDeleteItemEvent(
                              _state.data[position]));
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      );
    }
  }

  Widget _cardWidget(BuildContext context, int position) {
    return GestureDetector(
      onTap: () => {},
      child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: _themeData.cardColor),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RoundedProgressBar(

                        height: 10,
                        milliseconds: 2000,
                        percent: _calculatePercent(_state.data[position].totalQuestion.toDouble(),_state.data[position].completedQuestion.toDouble()),
                        style: RoundedProgressBarStyle(
                          colorBorder: _themeData.backgroundColor,
                          backgroundProgress: _themeData.backgroundColor,
                          colorProgress: _themeData.canvasColor,
                            borderWidth: 1, widthShadow: 0),
                        borderRadius: BorderRadius.circular(10)),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                        text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                  text: "ไอดี: ",
                                  style: TextStyle(
                                      color: _themeData
                                          .primaryTextTheme.title.color
                                          .withAlpha(200),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      fontFamily: _themeData
                                          .primaryTextTheme.title.fontFamily)),
                              TextSpan(
                                  text:
                                      "${_state.data[position].answerPack.id}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: _themeData
                                          .primaryTextTheme.title.color
                                          .withAlpha(170),
                                      fontSize: 18,
                                      fontFamily: _themeData.primaryTextTheme
                                          .subtitle.fontFamily)),
                            ]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    RichText(
                      text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                                text: "จำนวนข้อที่ทำ: ",
                                style: TextStyle(
                                    color: _themeData
                                        .primaryTextTheme.title.color
                                        .withAlpha(200),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: _themeData
                                        .primaryTextTheme.title.fontFamily)),
                            TextSpan(
                                text:
                                    "${_state.data[position].completedQuestion} จาก ${_state.data[position].totalQuestion} ข้อ",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: _themeData
                                        .primaryTextTheme.title.color
                                        .withAlpha(170),
                                    fontSize: 18,
                                    fontFamily: _themeData
                                        .primaryTextTheme.subtitle.fontFamily)),
                          ]),
                      maxLines: 1,
                    ),
                    RichText(
                      text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                                text: "วันที่ทำ: ",
                                style: TextStyle(
                                    color: _themeData
                                        .primaryTextTheme.title.color
                                        .withAlpha(200),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: _themeData
                                        .primaryTextTheme.title.fontFamily)),
                            TextSpan(
                                text:
                                    "${_loadDate(_state.data[position].answerPack.dateTime)}",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: _themeData
                                        .primaryTextTheme.title.color
                                        .withAlpha(170),
                                    fontSize: 18,
                                    fontFamily: _themeData
                                        .primaryTextTheme.subtitle.fontFamily)),
                          ]),
                      maxLines: 1,
                    ),
                    RichText(
                      text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                                text: "ชื่อชุดแบบทดสอบ: ",
                                style: TextStyle(
                                    color: _themeData
                                        .primaryTextTheme.title.color
                                        .withAlpha(200),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: _themeData
                                        .primaryTextTheme.title.fontFamily)),
                            TextSpan(
                                text:
                                    "\n${_state.data[position].questionnaire.name}",
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: _themeData
                                        .primaryTextTheme.title.color
                                        .withAlpha(170),
                                    fontSize: 18,
                                    fontFamily: _themeData
                                        .primaryTextTheme.subtitle.fontFamily)),
                          ]),
                    ),
                  ],
                )),
          )),
    );
  }

  double _calculatePercent(double full,double current){
    return (current * 100)/full;
  }

  String _loadDate(String date) {
    var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    DateTime dateTime = formatter.parse(date);
    return "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year + 543} (${dateTime.hour}:${dateTime.minute})";
  }

  String _getMonthName(int monthInt) {
    String month = "";
    switch (monthInt) {
      case 1:
        month = "มกราคม";
        break;
      case 2:
        month = "กุมภาพันธ์";
        break;
      case 3:
        month = "มีนาคม";
        break;
      case 4:
        month = "เมษายน";
        break;
      case 5:
        month = "พฤษภาคม";
        break;
      case 6:
        month = "มิถุนายน";
        break;
      case 7:
        month = "กรกฎาคม";
        break;
      case 8:
        month = "สิงหาคม";
        break;
      case 9:
        month = "กันยายน";
        break;
      case 10:
        month = "ตุลาคม";
        break;
      case 11:
        month = "พฤษจิกายน";
        break;
      case 12:
        month = "ธันวาคม";
        break;
    }
    return month;
  }
}

class QuestionnaireTab extends StatelessWidget {
  QuestionnaireCatalogueState _state;

  QuestionnaireTab(this._state);

  ThemeData _themeData;

  final List<String> _tabList = ["ชุดหลัก", "ชุดรอง"];

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);

    if (this._state == null) {
      return Container();
    } else {
      return Stack(
        children: <Widget>[
          Container(
            //color: Color(0xFFE0E0E0),
            color: _themeData.backgroundColor,
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              itemCount: (_state.questionnaireList == null
                  ? 0
                  : _tabList.length + _state.questionnaireList.length),
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
                              //color: Colors.black.withAlpha(150),
                              color: _themeData.primaryTextTheme.subtitle.color,
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
                          FrailtyRoute(
                              builder: (BuildContext context) => MainQuestion(
                                  position == 1
                                      ? _state.questionnaireList[0].id
                                      : _state
                                          .questionnaireList[position - 2].id,
                                  Uuid().v4())))
                    },
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: _themeData.cardColor),
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Text(
                                          position == 1
                                              ? _state.questionnaireList[0].name
                                              : _state
                                                  .questionnaireList[
                                                      position - 2]
                                                  .name,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: _themeData
                                                .primaryTextTheme.title.color
                                                .withAlpha(160),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'SukhumvitSet',
                                          )),
                                    ),
                                  ),
                                  Text(
                                      position == 1
                                          ? _state
                                              .questionnaireList[0].description
                                          : _state
                                              .questionnaireList[position - 2]
                                              .description,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: _themeData
                                            .primaryTextTheme.subtitle.color
                                            .withAlpha(150),
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
    }
  }
}
