part of '../question_page.dart';

Widget _numberPage(BuildContext context, NumberQuestionState state) {
  ThemeData _themeData = Theme.of(context);

  var _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(context);

  bool _actionBtn = false;

  int myValue = 0;

  return Container(
    color: _themeData.primaryColor,
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
              //color: Color(0xFFEDEDED),
              color: _themeData.backgroundColor,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: AutoSizeText(
                    state.questionWithChoice.question.message,
                    minFontSize: 16,
                    maxFontSize: 34,
                    style: TextStyle(
                      fontSize: 34,
                      //color: Colors.black.withAlpha(200),
                      color: _themeData.primaryTextTheme.subtitle.color,
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
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: CupertinoPicker(
                    useMagnifier: true,
                    offAxisFraction: 0.0,
                    magnification: 1.3,
                    backgroundColor: _themeData.primaryColor,
                    children: List<Widget>.generate(state.numberList.length,
                        (int index) {
                      return Center(
                        child: Text(
                          state.numberList[index].toString(),
                          style: TextStyle(
                              fontFamily: 'SukhumvitSet',
                              fontSize: 22,
                              //color: Colors.black.withAlpha(200),
                              color: _themeData.primaryTextTheme.subtitle.color,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                    itemExtent: 30,
                    onSelectedItemChanged: (int value) {
                      myValue = value;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 6, 30, 36),
                  width: MediaQuery.of(context).size.width,
                  height: 96,
                  color: _themeData.primaryColor,
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
                        //print(myValue);
                        _questionnaireBloc.add(NextQuestionEvent(
                            state.questionWithChoice.question.questionnaireId,
                            state.questionWithChoice.question.id,
                            null,
                            state.numberList[myValue].toString(),
                            state.list,
                            state.questionWithChoice));
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
