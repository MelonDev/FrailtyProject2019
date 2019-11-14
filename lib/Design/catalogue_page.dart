import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frailty_project_2019/Bloc/catalogue/catalogue_bloc.dart';
import 'package:frailty_project_2019/Bloc/questionnaire/questionnaire_bloc.dart';
import 'package:frailty_project_2019/Design/question_page.dart';
import 'package:frailty_project_2019/Design/result_page.dart';
import 'package:frailty_project_2019/Model/Questionnaire.dart';
import 'package:frailty_project_2019/Model/UncompletedData.dart';
import 'package:frailty_project_2019/Question.dart';
import 'package:frailty_project_2019/Tools/frailty_route.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CataloguePage extends StatefulWidget {
  CataloguePage();

  @override
  _cataloguePage createState() => _cataloguePage();
}

class _cataloguePage extends State<CataloguePage> {
  final List<String> _tabList = ["แบบทดสอบ", "ยังทำไม่เสร็จ", "ทำเสร็จแล้ว"];
  final List<IconData> _tabListIcon = [
    Icons.assignment,
    Icons.history,
    Icons.check
  ];

  //CatalogueBloc _catalogueBloc; = CatalogueBloc();

  CatalogueBloc _catalogueBloc;

  String _titleText = "แบบทดสอบ";

  int _currentIndex = 0;

  ThemeData _themeData;

  @override
  void initState() {
    super.initState();
    _catalogueBloc = BlocProvider.of<CatalogueBloc>(this.context);

    _catalogueBloc.add(QuestionnaireSelectedEvent());
  }

  List<Widget> _tabChildren = [
    QuestionnaireTab(null),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green)
  ];

  void onTabTapped(int index) {
    if (index == 0) {
      _catalogueBloc.add(QuestionnaireSelectedEvent());
    } else if (index == 1) {
      _catalogueBloc.add(UncompletedSelectedEvent());
    } else if (index == 2) {
      _catalogueBloc.add(CompletedSelectedEvent());
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
                              color: _themeData.primaryTextTheme.title.color,
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
      bottomNavigationBar: Device.get().isTablet
          ? null
          : BottomNavigationBar(
              selectedItemColor: Color(0xFF00BFA5),
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
                      style:
                          TextStyle(fontFamily: 'SukhumvitSet', fontSize: 16),
                    ))
              ],
            ),
      //body: _tabChildren[_currentIndex],
      body: Device.get().isTablet
          ? _loadTabletSize(_state)
          : _loadWidgetToLayout(_state),
    );
  }

  Widget _loadTabletSize(CatalogueState _state) {
    return Row(
      children: <Widget>[
        Container(
          width: 260,
          color: DynamicTheme.of(context).brightness == Brightness.dark
              ? Color(0xFF121212)
              : Color(0xFFe8e8e8),
          child: _sideBar(_state),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 260,
          child: _loadWidgetToLayout(_state),
        )
      ],
    );
  }

  Widget _sideBar(CatalogueState _state) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: ListView.builder(
          itemCount: _tabList.length,
          itemBuilder: (context, position) {
            if (_currentIndex == position) {
              return Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: Colors.teal),
                height: 60,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        _tabListIcon[position],
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text(
                          _tabList[position],
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'SukhumvitSet',
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  onTabTapped(position);
                },
                child: Container(
                    color: Colors.transparent,
                    height: 60,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            _tabListIcon[position],
                            color: _themeData.primaryTextTheme.subtitle.color,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Text(
                              _tabList[position],
                              style: TextStyle(
                                  color: _themeData
                                      .primaryTextTheme.subtitle.color,
                                  fontFamily: 'SukhumvitSet',
                                  fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    )),
              );
            }
          }),
    );
  }

  Widget _loadWidgetToLayout(CatalogueState _state) {
    if (_state is InitialCatalogueState) {
      _catalogueBloc.add(QuestionnaireSelectedEvent());
      return PlaceholderWidget(Colors.yellow);
    } else if (_state is QuestionnaireCatalogueState) {
      return QuestionnaireTab(_state);
    } else if (_state is UncompletedCatalogueState) {
      return UncompletedTab(_state);
    } else if (_state is CompletedCatalogueState) {
      return CompletedTab(_state);
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
          color: _themeData.primaryTextTheme.subtitle.color,
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

class CompletedTab extends StatelessWidget {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  CatalogueBloc _catalogueBloc;

  CompletedCatalogueState _state;

  CompletedTab(this._state);

  ThemeData _themeData;

  Function reloadUncomplete() {
    _catalogueBloc.add(CompletedSelectedEvent());
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);

    _catalogueBloc = BlocProvider.of<CatalogueBloc>(context);

    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(maxWidth: 500),
              //color: Color(0xFFE0E0E0),
              color: _themeData.backgroundColor,
              child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  itemCount: _state.data.length,
                  itemBuilder: (context, position) {
                    if (_state.data[position].answerPack != null) {
                      return _cardWidget(context, position);
                    } else if (_state.data[position].labelDateTime != null) {
                      return Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 6),
                          child: Text(
                            _loadDateForLabel(
                                _state.data[position].labelDateTime),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color:
                                    _themeData.primaryTextTheme.subtitle.color,
                                fontFamily: _themeData
                                    .primaryTextTheme.subtitle.fontFamily),
                          ));
                    } else {
                      return Container();
                    }
                  }))
        ]);
  }

  Widget _cardWidget(BuildContext context, int position) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(context,
            FrailtyRoute(builder: (BuildContext context) => ResultPage(keyS: _state.data[position].questionnaire.id,questionnaireName: _state.data[position].questionnaire.name,answerPackId: _state.data[position].answerPack.id,dateTime: _state.data[position].answerPack.dateTime,)))
      },
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

  String _loadDateForLabel(String date) {
    var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    DateTime dateTime = formatter.parse(date);
    return "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year + 543}";
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

class UncompletedTab extends StatelessWidget {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  CatalogueBloc _catalogueBloc;

  UncompletedCatalogueState _state;

  UncompletedTab(this._state);

  ThemeData _themeData;

  Function reloadUncomplete() {
    _catalogueBloc.add(UncompletedSelectedEvent());
  }

  @override
  Widget build(BuildContext context) {
    _themeData = Theme.of(context);

    _catalogueBloc = BlocProvider.of<CatalogueBloc>(context);

    if (this._state == null) {
      return Container();
    } else if (_state.data.length == 0) {
      return emptyWidget();
    } else {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(maxWidth: 500),
            //color: Color(0xFFE0E0E0),
            color: _themeData.backgroundColor,

            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              itemCount: _state.data.length,
              itemBuilder: (context, position) {
                if (_state.data[position].uncompletedData != null) {
                  return Slidable(
                    actionPane: SlidableBehindActionPane(),
                    actionExtentRatio: 0.25,
                    child: _cardWidget(context, position),
                    secondaryActions: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 16, 16),
                        child: IconSlideAction(
                          caption: 'ลบ',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? new CupertinoAlertDialog(
                                            title: new Text(
                                              "ยืนยันการลบ",
                                              style: TextStyle(
                                                  fontFamily: _themeData
                                                      .primaryTextTheme
                                                      .subtitle
                                                      .fontFamily,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white
                                                      .withAlpha(200)),
                                            ),
                                            content: new Text(
                                                "หากคุณต้องการจบบันทึกอันนี้ให้กดปุ่มยืนยัน",
                                                style: TextStyle(
                                                    fontFamily: _themeData
                                                        .primaryTextTheme
                                                        .subtitle
                                                        .fontFamily,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white
                                                        .withAlpha(200)
                                                        .withAlpha(150))),
                                            actions: [
                                              CupertinoDialogAction(
                                                isDestructiveAction: true,
                                                child: new Text("ยืนยัน",
                                                    style: TextStyle(
                                                        fontFamily: _themeData
                                                            .primaryTextTheme
                                                            .subtitle
                                                            .fontFamily,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.red)),
                                                onPressed: () {
                                                  _catalogueBloc.add(
                                                      UncompletedDeleteItemEvent(
                                                          _state.data[position]
                                                              .uncompletedData));
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              CupertinoDialogAction(
                                                child: new Text("ยกเลิก",
                                                    style: TextStyle(
                                                        fontFamily: _themeData
                                                            .primaryTextTheme
                                                            .subtitle
                                                            .fontFamily,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.white
                                                            .withAlpha(200))),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          )
                                        : new CupertinoAlertDialog(
                                            title: new Text(
                                              "ยืนยันการลบ",
                                              style: TextStyle(
                                                  fontFamily: _themeData
                                                      .primaryTextTheme
                                                      .subtitle
                                                      .fontFamily,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black
                                                      .withAlpha(180)),
                                            ),
                                            content: new Text(
                                                "หากคุณต้องการจบบันทึกอันนี้ให้กดปุ่มยืนยัน",
                                                style: TextStyle(
                                                    fontFamily: _themeData
                                                        .primaryTextTheme
                                                        .subtitle
                                                        .fontFamily,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black
                                                        .withAlpha(180)
                                                        .withAlpha(150))),
                                            actions: [
                                              CupertinoDialogAction(
                                                isDestructiveAction: true,
                                                child: new Text("ยืนยัน",
                                                    style: TextStyle(
                                                        fontFamily: _themeData
                                                            .primaryTextTheme
                                                            .subtitle
                                                            .fontFamily,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.red)),
                                                onPressed: () {
                                                  _catalogueBloc.add(
                                                      UncompletedDeleteItemEvent(
                                                          _state.data[position]
                                                              .uncompletedData));
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              CupertinoDialogAction(
                                                child: new Text("ยกเลิก",
                                                    style: TextStyle(
                                                        fontFamily: _themeData
                                                            .primaryTextTheme
                                                            .subtitle
                                                            .fontFamily,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.black
                                                            .withAlpha(180))),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ));
                          },
                        ),
                      )
                    ],
                  );
                } else if (_state.data[position].labelDateTime != null) {
                  return Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 6),
                      child: Text(
                        _loadDateForLabel(_state.data[position].labelDateTime),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: _themeData.primaryTextTheme.subtitle.color,
                            fontFamily: _themeData
                                .primaryTextTheme.subtitle.fontFamily),
                      ));
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      );
    }
  }

  void _resumeQuestion(BuildContext context, int position) {
    Navigator.push(context,
        //MaterialPageRoute(builder: (context) => SecondRoute()),
        FrailtyRoute(builder: (BuildContext context) {
      UncompletedData slot = _state.data[position].uncompletedData;
      return MainQuestion(slot.questionnaire.id, slot.answerPack.id);
    })).then((value) {
      _catalogueBloc.add(UncompletedSelectedEvent());
    });
  }

  Widget emptyWidget() {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.rounded_corner,
              size: 70,
              color: _themeData.brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
            ),
            SizedBox(
              height: 20,
            ),
            Text("ไม่พบข้อมูล",
                style: TextStyle(
                    fontFamily: _themeData.primaryTextTheme.subtitle.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: _themeData.brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54))
          ],
        ),
      ),
    );
  }

  Widget _cardWidget(BuildContext context, int position) {
    return GestureDetector(
      onTap: () => {_resumeQuestion(context, position)},
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
                        percent: _calculatePercent(
                            _state.data[position].uncompletedData.totalQuestion
                                .toDouble(),
                            _state.data[position].uncompletedData
                                .completedQuestion
                                .toDouble()),
                        style: RoundedProgressBarStyle(
                            colorBorder: _themeData.backgroundColor,
                            backgroundProgress: _themeData.backgroundColor,
                            colorProgress: _themeData.canvasColor,
                            borderWidth: 1,
                            widthShadow: 0),
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
                                      "${_state.data[position].uncompletedData.answerPack.id}",
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
                                    "${_state.data[position].uncompletedData.completedQuestion} จาก ${_state.data[position].uncompletedData.totalQuestion} ข้อ",
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
                                    "${_loadDate(_state.data[position].uncompletedData.answerPack.dateTime)}",
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
                                    "\n${_state.data[position].uncompletedData.questionnaire.name}",
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

  double _calculatePercent(double full, double current) {
    return (current * 100) / full;
  }

  String _loadDateForLabel(String date) {
    var formatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    DateTime dateTime = formatter.parse(date);
    return "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year + 543}";
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
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(maxWidth: 500),
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
                      Navigator.push(context,
                          //MaterialPageRoute(builder: (context) => SecondRoute()),
                          FrailtyRoute(builder: (BuildContext context) {
                        Questionnaire questionnaire = position == 1
                            ? _state.questionnaireList[0]
                            : _state.questionnaireList[position - 2];
                        return MainQuestion(questionnaire.id, null);
                      }))
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
