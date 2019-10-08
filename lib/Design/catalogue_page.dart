import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frailty_project_2019/Bloc/catalogue/catalogue_bloc.dart';
import 'package:frailty_project_2019/Bloc/questionnaire/questionnaire_bloc.dart';
import 'package:frailty_project_2019/Design/question_page.dart';
import 'package:frailty_project_2019/Question.dart';
import 'package:frailty_project_2019/Tools/frailty_route.dart';
import 'package:frailty_project_2019/home.dart';

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

  @override
  void initState() {
    super.initState();
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
    _catalogueBloc = BlocProvider.of<CatalogueBloc>(this.context);
    //_catalogueBloc = CatalogueBloc();
    /*return BlocBuilder(
        bloc: _catalogueBloc,
        builder: (BuildContext context, CatalogueState _state) {
          return mainLayout(context, _state);
        });*/

    return BlocBuilder<CatalogueBloc, CatalogueState>(
        builder: (context, _state) {
          return mainLayout(context, _state);
        });
    /*
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

     */
  }

  Widget mainLayout(BuildContext context, CatalogueState _state) {
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
      return PlaceholderWidget(Colors.deepOrange);
    } else if (_state is CompletedCatalogueState) {
      return PlaceholderWidget(Colors.green);
    } else if (_state is LoadingCatalogueState) {
      return loadingTab();
    } else {
      return Container();
    }
  }

  Widget loadingTab(){
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


class QuestionnaireTab extends StatelessWidget {

  QuestionnaireCatalogueState _state;

  QuestionnaireTab(this._state);


  final List<String> _tabList = ["ชุดหลัก", "ชุดรอง"];

  @override
  Widget build(BuildContext context) {
    if (this._state == null) {
      return Container();
    }
    else {
      return Stack(
        children: <Widget>[
          Container(
            color: Color(0xFFE0E0E0),
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              itemCount: (_state.questionnaireList == null ? 0 :_tabList.length + _state.questionnaireList.length),
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
                    onTap: () =>
                    {
                      Navigator.push(
                          context,
                          //MaterialPageRoute(builder: (context) => SecondRoute()),
                          FrailtyRoute(
                              builder: (BuildContext context) =>

                                  MainQuestion(position == 1
                                      ? _state.questionnaireList[0].id
                                      : _state.questionnaireList[position - 2]
                                      .id)))



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
                                              ? _state.questionnaireList[0].name
                                              : _state
                                              .questionnaireList[position - 2]
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
                                          ? _state.questionnaireList[0]
                                          .description
                                          : _state.questionnaireList[position -
                                          2]
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
    }
  }
}
