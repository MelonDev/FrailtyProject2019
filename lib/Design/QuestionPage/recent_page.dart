part of '../question_page.dart';

Widget recentPage(RecentQuestionState _state, BuildContext context) {
  var _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(context);
  ThemeData _themeData = Theme.of(context);

  return Container(
    color: _themeData.backgroundColor,
    child: ListView.builder(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 50),
      itemCount: _state.list.length,
      itemBuilder: (context, position) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: getCardColor(_themeData, _state.list, position)
              /*_state.list[position].answer != null
                  ? _themeData.accentColor
                  : _themeData.cardColor*/
              ),
          margin: EdgeInsets.fromLTRB(
              _state.list[position].question.category.length > 1 ? 60 : 20,
              0,
              20,
              10),
          child: FlatButton(
              splashColor: Colors.black12,
              onPressed: cardOnClick(_state.list, position,_questionnaireBloc),
              child: Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(16),
                  child: RichText(
                    maxLines: 3,
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                              text: _state.list[position].question.category
                                          .length >
                                      1
                                  ? "ข้อที่ ${_state.list[position].fromQuestion.position}.${_state.list[position].question.position}"
                                  : "ข้อที่ ${_state.list[position].question.position}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: getCardTextColor(
                                      _themeData,
                                      _state.list,
                                      position) /*_state.list[position].answer != null
                                      ? Colors.white
                                      : _themeData.primaryTextTheme.title.color
                                          .withAlpha(100)*/
                                  ,
                                  fontSize: 20,
                                  fontFamily: _themeData
                                      .primaryTextTheme.subtitle.fontFamily)),
                          TextSpan(
                              text:
                                  "\n${_state.list[position].question.message}",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: getCardTextColor(
                                      _themeData,
                                      _state.list,
                                      position) /*_state.list[position].answer != null
                                      ? Colors.white
                                      : _themeData.primaryTextTheme.title.color
                                          .withAlpha(100)*/
                                  ,
                                  fontSize: 18,
                                  fontFamily: _themeData
                                      .primaryTextTheme.subtitle.fontFamily))
                        ]),
                  ))),
          /*child: Text(
              _state.list[position].question.category.length > 1
                  ? "ข้อที่ ${_state.list[position].fromQuestion.position}.${_state.list[position].question.position}\n${_state.list[position].question.message}"
                  : "ข้อที่ ${_state.list[position].question.position}\n${_state.list[position].question.message}",
              maxLines: 2,
              semanticsLabel: ".",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _themeData.primaryTextTheme.title.color.withAlpha(170),
                  fontSize: 18,
                  fontFamily: _themeData.primaryTextTheme.subtitle.fontFamily)),

           */
        );
      },
    ),
  );
}

Widget recentPageTablet(MyQuestionnaireState _state, BuildContext context) {
  var _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(context);
  ThemeData _themeData = Theme.of(context);

  if (_state.list.length > 0) {
    MyPosition myPosition = _getPosition(_state.list);

    return Container(
      color: _themeData.backgroundColor,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(0, 30, 0, 50),
        itemCount: _state.list.length,
        itemBuilder: (context, position) {
          return FlatButton(
              onPressed: cardOnClick(_state.list, position,_questionnaireBloc),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: getCardColor(_themeData, _state.list,
                        position) /*_state.list[position].answer != null
                        ? _themeData.accentColor
                        : _themeData.cardColor
                        */
                    ),
                margin: EdgeInsets.fromLTRB(
                    _state.list[position].question.category.length > 1
                        ? 40
                        : 00,
                    0,
                    0,
                    10),
                padding: EdgeInsets.all(16),
                child: Container(
                    alignment: Alignment.topLeft,
                    child: FlatButton(
                        splashColor: Colors.black12,
                        child: RichText(
                          maxLines: 3,
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                    text: _state.list[position].question
                                                .category.length >
                                            1
                                        ? "ข้อที่ ${_state.list[position].fromQuestion.position}.${_state.list[position].question.position}"
                                        : "ข้อที่ ${_state.list[position].question.position}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            /*_state.list[position].answer != null
                                    ? Colors.white
                                    : _themeData.primaryTextTheme.title.color
                                        .withAlpha(100)*/
                                            getCardTextColor(_themeData,
                                                _state.list, position),
                                        fontSize: 20,
                                        fontFamily: _themeData.primaryTextTheme
                                            .subtitle.fontFamily)),
                                TextSpan(
                                    text:
                                        "\n${_state.list[position].question.message}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color:
                                            /*_state.list[position].answer != null
                                    ? Colors.white
                                    : _themeData.primaryTextTheme.title.color
                                        .withAlpha(100)*/
                                            getCardTextColor(_themeData,
                                                _state.list, position),
                                        fontSize: 18,
                                        fontFamily: _themeData.primaryTextTheme
                                            .subtitle.fontFamily))
                              ]),
                        ))),
                /*child: Text(
              _state.list[position].question.category.length > 1
                  ? "ข้อที่ ${_state.list[position].fromQuestion.position}.${_state.list[position].question.position}\n${_state.list[position].question.message}"
                  : "ข้อที่ ${_state.list[position].question.position}\n${_state.list[position].question.message}",
              maxLines: 2,
              semanticsLabel: ".",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: _themeData.primaryTextTheme.title.color.withAlpha(170),
                  fontSize: 18,
                  fontFamily: _themeData.primaryTextTheme.subtitle.fontFamily)),

           */
              ));
        },
      ),
    );
  } else {
    return Container(
      color: _themeData.backgroundColor,
    );
  }
}

Color getCardColor(
    ThemeData _themeData, List<QuestionWithChoice> list, int position) {
  Answer answer = list[position].answer;
  if (answer != null) {
    /*return _themeData.brightness == Brightness.dark
        ? Colors.white.withAlpha(230)
        : Colors.white.withAlpha(200);*/
    return _themeData.accentColor;
  } else {
    if (position > 0) {
      Answer lastAnswer = list[position - 1].answer;
      if (lastAnswer != null) {
        return _themeData.brightness == Brightness.dark
            ? Colors.white.withAlpha(230)
            : Colors.white.withAlpha(200);

        //return _themeData.accentColor;
      } else {
        return _themeData.brightness == Brightness.dark
            ? Color(0xFF212121)
            : Color(0xFF000000).withAlpha(20);
      }
    } else {
      return Colors.white.withAlpha(200);
    }
  }
}

Color getCardTextColor(
    ThemeData _themeData, List<QuestionWithChoice> list, int position) {
  Answer answer = list[position].answer;
  if (answer != null) {
    return Colors.white;
    //return Colors.black87;
  } else {
    if (position > 0) {
      Answer lastAnswer = list[position - 1].answer;
      if (lastAnswer != null) {
        //return Colors.white;
        return Colors.black87;
      } else {
        return _themeData.brightness == Brightness.dark
            ? Colors.white.withAlpha(150)
            : Color(0xFF000000).withAlpha(150);
      }
    } else {
      return Colors.black87;
    }
  }
}

Function cardOnClick(List<QuestionWithChoice> list, int position,QuestionnaireBloc questionnaireBloc) {
  Answer answer = list[position].answer;
  if (answer != null) {
    return () => cardClicked(list[position],questionnaireBloc);
  } else {

    if (position > 0) {
      Answer lastAnswer = list[position - 1].answer;
      if (lastAnswer != null) {
        return () => cardClicked(list[position],questionnaireBloc);
      } else {
        return null;
      }
    } else {
      return () => cardClicked(list[position],questionnaireBloc);
    }
  }
}

Function cardClicked(QuestionWithChoice questionWithChoice,QuestionnaireBloc questionnaireBloc) {
  //questionnaireBloc.add(LoadQuestionEvent(questionWithChoice));
  print("CardClicked");
}

class MyPosition {
  final int last;
  final int current;

  MyPosition(this.last, this.current);
}

MyPosition _getPosition(List<QuestionWithChoice> list) {
  int lastPosition = 0;

  for (int i = 0; i < list.length; i++) {
    if (list[i].answer != null) {
      lastPosition = i;
    }
  }

  if (lastPosition > 0) {
    return MyPosition(lastPosition - 1, lastPosition);
  } else {
    return MyPosition(0, 0);
  }
}
