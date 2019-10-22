part of '../question_page.dart';

Widget mainPageAppbar(MyQuestionnaireState _state, BuildContext context) {
  ThemeData _themeData = Theme.of(context);
  var _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(context);

  return PreferredSize(
    preferredSize: Size.fromHeight(60.0),
    child: AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      titleSpacing: 0.0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      // Don't show the leading button
      title: Stack(
        children: <Widget>[
          Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    color: Colors.transparent,
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        children: <Widget>[
                          Device.get().isTablet ? Container() : MaterialButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            minWidth: 0,
                            height: 56,
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              _questionnaireBloc.add(RecentQuestionEvent(
                                  _questionnaireBloc.state
                                  is RecentQuestionState
                                      ? false
                                      : true,
                                  filterState(context, _state)));
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.low_priority,
                                    //color: Colors.black.withAlpha(180),
                                    color: _questionnaireBloc.state is RecentQuestionState ? Colors.black87 :
                                    _themeData.primaryTextTheme.title.color,
                                    size: 30,
                                  ),
                                ],
                              ),
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.fromLTRB(0, 6, 0, 6),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  color: _state is RecentQuestionState
                                      ? Colors.orange
                                      : Colors.transparent),
                            ),
                          ),
                          MaterialButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            minWidth: 0,
                            height: 56,
                            onPressed: () {
                              Navigator.pop(context, "I'M BACK");
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.close,
                                    //color: Colors.black.withAlpha(180),
                                    color:
                                        _themeData.primaryTextTheme.title.color,
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
                    )),
              ]),
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
                          width: double.infinity,
                          child: Row(
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 8, 0, 0),
                                          margin:
                                              EdgeInsets.fromLTRB(16, 0, 20, 0),
                                          child: _state.questionCounter != null
                                              ? (_state.questionCounter > 0
                                                  ? Text(
                                                      filterState(context, _state).fromQuestion != null ? "ข้อที่ ${filterState(context, _state).fromQuestion.position}.${filterState(context, _state).question.position}" :  "ข้อที่ ${filterState(context, _state).question.position}",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          //color: Colors.black.withAlpha(200),
                                                          color: _themeData
                                                              .primaryTextTheme
                                                              .title
                                                              .color,
                                                          fontFamily:
                                                              'SukhumvitSet',
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : _questionnaireBloc.state
                                                          is RecentQuestionState
                                                      ? Text(
                                                          "ทั้งหมด",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              //color: Colors.black.withAlpha(200),
                                                              color: _themeData
                                                                  .primaryTextTheme
                                                                  .title
                                                                  .color,
                                                              fontFamily:
                                                                  'SukhumvitSet',
                                                              fontSize: 22,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      : Container())
                                              : Container())),
                                ],
                              ),
                            ],
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

      brightness: _themeData.brightness,
      backgroundColor: _themeData.primaryColor,
      elevation: 0,
    ),
  );
}

QuestionWithChoice filterState(
    BuildContext context, MyQuestionnaireState _state) {
  if (_state is TextInputQuestionState) {
    return _state.questionWithChoice;
  } else if (_state is MultiplyQuestionState) {
    return _state.questionWithChoice;
  } else if (_state is LocationQuestionState) {
    return _state.questionWithChoice;
  } else if (_state is NumberMultiplyQuestionState) {
    return _state.questionWithChoice;
  } else if (_state is NumberQuestionState) {
    return _state.questionWithChoice;
  } else if (_state is TitleQuestionState) {
    return _state.questionWithChoice;
  } else if (_state is RecentQuestionState) {
    return _state.questionWithChoice;
  } else {
    return null;
  }
}
