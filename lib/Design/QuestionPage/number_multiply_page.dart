part of '../question_page.dart';

Widget _numberMultiplyPage(BuildContext context,NumberMultiplyQuestionState state) {
  ThemeData _themeData = Theme.of(context);

  var _questionnaireBloc = BlocProvider.of<QuestionnaireBloc>(context);

  bool _actionBtn = false;

  int myValue;

  return Container(
    color: _themeData.primaryColor,
    child: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 311),
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
                      maxFontSize: 28,
                      style: TextStyle(
                        fontSize: 28,
                        //color: Colors.black.withAlpha(200),
                        color: _themeData.primaryTextTheme.subtitle.color,
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
                              width: (MediaQuery
                                  .of(context)
                                  .size
                                  .width - 41) / 2,
                              color: _themeData.primaryColor,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      state.questionWithChoice.choices[0]
                                          .message,
                                      style: TextStyle(
                                          fontFamily: 'SukhumvitSet',
                                          fontSize: 22,
                                          //color: Colors.black.withAlpha(150),
                                          color: _themeData.primaryTextTheme.subtitle.color,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width:
                                    (MediaQuery
                                        .of(context)
                                        .size
                                        .width - 41) /
                                        2,
                                    height: 160,
                                    child: CupertinoPicker(
                                      offAxisFraction: 0.0,
                                      magnification: 1.5,
                                      backgroundColor: _themeData.primaryColor,
                                      children: List<Widget>.generate(
                                          state.numberList.length,
                                              (int index) {
                                            return Center(
                                              child: Text(
                                                state.numberList[index]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontFamily: 'SukhumvitSet',
                                                    fontSize: 22,
                                                    //color: Colors.black.withAlpha(200),
                                                    color: _themeData.primaryTextTheme.subtitle.color,
                                                    fontWeight: FontWeight
                                                        .bold),
                                              ),
                                            );
                                          }),
                                      itemExtent: 30,
                                      onSelectedItemChanged: (int value) {
                                        myValue = value;

                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            width: 1,
                            height: 160,
                            //color: Colors.black.withAlpha(30),
                            color: _themeData.dividerColor,
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              height: 215,
                              width: (MediaQuery
                                  .of(context)
                                  .size
                                  .width - 41) / 2,
                              color: _themeData.primaryColor,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      state.questionWithChoice.choices[1]
                                          .message,
                                      style: TextStyle(
                                          fontFamily: 'SukhumvitSet',
                                          fontSize: 22,
                                          //color: Colors.black.withAlpha(150),
                                          color: _themeData.primaryTextTheme.subtitle.color,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width:
                                    (MediaQuery
                                        .of(context)
                                        .size
                                        .width - 41) /
                                        2,
                                    height: 160,
                                    child: CupertinoPicker(
                                      offAxisFraction: 0.0,
                                      magnification: 1.5,
                                      backgroundColor: _themeData.primaryColor,
                                      children: List<Widget>.generate(
                                          state.numberList.length,
                                              (int index) {
                                            return Center(
                                              child: Text(
                                                state.numberList[index]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontFamily: 'SukhumvitSet',
                                                    fontSize: 22,
                                                    //color: Colors.black.withAlpha(200),
                                                    color: _themeData.primaryTextTheme.subtitle.color,
                                                    fontWeight: FontWeight
                                                        .bold),
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
                        color: _themeData.primaryColor,
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
                              _questionnaireBloc.dispatch(NextQuestionEvent(state.questionWithChoice.question.questionnaireId,state.questionWithChoice.question.id,null,""));

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